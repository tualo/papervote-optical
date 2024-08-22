DELIMITER;

create
or replace view `view_sz_expected_marks` as
select
    `stimmzettel`.`id` AS `id`,
    count(`kandidaten`.`id`) AS `expected_marks`
from
    (
        (
            `kandidaten`
            join `stimmzettelgruppen` on(
                `kandidaten`.`stimmzettelgruppen` = `stimmzettelgruppen`.`ridx`
                and stimmzettelgruppen.ridx<>'0|0'
            )
        )
        join `stimmzettel` on(
            `stimmzettel`.`ridx` = `stimmzettelgruppen`.`stimmzettel`
        )
    )
group by
    `stimmzettel`.`id`;