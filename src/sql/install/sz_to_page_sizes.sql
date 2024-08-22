DELIMITER ;
CREATE TABLE IF NOT EXISTS `sz_to_page_sizes` (
  `id_sz` int(11) NOT NULL,
  `id_sz_page_sizes` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id_sz`),
  KEY `fk_id_sz_page_sizes` (`id_sz_page_sizes`),
  CONSTRAINT `fk2_id_stimmzettel` FOREIGN KEY (`id_sz`) REFERENCES `stimmzettel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_id_sz_page_sizes` FOREIGN KEY (`id_sz_page_sizes`) REFERENCES `sz_page_sizes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ;
