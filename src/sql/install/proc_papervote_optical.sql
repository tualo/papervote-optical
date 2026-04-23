delimiter //

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

        if (substring(use_box_id,1,3) = 'FC8') then
            insert ignore into kisten1 (
                id,
                login,
                createdatetime,
                update_time
            ) values (
                use_box_id,
                r_login,
                cast(r_created as datetime),
                cast(r_modified as time)
            );

            insert ignore into stapel1 (
                id,
                login,
                kisten1,
                abgebrochen,
                createdatetime
                ) values (
                use_stack_id,
                r_login,
                use_box_id,
                0,
                cast(r_created as datetime)
            );

            insert ignore into stimmzettel1 (
                id,
                login,
                stapel1,
                abgebrochen,
                createdatetime,
                stimmzettel
            ) values (
                r_pagination_id,
                r_login,
                use_stack_id,
                0,
                cast(r_created as datetime),
                r_ballotpaper_id
            );
        end if;


        if (substring(use_box_id,1,3) = 'FC4') then
            insert ignore into kisten2 (
                id,
                login,
                createdatetime,
                update_time
            ) values (
                use_box_id,
                r_login,
                cast(r_created as datetime),
                cast(r_modified as time)
            );

            insert ignore into stapel2 (
                id,
                login,
                kisten2,
                abgebrochen,
                createdatetime
                ) values (
                use_stack_id,
                r_login,
                use_box_id,
                0,
                cast(r_created as datetime)
            );

            insert ignore into stimmzettel2 (
                id,
                login,
                stapel2,
                abgebrochen,
                createdatetime,
                stimmzettel
            ) values (
                r_pagination_id,
                r_login,
                use_stack_id,
                0,
                cast(r_created as datetime),
                r_ballotpaper_id
            );
        end if;
        
        if (substring(use_box_id,1,3) = 'FC8') then
            delete from kandidaten1 where stimmzettel1 = r_pagination_id ;
        end if;

        if (substring(use_box_id,1,3) = 'FC4') then
            delete from kandidaten2 where stimmzettel2 = r_pagination_id ;
        end if;
        
        for can in (
            select 
                view_papervote_optical_result_ballotpaper_trigger.* ,
                kandidaten.barcode
            from 
                view_papervote_optical_result_ballotpaper_trigger 
                join kandidaten on view_papervote_optical_result_ballotpaper_trigger.kandidaten_id = kandidaten.id  
            where pagination_id = r_pagination_id and marked='X'
            ) 
        do

            if (substring(use_box_id,1,3) = 'FC8') then
                insert into kandidaten1(
                    login,
                    kandidaten,
                    stimmzettel1,
                    createdatetime,
                    stimmen
                ) values (
                    r_login,
                    can.kandidaten_id,
                    r_pagination_id,
                    cast(r_created as datetime),
                    1
                ) ;
            end if;

            if (substring(use_box_id,1,3) = 'FC4') then
                insert into kandidaten2(
                    login,
                    kandidaten,
                    stimmzettel2,
                    createdatetime,
                    stimmen
                ) values (
                    r_login,
                    can.kandidaten_id,
                    r_pagination_id,
                    cast(r_created as datetime),
                    1
                ) ;
            end if;
        end for; 

    end if;

    


END //