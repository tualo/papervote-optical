delimiter ;

create or replace view view_readtable_sz_rois as
select 
    sz_rois.*,
    stimmzettel_roi.stimmzettel_id
from 
    sz_rois 
    left join  stimmzettel_roi
        on stimmzettel_roi.sz_rois_id = sz_rois.id
;

