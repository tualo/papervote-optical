delimiter ;

create table if not exists detected_codes (
    box_code varchar(20)    not null,
    stack_code varchar(20)  not null,
    pagination_code varchar(20) not null,

    primary key (box_code, stack_code, pagination_code),

    login varchar(255) not null,
    created_at datetime not null default current_timestamp,
    updated_at datetime not null default current_timestamp on update current_timestamp

);
alter table detected_codes modify created_at datetime not null default current_timestamp;
alter table detected_codes modify updated_at datetime not null default current_timestamp on update current_timestamp;


create or replace  view view_readttable_detected_codes as
select 

detected_codes.box_code,
detected_codes.stack_code,
detected_codes.pagination_code,
detected_codes.login,
cast(detected_codes.created_at as datetime) created_at,
cast(detected_codes.updated_at as datetime) updated_at,
if(papervote_optical.pagination_id is null, 1=1,0=1) missed

from detected_codes left join papervote_optical on 

papervote_optical.pagination_id = detected_codes.pagination_code
;