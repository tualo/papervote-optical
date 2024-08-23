DELIMITER;

/*
create
or replace view `view_papervote_optical_result` as
select
    `papervote_optical`.`pagination_id` AS `pagination_id`,
    `stimmzettel`.`id` AS `stimmzettel_id`,
    `stimmzettel`.`name` AS `stimmzettel_name`,
    `kandidaten`.`anzeige_name` AS `anzeige_name`,
    `kandidaten`.`bp_column` AS `bp_column`,
    rank() over (
        partition by `papervote_optical`.`pagination_id`,
        `stimmzettel`.`id`,
        `kandidaten`.`bp_column`
        order by
            `kandidaten`.`barcode`
    ) AS `bp_pos`,
    rank() over (
        partition by `papervote_optical`.`pagination_id`,
        `stimmzettel`.`id`
        order by
            `kandidaten`.`barcode`
    ) AS `pos`,
    json_value(
        `papervote_optical`.`marks`,
        concat(
            '$[',
            rank() over (
                partition by `papervote_optical`.`pagination_id`,
                `stimmzettel`.`id`
                order by
                    `kandidaten`.`barcode`
            ) - 1,
            ']'
        )
    ) AS `marked`
from
    (
        (
            (
                `view_readtable_kandidaten` `kandidaten`
                join `stimmzettelgruppen` on(
                    `kandidaten`.`stimmzettelgruppen` = `stimmzettelgruppen`.`ridx`
                )
            )
            join `stimmzettel` on(
                `stimmzettelgruppen`.`stimmzettel` = `stimmzettel`.`ridx`
            )
        )
        join `papervote_optical` on(
            `papervote_optical`.`ballotpaper_id` = `stimmzettel`.`id`
        )
    );
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
    `papervote_optical`.`pagination_id`,
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
    `stimmzettelgruppen`.`sitze` as `stimmzettelgruppen_sitze`
from
    `papervote_optical`
    join `view_readtable_kandidaten_bp_column` on(
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
    view_papervote_optical_result_ballotpaper.*,
    
    max(view_papervote_optical_result_ballotpaper_groups.stimmzettelgruppen_ungueltig) as stimmzettelgruppen_ungueltig,
    max(view_papervote_optical_result_ballotpaper_groups.stimmzettelgruppen_enthaltung) as stimmzettelgruppen_enthaltung

    from 
        view_papervote_optical_result_ballotpaper_groups
        join view_papervote_optical_result_ballotpaper
            on view_papervote_optical_result_ballotpaper_groups.pagination_id = view_papervote_optical_result_ballotpaper.pagination_id
group by view_papervote_optical_result_ballotpaper.pagination_id;
