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
        ) result_index,

        sz_rois.id roi_id,
        sz_rois.name roi_name,
        sz_rois.x   roi_x,
        sz_rois.y   roi_y,
        sz_rois.width roi_width,
        sz_rois.height roi_height,

        
        sz_rois.item_height roi_item_height,
        sz_rois.item_cap_y roi_item_cap_y,

        sz_page_sizes.width page_width,
        sz_page_sizes.height page_height

    from 
        stimmzettel
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