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
