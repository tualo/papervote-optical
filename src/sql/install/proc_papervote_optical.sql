DELIMITER //
/*

CREATE TABLE `kandidaten2` (
  `ridx` varchar(12) DEFAULT NULL,
  `id` int(11) NOT NULL DEFAULT 0,
  `kostenstelle` int(11) NOT NULL DEFAULT 0,
  `name` varchar(255) DEFAULT NULL,
  `aktiv` int(11) DEFAULT 1,
  `insert_date` date NOT NULL,
  `update_date` date NOT NULL,
  `login` varchar(255) NOT NULL,
  `stimmzettel2` varchar(12) DEFAULT NULL,
  `kandidaten` varchar(12) DEFAULT NULL,
  `insert_time` time DEFAULT NULL,
  `update_time` time DEFAULT NULL,
  PRIMARY KEY (`id`,`kostenstelle`),
  UNIQUE KEY `idx_kandidaten2` (`ridx`),
  UNIQUE KEY `idx_kandidaten2_ridx` (`ridx`),
  KEY `idx_kandidaten2_name` (`name`),
  KEY `idx_kandidaten2_stimmzettel2` (`stimmzettel2`),
  KEY `idx_kandidaten2_kandidaten` (`kandidaten`),
  CONSTRAINT `fk_kandidaten2_kandidaten` FOREIGN KEY (`kandidaten`) REFERENCES `kandidaten` (`ridx`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_kandidaten2_stimmzettel2` FOREIGN KEY (`stimmzettel2`) REFERENCES `stimmzettel2` (`ridx`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci

kisten2

stapel2
    ridx
    id
    kostenstelle
    name
    aktiv
    insert_date
    update_date
    login
    kisten2
    insert_time
    update_time
    abgebrochen

stimmzettel2
    ridx
    id
    kostenstelle
    name
    aktiv
    insert_date
    update_date
    login
    stapel2
    stimmzettel
    insert_time
    update_time

kandidaten2
    ridx
    id
    kostenstelle
    name
    aktiv
    insert_date
    update_date
    login
    stimmzettel2
    kandidaten
    insert_time
    update_time

papervote_optical
    pagination_id
    box_id
    stack_id
    ballotpaper_id
    marks
    created
    modified
*/

