DELIMITER;
SET FOREIGN_KEY_CHECKS=0;
INSERT INTO `ds` (`allowform`,`alternativeformxtype`,`character_set_name`,`class_name`,`combined`,`cssstyle`,`default_pagesize`,`displayfield`,`existsreal`,`globalsearch`,`hint`,`listselectionmodel`,`listviewbaseclass`,`listxtypeprefix`,`modelbaseclass`,`overview_tpl`,`phpexporter`,`phpexporterfilename`,`read_filter`,`read_table`,`reorderfield`,`searchany`,`searchfield`,`showactionbtn`,`sortfield`,`special_add_panel`,`syncable`,`sync_table`,`sync_view`,`table_name`,`title`,`use_history`,`writetable`) VALUES ('0','','','Briefwahlsystem Optisch','0','','100000','pagination_id','1','0','','cellmodel','Tualo.DataSets.ListView','','Tualo.DataSets.model.Basic','','XlsxWriter','view_papervote_optical_result_{DATE}','','','','0','pagination_id','1','pagination_id','','0','','','view_papervote_optical_result','Stimmzettelscan - Ergebnis','0','') ON DUPLICATE KEY UPDATE `allowform`=values(`allowform`),`alternativeformxtype`=values(`alternativeformxtype`),`character_set_name`=values(`character_set_name`),`class_name`=values(`class_name`),`combined`=values(`combined`),`cssstyle`=values(`cssstyle`),`default_pagesize`=values(`default_pagesize`),`displayfield`=values(`displayfield`),`existsreal`=values(`existsreal`),`globalsearch`=values(`globalsearch`),`hint`=values(`hint`),`listselectionmodel`=values(`listselectionmodel`),`listviewbaseclass`=values(`listviewbaseclass`),`listxtypeprefix`=values(`listxtypeprefix`),`modelbaseclass`=values(`modelbaseclass`),`overview_tpl`=values(`overview_tpl`),`phpexporter`=values(`phpexporter`),`phpexporterfilename`=values(`phpexporterfilename`),`read_filter`=values(`read_filter`),`read_table`=values(`read_table`),`reorderfield`=values(`reorderfield`),`searchany`=values(`searchany`),`searchfield`=values(`searchfield`),`showactionbtn`=values(`showactionbtn`),`sortfield`=values(`sortfield`),`special_add_panel`=values(`special_add_panel`),`syncable`=values(`syncable`),`sync_table`=values(`sync_table`),`sync_view`=values(`sync_view`),`table_name`=values(`table_name`),`title`=values(`title`),`use_history`=values(`use_history`),`writetable`=values(`writetable`); 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','anzahl_markierungen','int(10)','int','1','','YES','10','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','anzahl_stimmzettel_kreuze','int(10)','int','1','','YES','10','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`character_maximum_length`,`character_set_name`,`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`privileges`,`table_name`,`writeable`) VALUES ('255','utf8mb3','','anzeige_name','varchar(255)','varchar','1','','YES','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`character_maximum_length`,`character_set_name`,`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`privileges`,`table_name`,`writeable`) VALUES ('32','utf8mb3','','box_id','varchar(32)','varchar','1','','NO','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`character_maximum_length`,`character_set_name`,`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`privileges`,`table_name`,`writeable`) VALUES ('4294967295','utf8mb4','','edited_marks','longtext','longtext','1','','NO','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','is_final','tinyint(4)','tinyint','1','','YES','3','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','is_pending','int(1)','tinyint','1','','NO','10','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','kandidaten_id','int(11)','int','1','','YES','10','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`character_maximum_length`,`character_set_name`,`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`privileges`,`table_name`,`writeable`) VALUES ('255','utf8mb3','','login','varchar(255)','varchar','1','','YES','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`character_maximum_length`,`character_set_name`,`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`privileges`,`table_name`,`writeable`) VALUES ('4294967295','utf8mb4','','marked','longtext','longtext','1','','YES','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`character_maximum_length`,`character_set_name`,`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`privileges`,`table_name`,`writeable`) VALUES ('4294967295','utf8mb4','','marks','longtext','longtext','1','','NO','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','pagination_id','bigint(20)','bigint','1','','NO','19','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','pre_processed','tinyint(4)','tinyint','1','','YES','3','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','result_index','bigint(21)','bigint','1','','NO','19','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`character_maximum_length`,`character_set_name`,`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`privileges`,`table_name`,`writeable`) VALUES ('32','utf8mb3','','stack_id','varchar(32)','varchar','1','','NO','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','stimmzettelgruppen_enthaltung','int(1)','tinyint','1','','YES','10','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','stimmzettelgruppen_id','int(11)','int','1','','NO','10','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`character_maximum_length`,`character_set_name`,`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`privileges`,`table_name`,`writeable`) VALUES ('255','utf8mb3','','stimmzettelgruppen_name','varchar(255)','varchar','1','','YES','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','stimmzettelgruppen_sitze','int(11)','int','1','','YES','10','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','stimmzettelgruppen_ungueltig','int(1)','tinyint','1','','YES','10','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','stimmzettel_enthaltung','int(1)','tinyint','1','','YES','10','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','stimmzettel_id','int(11)','int','1','','YES','10','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`character_maximum_length`,`character_set_name`,`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`privileges`,`table_name`,`writeable`) VALUES ('255','utf8mb3','','stimmzettel_name','varchar(255)','varchar','1','','YES','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`character_maximum_length`,`character_set_name`,`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`privileges`,`table_name`,`writeable`) VALUES ('255','utf8mb3','','stimmzettel_sitze','varchar(255)','varchar','1','','YES','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','stimmzettel_ungueltig','int(11)','int','1','','YES','10','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column` (`column_key`,`column_name`,`column_type`,`data_type`,`existsreal`,`fieldtype`,`is_nullable`,`numeric_precision`,`numeric_scale`,`privileges`,`table_name`,`writeable`) VALUES ('','sz_rois_id','int(11)','int','1','','YES','10','0','select,insert,update,references','view_papervote_optical_result','1') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('0','anzahl_markierungen','','','1.00','0','1','anzahl_markierungen','DE','','15','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('1','anzahl_stimmzettel_kreuze','','','1.00','0','1','Kreuze','DE','','12','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('0','anzeige_name','','','1.00','0','0','Kandidat','DE','','10','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('1','box_id','','','1.00','0','1','Kiste','DE','kisten2_name_listfilter','0','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('0','edited_marks','','','1.00','0','1','edited_marks','DE','','18','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('1','is_final','','boolean','1.00','0','0','Final','DE','boolean','6','papervoteCheckRenderer','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('1','is_pending','','boolean','1.00','0','0','Prüfung','DE','boolean','5','papervoteCheckRenderer','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('0','kandidaten_id','','','1.00','0','1','kandidaten_id','DE','','19','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('1','login','','','1.00','0','1','Login','DE','view_session_users_login_listfilter','16','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('0','marked','','','1.00','0','0','gewählt','DE','','11','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('0','marks','','','1.00','0','1','marks','DE','','22','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('1','pagination_id','','','1.00','0','0','Stimmzettelnummer','DE','','2','','','','view_papervote_optical_result','papervote_paginationcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('1','pre_processed','','boolean','1.00','0','0','Vorverarbeitet','DE','boolean','7','papervoteCheckRenderer','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('0','result_index','','','1.00','0','1','result_index','DE','','24','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('1','stack_id','','','1.00','0','1','Stapel','DE','stapel2_name_listfilter','1','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('0','stimmzettelgruppen_enthaltung','','','1.00','0','1','stimmzettelgruppen_enthaltung','DE','','20','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('0','stimmzettelgruppen_id','','','1.00','0','1','stimmzettelgruppen_id','DE','','17','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('0','stimmzettelgruppen_name','','','1.00','0','1','stimmzettelgruppen_name','DE','','14','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('0','stimmzettelgruppen_sitze','','','1.00','0','1','stimmzettelgruppen_sitze','DE','','23','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('0','stimmzettelgruppen_ungueltig','','','1.00','0','1','stimmzettelgruppen_ungueltig','DE','','21','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('1','stimmzettel_enthaltung','','boolean','1.00','0','0','SZ Enthaltung','DE','boolean','9','papervoteCheckRenderer','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('1','stimmzettel_id','','','1.00','1','0','Stimmzettel','DE','stimmzettel_id_listfilter','3','','','','view_papervote_optical_result','column_stimmzettel_id') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('1','stimmzettel_name','','','1.00','0','1','Stimmzettelname','DE','','4','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('1','stimmzettel_sitze','','','1.00','0','1','Sitze','DE','','13','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('1','stimmzettel_ungueltig','','boolean','1.00','0','0','SZ Ungültig','DE','boolean','8','papervoteCheckRenderer','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_list_label` (`active`,`column_name`,`editor`,`filterstore`,`flex`,`grouped`,`hidden`,`label`,`language`,`listfiltertype`,`position`,`renderer`,`summaryrenderer`,`summarytype`,`table_name`,`xtype`) VALUES ('0','sz_rois_id','','','1.00','0','1','sz_rois_id','DE','','25','','','','view_papervote_optical_result','gridcolumn') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','anzahl_markierungen','Allgemein','1.00','1','anzahl_markierungen','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','anzahl_stimmzettel_kreuze','Allgemein','1.00','1','anzahl_stimmzettel_kreuze','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('1','0','anzeige_name','Allgemein/Angaben','0.00','0','Kandidat','DE','3','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','box_id','Allgemein','1.00','1','box_id','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','edited_marks','Allgemein','1.00','1','edited_marks','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','is_final','Allgemein','1.00','1','is_final','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','is_pending','Allgemein','1.00','1','is_pending','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','kandidaten_id','Allgemein','1.00','1','kandidaten_id','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','login','Allgemein','1.00','1','login','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('1','0','marked','Allgemein/Angaben','0.00','0','gewählt','DE','5','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','marks','Allgemein','1.00','1','marks','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('1','0','pagination_id','Allgemein/Angaben','0.00','0','Stimmzettelnummer','DE','0','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','pre_processed','Allgemein','1.00','1','pre_processed','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','result_index','Allgemein','1.00','1','result_index','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','stack_id','Allgemein','1.00','1','stack_id','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','stimmzettelgruppen_enthaltung','Allgemein','1.00','1','stimmzettelgruppen_enthaltung','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','stimmzettelgruppen_id','Allgemein','1.00','1','stimmzettelgruppen_id','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','stimmzettelgruppen_name','Allgemein','1.00','1','stimmzettelgruppen_name','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','stimmzettelgruppen_sitze','Allgemein','1.00','1','stimmzettelgruppen_sitze','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','stimmzettelgruppen_ungueltig','Allgemein','1.00','1','stimmzettelgruppen_ungueltig','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','stimmzettel_enthaltung','Allgemein','1.00','1','stimmzettel_enthaltung','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('1','0','stimmzettel_id','Allgemein/Angaben','0.00','1','Stimmzettel','DE','6','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('1','0','stimmzettel_name','Allgemein/Angaben','0.00','0','Stimmzettelname','DE','1','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','stimmzettel_sitze','Allgemein','1.00','1','stimmzettel_sitze','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','stimmzettel_ungueltig','Allgemein','1.00','1','stimmzettel_ungueltig','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_column_form_label` (`active`,`allowempty`,`column_name`,`field_path`,`flex`,`hidden`,`label`,`language`,`position`,`table_name`,`xtype`) VALUES ('0','0','sz_rois_id','Allgemein','1.00','1','sz_rois_id','DE','999','view_papervote_optical_result','displayfield') ; 
INSERT IGNORE INTO `ds_access` (`append`,`delete`,`read`,`role`,`table_name`,`write`) VALUES ('0','0','0','_default_','view_papervote_optical_result','0') ; 
INSERT IGNORE INTO `ds_access` (`append`,`delete`,`read`,`role`,`table_name`,`write`) VALUES ('0','0','1','administration','view_papervote_optical_result','0') ; 
SET FOREIGN_KEY_CHECKS=1;