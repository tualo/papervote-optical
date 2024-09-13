delimiter ;

create table detected_codes (
    box_code varchar(20)    not null,
    stack_code varchar(20)  not null,
    pagination_code varchar(20) not null,

    primary key (box_code, stack_code, pagination_code),

    login varchar(255) not null,
    created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp on update current_timestamp

);