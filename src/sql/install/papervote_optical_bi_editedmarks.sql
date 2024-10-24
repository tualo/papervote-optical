DELIMITER //


CREATE OR REPLACE TRIGGER `papervote_optical_bi_editedmarks` 
BEFORE INSERT ON `papervote_optical` FOR EACH ROW
BEGIN
    declare nv longtext;


    with x as (select 
            'W' notmarked,
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
    )
    select json_arrayagg(notmarked) e
    into nv 
    from x
    where stimmzettel_id=new.ballotpaper_id;
    set new.edited_marks = nv;


end //




CREATE OR REPLACE TRIGGER `papervote_optical_bu_editedmarks` 
BEFORE UPDATE ON `papervote_optical` FOR EACH ROW
BEGIN
    declare nv longtext;

    if new.marks="[]" and (new.edited_marks is null or new.edited_marks="[]") then

        with x as (select 
                'W' notmarked,
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
        )
        select json_arrayagg(notmarked) e
        into nv 
        from x
        where stimmzettel_id=new.ballotpaper_id;
        set new.edited_marks = nv;
    end if;

    if new.edited_marks="[]" then
        with x as (
            select 
                'W' notmarked,
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
        )
        select json_arrayagg(notmarked) e
        into nv 
        from x
        where stimmzettel_id=new.ballotpaper_id;
        set new.edited_marks = nv;
    end if;
end //
