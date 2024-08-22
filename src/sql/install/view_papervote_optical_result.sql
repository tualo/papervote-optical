DELIMITER ;
create or replace view `view_papervote_optical_result` as select `papervote_optical`.`pagination_id` AS `pagination_id`,`stimmzettel`.`id` AS `stimmzettel_id`,`stimmzettel`.`name` AS `stimmzettel_name`,`kandidaten`.`anzeige_name` AS `anzeige_name`,`kandidaten`.`bp_column` AS `bp_column`,rank() over ( partition by `papervote_optical`.`pagination_id`,`stimmzettel`.`id`,`kandidaten`.`bp_column` order by `kandidaten`.`barcode`) AS `bp_pos`,rank() over ( partition by `papervote_optical`.`pagination_id`,`stimmzettel`.`id` order by `kandidaten`.`barcode`) AS `pos`,json_value(`papervote_optical`.`marks`,concat('$[',rank() over ( partition by `papervote_optical`.`pagination_id`,`stimmzettel`.`id` order by `kandidaten`.`barcode`) - 1,']')) AS `marked` from (((`view_readtable_kandidaten` `kandidaten` join `stimmzettelgruppen` on(`kandidaten`.`stimmzettelgruppen` = `stimmzettelgruppen`.`ridx`)) join `stimmzettel` on(`stimmzettelgruppen`.`stimmzettel` = `stimmzettel`.`ridx`)) join `papervote_optical` on(`papervote_optical`.`ballotpaper_id` = `stimmzettel`.`id`));