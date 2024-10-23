DELIMITER //
CREATE OR REPLACE PROCEDURE `proc_papervote_optical_old`( IN in_pagination_id bigint)
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






-- stimmzettel > ungueltig
-- select stimmzettel_id,count(*) c from view_papervote_optical_result where stimmzettel_ungueltig=1 or stimmzettel_enthaltung=1 group by stimmzettel_id