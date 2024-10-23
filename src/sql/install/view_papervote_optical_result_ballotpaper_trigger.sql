delimiter  //

CREATE OR REPLACE FUNCTION `getRequestPagination`() RETURNS bigint
    DETERMINISTIC
BEGIN
    return @request_pagination;
END //


create
or replace view `view_papervote_optical_result_ballotpaper_trigger` as

with setup as (
    select
        `papervote_optical`.`pagination_id`,
        `papervote_optical`.`box_id`,
        `papervote_optical`.`stack_id`,
        `papervote_optical`.`modified`,
        `papervote_optical`.`created`,
        `papervote_optical`.`edited_marks`,
        `papervote_optical`.`marks`,
        `papervote_optical`.`ballotpaper_id`,
        `papervote_optical`.pre_processed,
        `papervote_optical`.login,
        `papervote_optical`.is_final,
        if ( `papervote_optical`.edited_marks<>'[]' and `papervote_optical`.edited_marks<> `papervote_optical`.marks, 1,  0 ) is_pending,
        length(REGEXP_REPLACE(`papervote_optical`.marks, '[^X]', '')) anzahl_stimmzettel_kreuze,
        json_length(`papervote_optical`.`marks`) anzahl_markierungen


    from 
        papervote_optical
    where 
        getRequestPagination() = pagination_id
),
config as (
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
        setup
        join stimmzettel
            on stimmzettel.id = setup.ballotpaper_id

        join stimmzettelgruppen
            on stimmzettelgruppen.stimmzettel = stimmzettel.ridx
        join kandidaten
            on kandidaten.stimmzettelgruppen = stimmzettelgruppen.ridx

        join kandidaten_bp_column
            on kandidaten_bp_column.stimmzettelgruppen_id = stimmzettelgruppen.id
            and kandidaten_bp_column.kandidaten_id = kandidaten.id
            and kandidaten_id_checked=1
        join sz_rois
            on sz_rois.id = kandidaten_bp_column.sz_rois_id
        join stimmzettel_roi
            on 
            sz_rois.id = stimmzettel_roi.sz_rois_id
            and stimmzettel.id = stimmzettel_roi.stimmzettel_id

)
select
    json_value(
        `papervote_optical`.`marks`,
        concat(
            '$[',
            config.result_index - 1,
            ']'
        )
    ) AS `marked`,
    json_value(
        `papervote_optical`.`edited_marks`,
        concat(
            '$[',
            config.result_index - 1,
            ']'
        )
    ) AS `edited_marked`,
    `papervote_optical`.`pagination_id`,
    `papervote_optical`.`box_id`,
    `papervote_optical`.`stack_id`,
    `papervote_optical`.`modified`,
    `papervote_optical`.`created`,
    `papervote_optical`.`ballotpaper_id`,
    
    `config`.`result_index`,
    `config`.`kandidaten_id`,
    `config`.`stimmzettel_id`,
    `config`.`sz_rois_id`,
    `config`.`anzeige_name`,
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
    setup `papervote_optical`
    join 
    config on(
        `papervote_optical`.`ballotpaper_id` = `config`.`stimmzettel_id`
    )
    join `stimmzettel` on(
        `config`.`stimmzettel_id` = `stimmzettel`.`id`
    )
    join `stimmzettelgruppen` on(
        `config`.`stimmzettelgruppen_id` = `stimmzettelgruppen`.`id`
    )
    group by papervote_optical.pagination_id, config.kandidaten_id

     //



