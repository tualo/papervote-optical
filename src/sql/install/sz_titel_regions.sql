DELIMITER ;
CREATE TABLE IF NOT EXISTS `sz_titel_regions` (
  `id` varchar(36) NOT NULL DEFAULT uuid(),
  `name` varchar(50) DEFAULT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ;




create or replace view view_readtable_sz_titel_regions as
select 
    sz_titel_regions.*,
    sz_to_region.id_sz
from 
    sz_titel_regions 
    left join  sz_to_region
        on sz_to_region.id_sz_titel_regions = sz_titel_regions.id
;

