delimiter ;

insert into `ds_class` (`class_name`) values ('Briefwahlsystem Optisch') on duplicate key update `class_name`=values(`class_name`);
