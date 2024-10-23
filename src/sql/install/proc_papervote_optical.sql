
CREATE OR REPLACE PROCEDURE `proc_papervote_optical`( IN in_pagination_id bigint)
BEGIN 
    declare use_box_id varchar(25);
    declare use_stack_id  varchar(25);
  

    declare r_pagination_id bigint;
    declare r_box_id  varchar(25);
    declare r_stack_id  varchar(25);
    declare r_ballotpaper_id integer;
    declare r_created datetime;
    declare r_modified datetime;
    declare r_login varchar(255);

    delete from stimmzettel2 where id = in_pagination_id;

    
    set @request_pagination = in_pagination_id;

    select
        
        pagination_id,
        box_id,
        stack_id,
        ballotpaper_id,
        created,
        modified,
        login 
    into 
        r_pagination_id,
        r_box_id,
        r_stack_id,
        r_ballotpaper_id,
        r_created,
        r_modified,
        r_login
    from 
        view_papervote_optical_result_ballotpaper_trigger 
    where 
        stimmzettel_ungueltig=0 
        and stimmzettel_enthaltung=0 
        and pagination_id = in_pagination_id
    limit 1
    ;
    
    if r_pagination_id is not null then
        set use_box_id = if( ifnull( r_box_id,0) ='',0, ifnull(r_box_id,0) );
        set use_stack_id = if( ifnull(r_stack_id,0) ='',0, ifnull(r_stack_id,0) );


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
            cast(r_created as date),
            cast(r_modified as date),
            getSessionUser(),
            cast(r_created as time),
            cast(r_modified as time)
        );
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
            cast(r_created as date),
            cast(r_modified as date),
            getSessionUser(),
            cast(r_created as time),
            cast(r_modified as time)
        );

        


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
            r_pagination_id,
            r_pagination_id,
            0,
            r_pagination_id,
            use_stack_id,
            1,
            cast(r_created as date),
            cast(r_modified as date),
            getSessionUser(),
            cast(r_created as time),
            cast(r_modified as time),
            concat(r_ballotpaper_id,'|0')
        );


        for can in (
            select 
                view_papervote_optical_result_ballotpaper_trigger.* ,
                kandidaten.ridx,
                kandidaten.barcode
            from 
                view_papervote_optical_result_ballotpaper_trigger 
                join kandidaten on view_papervote_optical_result_ballotpaper_trigger.kandidaten_id = kandidaten.id  
            where pagination_id = r_pagination_id and marked='X'
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
                concat(lpad(r_pagination_id,8,'0') , lpad(can.result_index,3,'0')),
                r_pagination_id,
                can.kandidaten_id,
                can.barcode,
                r_pagination_id,
                can.ridx,


                1,
                cast(r_created as date),
                cast(r_modified as date),
                getSessionUser(),
                cast(r_created as time),
                cast(r_modified as time)


            ) ; 
        end for; 


    end if;

    


END //