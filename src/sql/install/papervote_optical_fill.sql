DELIMITER //

CREATE OR REPLACE TRIGGER `papervote_optical_au_fill_sz2`
    AFTER UPDATE
    ON `papervote_optical` FOR EACH ROW
BEGIN
    call proc_papervote_optical(new.pagination_id);
END //


CREATE OR REPLACE TRIGGER `papervote_optical_ai_fill_sz2`
    AFTER INSERT
    ON `papervote_optical` FOR EACH ROW
BEGIN


-- call proc_papervote_optical(new.pagination_id);

    declare use_sql longtext;

    set use_sql=concat("call proc_papervote_optical(",new.pagination_id,")");

          insert into deferred_sql_tasks
                (taskid,sessionuser     ,hostname  ,sqlstatement)
        values  (uuid(),getsessionuser(),@@hostname,use_sql );


END //
