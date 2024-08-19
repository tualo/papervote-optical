delimiter  //


insert
    ignore into ds_class (class_name)
values
    ('Briefwahlsystem Optisch') //


CREATE OR REPLACE FUNCTION `fn_null`( ) RETURNS int(11)
    DETERMINISTIC
BEGIN 
    RETURN NULL;
END //

CREATE TABLE IF NOT EXISTS `stimmzettel_pdfs` (
  `id` varchar(36) DEFAULT NULL,
  `file_id` varchar(36) DEFAULT NULL,
  `stimmzettel_id` integer default null,
  PRIMARY KEY (`id`),
  KEY `idx_stimmzettel_pdfs_stimmzettel_id` (`stimmzettel_id`),
  CONSTRAINT `fk_stimmzettel_pdfs_` FOREIGN KEY (`stimmzettel_id`) REFERENCES `stimmzettel` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) //


CREATE OR REPLACE VIEW `view_readtable_stimmzettel_pdfs` AS
select
    `stimmzettel_pdfs`.`id` AS `id`,
    stimmzettel_pdfs.file_id AS file_id,
    stimmzettel_id,
    `ds_files`.`name` AS `__file_name`,
    `ds_files`.`path` AS `path`,
    `ds_files`.`size` AS `__file_size`,
    `ds_files`.`mtime` AS `mtime`,
    `ds_files`.`ctime` AS `ctime`,
    `ds_files`.`type` AS `__file_type`,
    `ds_files`.`file_id` AS `__file_id`,
    `ds_files`.`hash` AS `hash`,
    '' AS `__file_data`
from
    (
        `stimmzettel_pdfs`
        left join `ds_files` on(
            `stimmzettel_pdfs`.`file_id` = `ds_files`.`file_id`
        )
    ) //    