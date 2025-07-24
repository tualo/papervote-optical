DELIMITER;
CREATE TABLE IF NOT EXISTS `papervote_optical` (
  `pagination_id` bigint(20) NOT NULL,
  `box_id` varchar(32) NOT NULL,
  `stack_id` varchar(32) NOT NULL,
  `ballotpaper_id` int(11) NOT NULL,
  `marks` JSON NOT NULL,
  `edited_marks` JSON DEFAULT '[]',
  `is_final` tinyint default 0,
  `pre_processed` tinyint default 0,
  `login` varchar(255) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`pagination_id`)
);
alter table papervote_optical
modify `marks` JSON NOT NULL;
alter table papervote_optical
add if not exists `login` varchar(255) DEFAULT 'NA';
alter table papervote_optical
add if not exists `edited_marks` JSON NOT NULL DEFAUlT '[]';
alter table papervote_optical
add if not exists `is_final` tinyint default 0;
alter table papervote_optical
add if not exists `pre_processed` tinyint default 0;

alter table papervote_optical
add if not exists `is_visible_ok` tinyint default 0;

DELIMITER //

CREATE OR REPLACE TRIGGER `papervote_optical_bu_defaults` BEFORE
UPDATE ON `papervote_optical` FOR EACH ROW BEGIN
set new.login = getSessionUser();
END //

CREATE OR REPLACE TRIGGER `papervote_optical_bu_defaults` BEFORE
UPDATE ON `papervote_optical` FOR EACH ROW BEGIN
  if  not(OLD.is_visible_ok=0 and NEW.is_visible_ok=1) then
      set new.login = getSessionUser();
  end if;
END //


CREATE OR REPLACE TRIGGER `papervote_optical_bi_defaults` BEFORE
INSERT ON `papervote_optical` FOR EACH ROW BEGIN
set new.login = getSessionUser();
END // 

DELIMITER ;
create table if not exists `papervote_optical_data` (
  `pagination_id` bigint not null,
  `data` longtext not null,
  primary key (`pagination_id`),
  constraint `fk_papervote_optical_data_pagination_id` foreign key (`pagination_id`) references `papervote_optical` (`pagination_id`) on delete cascade on update cascade
);

insert ignore into custom_types (
    vendor,
    name,
    id,
    xtype_long_classic,
    extendsxtype_classic,
    xtype_long_modern,
    extendsxtype_modern
  )
values (
    "Tualo",
    "Tualo.PaperVoteOptical.PaginationColumn",
    "Tualo.PaperVoteOptical.PaginationColumn",
    "widget.papervote_paginationcolumn",
    "Ext.grid.column.Column",
    "widget.column",
    "Ext.grid.column.Column"
  ) on duplicate key
update id =
values(id),
  xtype_long_classic =
values(xtype_long_classic),
  extendsxtype_classic =
values(extendsxtype_classic),
  name =
values(name),
  vendor =
values(vendor);


insert ignore into custom_types (
    vendor,
    name,
    id,
    xtype_long_classic,
    extendsxtype_classic,
    xtype_long_modern,
    extendsxtype_modern
  )
values (
    "Tualo",
    "Tualo.PaperVoteOptical.PaginationBPColumn",
    "Tualo.PaperVoteOptical.PaginationBPColumn",
    "widget.papervote_paginationbpcolumn",
    "Ext.grid.column.Column",
    "widget.column",
    "Ext.grid.column.Column"
  ) on duplicate key
update id =
values(id),
  xtype_long_classic =
values(xtype_long_classic),
  extendsxtype_classic =
values(extendsxtype_classic),
  name =
values(name),
  vendor =
values(vendor);


insert ignore into custom_types (
    vendor,
    name,
    id,
    xtype_long_classic,
    extendsxtype_classic,
    xtype_long_modern,
    extendsxtype_modern
  )
values (
    "Tualo",
    "Tualo.PaperVoteOptical.PaginationBPGColumn",
    "Tualo.PaperVoteOptical.PaginationBPGColumn",
    "widget.papervote_paginationbpgcolumn",
    "Ext.grid.column.Column",
    "widget.column",
    "Ext.grid.column.Column"
  ) on duplicate key
update id =
values(id),
  xtype_long_classic =
values(xtype_long_classic),
  extendsxtype_classic =
values(extendsxtype_classic),
  name =
values(name),
  vendor =
values(vendor);