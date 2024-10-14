DELIMITER;

/*

- Als endgültig markiert
- vorverarbeitet
- Pending

- Stimmzettel nicht erkannt
- Stimmzettel gemeldet

- Stimmzettel ungültig
- Stimmzettel enthaltung

- Stimmzettelgruppen ungültig
- Stimmzettelgruppen enthaltung

- Vom Wahlausschuss bearbeitet



*/

create
or replace view `view_papervote_optical_result_ballotpaper` as
select
    json_value(
        `papervote_optical`.`marks`,
        concat(
            '$[',
            view_readtable_kandidaten_bp_column.result_index - 1,
            ']'
        )
    ) AS `marked`,
    json_value(
        `papervote_optical`.`edited_marks`,
        concat(
            '$[',
            view_readtable_kandidaten_bp_column.result_index - 1,
            ']'
        )
    ) AS `edited_marked`,
    `papervote_optical`.`pagination_id`,
    `papervote_optical`.`box_id`,
    `papervote_optical`.`stack_id`,
    `view_readtable_kandidaten_bp_column`.`result_index`,
    `view_readtable_kandidaten_bp_column`.`kandidaten_id`,
    `view_readtable_kandidaten_bp_column`.`stimmzettel_id`,
    `view_readtable_kandidaten_bp_column`.`sz_rois_id`,
    `view_readtable_kandidaten_bp_column`.`anzeige_name`,
    json_length(`papervote_optical`.`marks`) anzahl_markierungen,
    `papervote_optical`.`marks`,
    length(REGEXP_REPLACE(marks, '[^X]', '')) anzahl_stimmzettel_kreuze,

    if ( `stimmzettel`.`sitze`<length(REGEXP_REPLACE(marks, '[^X]', '')) , 1, 0) as stimmzettel_ungueltig,
    if ( length(REGEXP_REPLACE(marks, '[^X]', ''))=0, 1, 0) as stimmzettel_enthaltung,
    
    `stimmzettel`.`name` as `stimmzettel_name`,
    `stimmzettel`.`sitze` as `stimmzettel_sitze`,
    `stimmzettelgruppen`.`name` as `stimmzettelgruppen_name`,
    `stimmzettelgruppen`.`id` as `stimmzettelgruppen_id`,
    `stimmzettelgruppen`.`sitze` as `stimmzettelgruppen_sitze`,

    papervote_optical.edited_marks,

    if (
        papervote_optical.edited_marks<>'[]'
        and papervote_optical.edited_marks<> papervote_optical.marks,
        1,
        0
    ) is_pending,
    
    papervote_optical.pre_processed,

    papervote_optical.login,
    papervote_optical.is_final

from
    `papervote_optical`
    join 
    (
            select 
                kandidaten_bp_column.kandidaten_id,
                stimmzettel.id stimmzettel_id,
                kandidaten_bp_column.stimmzettelgruppen_id,
                kandidaten_bp_column.sz_rois_id,
                kandidaten_bp_column.kandidaten_id_checked,
                kandidaten_bp_column.position,
                kandidaten.nachname anzeige_name,
                sz_rois.x,
                sz_rois.y,
                rank() over (
                    partition by 
                        stimmzettel.id
                    order by 
                        sz_rois.x,
                        sz_rois.y,
                        kandidaten_bp_column.position
                ) result_index
            from 
                kandidaten_bp_column
                join sz_rois
                    on sz_rois.id = kandidaten_bp_column.sz_rois_id
                join stimmzettelgruppen
                    on stimmzettelgruppen.id = kandidaten_bp_column.stimmzettelgruppen_id
                join stimmzettel
                    on stimmzettelgruppen.stimmzettel = stimmzettel.ridx
                join kandidaten
                    on kandidaten.id = kandidaten_bp_column.kandidaten_id
            where 
                kandidaten_id_checked=1

    )    `view_readtable_kandidaten_bp_column` on(
        `papervote_optical`.`ballotpaper_id` = `view_readtable_kandidaten_bp_column`.`stimmzettel_id`
    )
    join `stimmzettel` on(
        `view_readtable_kandidaten_bp_column`.`stimmzettel_id` = `stimmzettel`.`id`
    )
    join `stimmzettelgruppen` on(
        `view_readtable_kandidaten_bp_column`.`stimmzettelgruppen_id` = `stimmzettelgruppen`.`id`
    );

