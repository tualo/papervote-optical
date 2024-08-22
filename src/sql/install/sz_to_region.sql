DELIMITER ;
CREATE TABLE IF NOT EXISTS `sz_to_region` (
  `id_sz` int(11) NOT NULL,
  `id_sz_titel_regions` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id_sz`),
  KEY `fk_id_sz_titel_regions` (`id_sz_titel_regions`),
  CONSTRAINT `fk_id_stimmzettel` FOREIGN KEY (`id_sz`) REFERENCES `stimmzettel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_id_sz_titel_regions` FOREIGN KEY (`id_sz_titel_regions`) REFERENCES `sz_titel_regions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ;
