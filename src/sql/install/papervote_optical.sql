DELIMITER ;
CREATE TABLE IF NOT EXISTS `papervote_optical` (
  `pagination_id` bigint(20) NOT NULL,
  `box_id` varchar(32) NOT NULL,
  `stack_id` varchar(32) NOT NULL,
  `ballotpaper_id` int(11) NOT NULL,
  `marks` varchar(255) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`pagination_id`)
);

create table if not exists `papervote_optical_data` (
  `pagination_id` bigint not null,
  `data` longtext not null,
  primary key (`pagination_id`),
  constraint `fk_papervote_optical_data_pagination_id` foreign key (`pagination_id`) references `papervote_optical` (`pagination_id`) on delete cascade on update cascade
) ;