create
or replace view `view_papervote_optical_result_ballotpaper_groups` as
select 
    view_papervote_optical_result_ballotpaper.*,
    sum(if(marked='X',1,0)) stimmzettelgruppen_summe,

    if(stimmzettelgruppen_sitze<sum(if(marked='X',1,0)),1,0) stimmzettelgruppen_ungueltig,
    if( sum(if(marked='X',1,0)) = 0 ,1,0) stimmzettelgruppen_enthaltung


from view_papervote_optical_result_ballotpaper
group by 
    pagination_id,
    stimmzettelgruppen_id;


create or replace view view_papervote_optical_result as
select 
    a.*,
    if(
        (
        is_pending +
        pre_processed +
        stimmzettel_ungueltig +
        stimmzettel_enthaltung +
        is_informed
    )>0 and is_final <> 1,
        1,
        0
    )
     for_review
from (
select 

    view_papervote_optical_result_ballotpaper.marked,
    view_papervote_optical_result_ballotpaper.pagination_id,
    `view_papervote_optical_result_ballotpaper`.`box_id`,
    `view_papervote_optical_result_ballotpaper`.`stack_id`,
    view_papervote_optical_result_ballotpaper.result_index,
    view_papervote_optical_result_ballotpaper.kandidaten_id,
    view_papervote_optical_result_ballotpaper.stimmzettel_id,
    view_papervote_optical_result_ballotpaper.sz_rois_id,
    view_papervote_optical_result_ballotpaper.anzeige_name,
    view_papervote_optical_result_ballotpaper.anzahl_markierungen,
    view_papervote_optical_result_ballotpaper.marks,
    view_papervote_optical_result_ballotpaper.anzahl_stimmzettel_kreuze,
    if(max(view_papervote_optical_result_ballotpaper_groups.stimmzettelgruppen_ungueltig)>0,1,view_papervote_optical_result_ballotpaper.stimmzettel_ungueltig) stimmzettel_ungueltig,
    view_papervote_optical_result_ballotpaper.stimmzettel_enthaltung,
    view_papervote_optical_result_ballotpaper.stimmzettel_name,
    view_papervote_optical_result_ballotpaper.stimmzettel_sitze,
    view_papervote_optical_result_ballotpaper.stimmzettelgruppen_name,
    view_papervote_optical_result_ballotpaper.stimmzettelgruppen_id,
    view_papervote_optical_result_ballotpaper.stimmzettelgruppen_sitze,
    
    max(view_papervote_optical_result_ballotpaper_groups.stimmzettelgruppen_ungueltig) as stimmzettelgruppen_ungueltig,
    max(view_papervote_optical_result_ballotpaper_groups.stimmzettelgruppen_enthaltung) as stimmzettelgruppen_enthaltung,
    view_papervote_optical_result_ballotpaper.is_final,
    if (view_papervote_optical_result_ballotpaper.marks='[]',1,0) is_informed,
    
    view_papervote_optical_result_ballotpaper.pre_processed,
    view_papervote_optical_result_ballotpaper.is_pending,
    view_papervote_optical_result_ballotpaper.login,
    view_papervote_optical_result_ballotpaper.edited_marks

    from 
        view_papervote_optical_result_ballotpaper_groups
        join view_papervote_optical_result_ballotpaper
            on view_papervote_optical_result_ballotpaper_groups.pagination_id = view_papervote_optical_result_ballotpaper.pagination_id
group by view_papervote_optical_result_ballotpaper.pagination_id
) a

;