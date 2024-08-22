delimiter ;


CREATE TABLE IF NOT EXISTS `kandidaten_bp_column` (
  `kandidaten_id` int(11) NOT NULL,
  `stimmzettelgruppen_id` int(11) NOT NULL,
  `sz_rois_id` int(11) NOT NULL,
  PRIMARY KEY (`kandidaten_id`,`stimmzettelgruppen_id`),
  KEY `fk_kandidaten_bp_column_stimmzettelgruppen_id` (`stimmzettelgruppen_id`),
  KEY `fk_kandidaten_bp_column_sz_rois_id` (`sz_rois_id`),
  CONSTRAINT `fk_kandidaten_bp_column_kandidaten_id` FOREIGN KEY (`kandidaten_id`) REFERENCES `kandidaten` (`id`),
  CONSTRAINT `fk_kandidaten_bp_column_stimmzettelgruppen_id` FOREIGN KEY (`stimmzettelgruppen_id`) REFERENCES `stimmzettelgruppen` (`id`),
  CONSTRAINT `fk_kandidaten_bp_column_sz_rois_id` FOREIGN KEY (`sz_rois_id`) REFERENCES `sz_rois` (`id`)
);

alter table kandidaten_bp_column add column if not exists  kandidaten_id_checked tinyint default 0;

create or replace view view_readtable_kandidaten_bp_column as

with clicked as (
select 
    kandidaten_bp_column.kandidaten_id,
    stimmzettel.id stimmzettel_id,
    kandidaten_bp_column.stimmzettelgruppen_id,
    kandidaten_bp_column.sz_rois_id,
    kandidaten_bp_column.kandidaten_id_checked
from 
    kandidaten_bp_column
    join stimmzettelgruppen
        on stimmzettelgruppen.id = kandidaten_bp_column.stimmzettelgruppen_id
    join stimmzettel
        on stimmzettelgruppen.stimmzettel = stimmzettel.ridx
where 
    kandidaten_id_checked=1
),
not_clicked as (
    select 

    kandidaten.id kandidaten_id,
    stimmzettel.id stimmzettel_id,
    stimmzettelgruppen.id stimmzettelgruppen_id,
    sz_rois.id sz_rois_id,
    0 kandidaten_id_checked

from 

    stimmzettel
    join stimmzettel_roi
        on stimmzettel.id = stimmzettel_roi.stimmzettel_id
    join sz_rois
        on stimmzettel_roi.sz_rois_id = sz_rois.id
    join stimmzettelgruppen
        on stimmzettelgruppen.stimmzettel = stimmzettel.ridx
        and stimmzettelgruppen.ridx<>'0|0'
    join
        kandidaten
         on kandidaten.stimmzettelgruppen = stimmzettelgruppen.ridx
         and kandidaten.id not in (select kandidaten_id from kandidaten_bp_column)
)
select 
    clicked.kandidaten_id,
    clicked.stimmzettel_id,
    clicked.stimmzettelgruppen_id,
    clicked.sz_rois_id,
    clicked.kandidaten_id_checked,
    view_readtable_kandidaten.anzeige_name
from
    view_readtable_kandidaten
    join clicked on view_readtable_kandidaten.id = clicked.kandidaten_id
union 
select 
    not_clicked.kandidaten_id,
    not_clicked.stimmzettel_id,
    not_clicked.stimmzettelgruppen_id,
    not_clicked.sz_rois_id,
    not_clicked.kandidaten_id_checked,
    view_readtable_kandidaten.anzeige_name
from
    view_readtable_kandidaten
    join not_clicked on view_readtable_kandidaten.id = not_clicked.kandidaten_id
;


update ds set use_insert_for_update=1 where table_name = 'kandidaten_bp_column';