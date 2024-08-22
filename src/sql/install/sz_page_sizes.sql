DELIMITER ;
CREATE TABLE IF NOT EXISTS `sz_page_sizes` (
  `id` varchar(36) NOT NULL DEFAULT uuid(),
  `name` varchar(50) DEFAULT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ;
