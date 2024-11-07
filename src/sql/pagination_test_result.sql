create table if not exists pagination_test_result (
    pagination_id bigint,
    pos integer,
    analyse_type varchar(36),
    primary key (pagination_id,pos,analyse_type),
    val decimal(15,6),
    constraint `fk_papervote_optical_test_result_pagination_id` foreign key (`pagination_id`) references `papervote_optical` (`pagination_id`) on delete cascade on update cascade

);