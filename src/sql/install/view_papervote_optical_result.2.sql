
create
or replace view `view_papervote_optical_result_ballotpaper2` as

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


    from papervote_optical
    where 
        pagination_id = 4156054
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
)
select * from config