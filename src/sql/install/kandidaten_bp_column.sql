delimiter ;


CREATE TABLE IF NOT EXISTS `kandidaten_bp_column` (
  `kandidaten_id` int(11) NOT NULL,
  `stimmzettelgruppen_id` int(11) NOT NULL,
  `sz_rois_id` bigint NOT NULL,
  PRIMARY KEY (`kandidaten_id`,`stimmzettelgruppen_id`),
  KEY `fk_kandidaten_bp_column_stimmzettelgruppen_id` (`stimmzettelgruppen_id`),
  KEY `fk_kandidaten_bp_column_sz_rois_id` (`sz_rois_id`),
  CONSTRAINT `fk_kandidaten_bp_column_kandidaten_id` FOREIGN KEY (`kandidaten_id`) REFERENCES `kandidaten` (`id`),
  CONSTRAINT `fk_kandidaten_bp_column_stimmzettelgruppen_id` FOREIGN KEY (`stimmzettelgruppen_id`) REFERENCES `stimmzettelgruppen` (`id`),
  CONSTRAINT `fk_kandidaten_bp_column_sz_rois_id` FOREIGN KEY (`sz_rois_id`) REFERENCES `sz_rois` (`id`)
);

alter table kandidaten_bp_column add column if not exists  kandidaten_id_checked tinyint default 0;

alter table kandidaten_bp_column add column if not exists  position int default 0;


create or replace view view_readtable_kandidaten_bp_column as

with clicked as (
    select 
        kandidaten_bp_column.kandidaten_id,
        stimmzettel.id stimmzettel_id,
        kandidaten_bp_column.stimmzettelgruppen_id,
        kandidaten_bp_column.sz_rois_id,
        kandidaten_bp_column.kandidaten_id_checked,
        kandidaten_bp_column.position,
        sz_rois.x,
        sz_rois.y
    from 
        kandidaten_bp_column
        join sz_rois
            on sz_rois.id = kandidaten_bp_column.sz_rois_id
        join stimmzettelgruppen
            on stimmzettelgruppen.id = kandidaten_bp_column.stimmzettelgruppen_id
        join stimmzettel
            on stimmzettelgruppen.stimmzettel = stimmzettel.id
    where 
        kandidaten_id_checked=1
),
not_clicked as (
    select 

    kandidaten.id kandidaten_id,
    stimmzettel.id stimmzettel_id,
    stimmzettelgruppen.id stimmzettelgruppen_id,
    sz_rois.id sz_rois_id,
    0 kandidaten_id_checked,
    0 position,
    sz_rois.x,
    sz_rois.y

from 

    stimmzettel
    join stimmzettel_roi
        on stimmzettel.id = stimmzettel_roi.stimmzettel_id
    join sz_rois
        on stimmzettel_roi.sz_rois_id = sz_rois.id
    join stimmzettelgruppen
        on stimmzettelgruppen.stimmzettel = stimmzettel.id
        and stimmzettelgruppen.id<>0
    join
        kandidaten
         on kandidaten.stimmzettelgruppen = stimmzettelgruppen.id
         and kandidaten.id not in (select kandidaten_id from kandidaten_bp_column where kandidaten_id_checked=1)
),
unions as (
    select 
        clicked.kandidaten_id,
        clicked.stimmzettel_id,
        clicked.stimmzettelgruppen_id,
        clicked.sz_rois_id,
        clicked.kandidaten_id_checked,
        
        clicked.x,
        clicked.y,
        
        
        if( clicked.position=0,
        rank() over (
            partition by 
                clicked.stimmzettelgruppen_id,
                clicked.sz_rois_id
            order by 
                view_readtable_kandidaten.anzeige_name
        ),clicked.position) position,


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
        
        not_clicked.x,
        not_clicked.y,


        if( not_clicked.position=0,
        rank() over (
            partition by 
                not_clicked.stimmzettelgruppen_id,
                not_clicked.sz_rois_id
            order by 
                view_readtable_kandidaten.anzeige_name
        ),not_clicked.position) position,

        view_readtable_kandidaten.anzeige_name
    from
        view_readtable_kandidaten
        join not_clicked on view_readtable_kandidaten.id = not_clicked.kandidaten_id
)

select
    unions.kandidaten_id,
    unions.stimmzettel_id,
    unions.stimmzettelgruppen_id,
    unions.sz_rois_id,
    unions.kandidaten_id_checked,
    unions.position,
    unions.x,
    unions.y,
    unions.anzeige_name,
    rank() over (
        partition by 
            unions.stimmzettel_id
        order by 
            unions.x,
            unions.y,
            unions.position
    ) result_index
from
    unions

;


update ds set use_insert_for_update=1 where table_name = 'kandidaten_bp_column';