CREATE OR REPLACE PROCEDURE `proc_papervote_optical`( IN in_pagination_id bigint)
BEGIN 
    declare use_box_id varchar(25);
    declare use_stack_id  varchar(25);
  
    delete from stimmzettel2 where id = in_pagination_id;

    /*
    for r in (select   box_id,min(created) created, min(modified) modified from papervote_optical group by box_id)
    do
        set use_box_id = if( ifnull( r.box_id,0) ='',0, ifnull(r.box_id,0) );
        insert ignore into kisten2 (
            ridx,
            id,
            kostenstelle,
            name,
            aktiv,
            insert_date,
            update_date,
            login,
            insert_time,
            update_time
        ) values (
            use_box_id,
            regexp_replace(use_box_id,'[^0-9]',''),
            0,
            use_box_id,
            1,
            cast(r.created as date),
            cast(r.modified as date),
            getSessionUser(),
            cast(r.created as time),
            cast(r.modified as time)
        );

    end for;


    for r in (select  box_id, stack_id,min(created) created, min(modified) modified from papervote_optical group by  box_id, stack_id)
    do
        set use_box_id = if( ifnull( r.box_id,0) ='',0, ifnull(r.box_id,0) );
        set use_stack_id = if( ifnull(r.stack_id,0) ='',0, ifnull(r.stack_id,0) );


        insert ignore into stapel2 (
            ridx,
            id,
            kostenstelle,
            name,
            kisten2,
            aktiv,
            insert_date,
            update_date,
            login,
            insert_time,
            update_time
        ) values (
            use_stack_id,
            regexp_replace(use_stack_id,'[^0-9]',''),
            0,
            use_stack_id,
            use_box_id,
            1,
            cast(r.created as date),
            cast(r.modified as date),
            getSessionUser(),
            cast(r.created as time),
            cast(r.modified as time)
        );

    end for;
    */

    for r in (
    select
        
        pagination_id,
        box_id,
        stack_id,
        ballotpaper_id,
        created,
        modified,
        login 
    from view_papervote_optical_result where stimmzettel_ungueltig=0 and pagination_id = in_pagination_id
    ) 
    do
        set use_box_id = if( ifnull( r.box_id,0) ='',0, ifnull(r.box_id,0) );
        set use_stack_id = if( ifnull(r.stack_id,0) ='',0, ifnull(r.stack_id,0) );

        


        insert into stimmzettel2 (
            ridx,
            id,
            kostenstelle,
            name,
            stapel2,
            aktiv,
            insert_date,
            update_date,
            login,
            insert_time,
            update_time,
            stimmzettel
        ) values (
            r.pagination_id,
            r.pagination_id,
            0,
            r.pagination_id,
            use_stack_id,
            1,
            cast(r.created as date),
            cast(r.modified as date),
            getSessionUser(),
            cast(r.created as time),
            cast(r.modified as time),
            concat(r.ballotpaper_id,'|0')
        );


        for can in (
            select 
                view_papervote_optical_result_ballotpaper.* ,
                kandidaten.ridx,
                kandidaten.barcode
            from 
                view_papervote_optical_result_ballotpaper 
                join kandidaten on view_papervote_optical_result_ballotpaper.kandidaten_id = kandidaten.id  
            where pagination_id = r.pagination_id and marked='X'
            ) 
        do
            insert into kandidaten2(
                ridx,
                id,
                kostenstelle,
                name,
                stimmzettel2,
                kandidaten,


                aktiv,
                insert_date,
                update_date,
                login,
                insert_time,
                update_time
            ) values (
                concat(lpad(r.pagination_id,8,'0') , lpad(can.result_index,3,'0')),
                r.pagination_id,
                can.kandidaten_id,
                can.barcode,
                r.pagination_id,
                can.ridx,


                1,
                cast(r.created as date),
                cast(r.modified as date),
                getSessionUser(),
                cast(r.created as time),
                cast(r.modified as time)


            ) ; 
        end for; 


    end for;

    


END //


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



CREATE OR REPLACE PROCEDURE `proc_sz_rois_item_height`()
BEGIN
    for rec in (select id as sz_rois_id from sz_rois)
    do
        set @c = (select count(*) from kandidaten_bp_column where kandidaten_bp_column.sz_rois_id = rec.sz_rois_id and kandidaten_id_checked=1);
        if (@c>0) then
            update sz_rois set item_height = (sz_rois.height - ((
                select count(*) from kandidaten_bp_column where kandidaten_bp_column.sz_rois_id = rec.sz_rois_id and kandidaten_id_checked=1
            )-1)* if(sz_rois.item_cap_y=0,0.5,sz_rois.item_cap_y)
            ) / (
                select count(*) from kandidaten_bp_column where kandidaten_bp_column.sz_rois_id = rec.sz_rois_id and kandidaten_id_checked=1
            )
        where sz_rois.id = rec.sz_rois_id;
        end if;
    end for;

    for rec in (
        select 
            kandidaten_bp_column.position,
            kandidaten_bp_column.kandidaten_id, 
            kandidaten_bp_column.stimmzettelgruppen_id,
            view_readtable_kandidaten_bp_column.position xposition
        from 
            kandidaten_bp_column 
            join view_readtable_kandidaten_bp_column 
            on 
            (view_readtable_kandidaten_bp_column.kandidaten_id, view_readtable_kandidaten_bp_column.stimmzettelgruppen_id) = (kandidaten_bp_column.kandidaten_id, kandidaten_bp_column.stimmzettelgruppen_id)

        where kandidaten_bp_column.position <> view_readtable_kandidaten_bp_column.position
        )
    do
        update kandidaten_bp_column 
            set position = rec.xposition
        where 
            kandidaten_id = rec.kandidaten_id
            and stimmzettelgruppen_id=rec.stimmzettelgruppen_id;
    end for;
END //
call proc_sz_rois_item_height() //




-- stimmzettel > ungueltig
-- select stimmzettel_id,count(*) c from view_papervote_optical_result where stimmzettel_ungueltig=1 or stimmzettel_enthaltung=1 group by stimmzettel_id