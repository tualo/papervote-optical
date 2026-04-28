create or replace view view_papervote_roi_config   as
with roi as (
-- 
    select
        stimmzettel.id,
        sz_rois.id roi_id,
        sz_rois.name roi_name,
        sz_rois.x   roi_x,
        sz_rois.y   roi_y,
        sz_rois.width roi_width,
        sz_rois.height roi_height,
        sz_rois.item_height roi_item_height,
        sz_rois.item_cap_y roi_item_cap_y,
        sz_page_sizes.width page_width,
        sz_page_sizes.height page_height,
stimmzettel.sitze max_allowed
    from
        stimmzettel
        join stimmzettel_roi
            on stimmzettel_roi.stimmzettel_id = stimmzettel.id
        join sz_rois
            on stimmzettel_roi.sz_rois_id = sz_rois.id
        left join sz_to_region
            on sz_to_region.id_sz = stimmzettel.id
        left join sz_titel_regions
            on  sz_titel_regions.id = sz_to_region.id_sz_titel_regions
        join sz_to_page_sizes
            on sz_to_page_sizes.id_sz = stimmzettel.id
        join sz_page_sizes
            on  sz_to_page_sizes.id_sz_page_sizes = sz_page_sizes.id
 
), cnt as (
    select sz_rois_id,count(*) cnt from  kandidaten_bp_column group by sz_rois_id
)
 
    select
        stimmzettel.id,
        roi.roi_id,
        111 roi_x,

        80 + 2  roi_y,
        13 roi_item_width,
        17 roi_item_height,
        3 roi_item_cap_y,
        roi.roi_width,
        roi.page_width,
        roi.page_height,
        cnt.cnt ,
        max_allowed
        
    from
        stimmzettel
        join roi
        on stimmzettel.id = roi.id
        join cnt on roi.roi_id = cnt.sz_rois_id