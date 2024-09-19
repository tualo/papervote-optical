DELIMITER ;
CREATE TABLE IF NOT EXISTS `stimmzettel_roi` (
  `stimmzettel_id` int(11) NOT NULL,
  `sz_rois_id` bigint NOT NULL,
  PRIMARY KEY (`stimmzettel_id`,`sz_rois_id`),
  KEY `fk_stimmzettel_roi_sz_rois` (`sz_rois_id`),
  CONSTRAINT `fk_stimmzettel_roi_stimmzettel` FOREIGN KEY (`stimmzettel_id`) REFERENCES `stimmzettel` (`id`),
  CONSTRAINT `fk_stimmzettel_roi_sz_rois` FOREIGN KEY (`sz_rois_id`) REFERENCES `sz_rois` (`id`)
) ;
