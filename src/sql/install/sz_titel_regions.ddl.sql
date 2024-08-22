DELIMITER ;
CREATE TABLE IF NOT EXISTS `sz_titel_regions` (
    `id` varchar(36) not null default uuid(),
    `name` varchar(50) unique,
    `x` int not null,
    `y` int not null,
    `width` int not null,
    `height` int not null,
    primary key (`id`)
);

INSERT INTO `sz_titel_regions` (`name`,`x`,`y`,`width`,`height`) values("Oben Links",28,14,100,10);

CREATE TABLE IF NOT EXISTS `sz_page_sizes` (
    `id` varchar(36) not null default uuid(),
    `name` varchar(50) unique,
    `width` int not null,
    `height` int not null,
    primary key (`id`)
);
insert into `sz_page_sizes` (`name`,`width`,`height`)VALUES("A5",148,210);
insert into `sz_page_sizes` (`name`,`width`,`height`)VALUES("A4",210,297);
insert into `sz_page_sizes` (`name`,`width`,`height`)VALUES("A3",297,420);

create Table if not EXISTS `sz_to_page_sizes` (
    `id_sz` int(11),
    `id_sz_page_sizes`  varchar(36),
    primary key (`id_sz`),
    CONSTRAINT `fk2_id_stimmzettel` FOREIGN KEY (`id_sz`) REFERENCES `stimmzettel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_id_sz_page_sizes` FOREIGN KEY (`id_sz_page_sizes`) REFERENCES `sz_page_sizes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);
create Table if not EXISTS `sz_to_region` (
    `id_sz` int(11),
    `id_sz_titel_regions`  varchar(36),
    primary key (`id_sz`),
    CONSTRAINT `fk_id_stimmzettel` FOREIGN KEY (`id_sz`) REFERENCES `stimmzettel` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_id_sz_titel_regions` FOREIGN KEY (`id_sz_titel_regions`) REFERENCES `sz_titel_regions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);
/*
drop table  sz_to_region;
drop table  sz_to_page_sizes;
*/
create or replace view view_get_sz_configs as (
select  SUBSTRING_INDEX(`sz`.`name`, '.', -1) as `titel`,
            `sz`.`id`  as `sz_id`,
            `tr`.`name` as `tr_name`,
            `tr`.`x` as `tr_x`,
            `tr`.`y` as `tr_y`,
            `tr`.`width` `tr_width`,
            `tr`.`height` `tr_height`,
            `ps`.`width` `ps_width`,
            `ps`.`height` `ps_height`
            
    from stimmzettel sz
        join `sz_to_region`  on (`sz`.`id` = `sz_to_region`.`id_sz`)
        join `sz_to_page_sizes`  on (`sz`.`id` = `sz_to_page_sizes`.`id_sz`)
        join `sz_titel_regions` tr on (`sz_to_region`.`id_sz_titel_regions` =`tr`. `id`)
        join `sz_page_sizes` ps on (`sz_to_page_sizes`.`id_sz_page_sizes` =`ps`. `id`)
)