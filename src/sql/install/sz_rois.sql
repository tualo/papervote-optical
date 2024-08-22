DELIMITER ;
CREATE TABLE IF NOT EXISTS `sz_rois` (
  `id` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `item_height` int(11) DEFAULT 21,
  `item_cap_y` decimal(15,5) DEFAULT 0.50000,
  PRIMARY KEY (`id`)
) ;
