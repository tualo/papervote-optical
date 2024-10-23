DELIMITER //

CREATE OR REPLACE PROCEDURE `proc_sz_rois_item_height`()
BEGIN
    for rec in (select id as sz_rois_id from sz_rois)
    do
        set @c = (select count(*) from kandidaten_bp_column where kandidaten_bp_column.sz_rois_id = rec.sz_rois_id and kandidaten_id_checked=1);
        if (@c>0) then
            update sz_rois set item_height = (sz_rois.height - ((
                select count(*) from kandidaten_bp_column where kandidaten_bp_column.sz_rois_id = rec.sz_rois_id and kandidaten_id_checked=1
            )-1)* if(sz_rois.item_cap_y=0,0.5,sz_rois.item_cap_y)
            ) / (
                select count(*) from kandidaten_bp_column where kandidaten_bp_column.sz_rois_id = rec.sz_rois_id and kandidaten_id_checked=1
            )
        where sz_rois.id = rec.sz_rois_id;
        end if;
    end for;

    for rec in (
        select 
            kandidaten_bp_column.position,
            kandidaten_bp_column.kandidaten_id, 
            kandidaten_bp_column.stimmzettelgruppen_id,
            view_readtable_kandidaten_bp_column.position xposition
        from 
            kandidaten_bp_column 
            join view_readtable_kandidaten_bp_column 
            on 
            (view_readtable_kandidaten_bp_column.kandidaten_id, view_readtable_kandidaten_bp_column.stimmzettelgruppen_id) = (kandidaten_bp_column.kandidaten_id, kandidaten_bp_column.stimmzettelgruppen_id)

        where kandidaten_bp_column.position <> view_readtable_kandidaten_bp_column.position
        )
    do
        update kandidaten_bp_column 
            set position = rec.xposition
        where 
            kandidaten_id = rec.kandidaten_id
            and stimmzettelgruppen_id=rec.stimmzettelgruppen_id;
    end for;
END //
call proc_sz_rois_item_height() //

