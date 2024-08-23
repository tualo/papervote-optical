DELIMITER //

CREATE OR REPLACE TRIGGER `kandidaten_bp_column_au_itemheight` 
AFTER UPDATE ON `kandidaten_bp_column` FOR EACH ROW
BEGIN

    -- item_cap_y
    update sz_rois set item_height = (height - ((
        select count(*) from kandidaten_bp_column where sz_rois_id = new.sz_rois_id and kandidaten_id_checked=1
    )-1)*item_cap_y
    ) / (
        select count(*) from kandidaten_bp_column where sz_rois_id = new.sz_rois_id and kandidaten_id_checked=1
    )
    where id = new.sz_rois_id;

END //