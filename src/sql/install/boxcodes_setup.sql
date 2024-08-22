DELIMITER ;
CREATE TABLE IF NOT EXISTS `boxcodes_setup` (
  `id` int(11) NOT NULL DEFAULT 1,
  `page_width` int(11) DEFAULT 80,
  `page_height` int(11) DEFAULT 80,
  `start_code` int(11) DEFAULT 100000,
  `stop_code` int(11) DEFAULT 100020,
  PRIMARY KEY (`id`)
) ;
