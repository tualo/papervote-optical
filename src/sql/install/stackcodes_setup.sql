DELIMITER ;
CREATE TABLE IF NOT EXISTS `stackcodes_setup` (
  `id` int(11) NOT NULL DEFAULT 1,
  `page_width` int(11) DEFAULT 105,
  `page_height` int(11) DEFAULT 297,
  `start_code` int(11) DEFAULT 100000,
  `stop_code` int(11) DEFAULT 100020,
  `name` varchar(255) DEFAULT 'default',
  `prefix` varchar(3) DEFAULT 'FC3',
  PRIMARY KEY (`id`)
);
