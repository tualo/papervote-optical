DELIMITER;

create
or replace view `view_sz_titles_by_page` as
select
    json_arrayagg(json_object('titel', `stimmzettel`.`ocr_name`)) AS `t`,
    `sz_titel_regions`.`x` AS `x`,
    `sz_titel_regions`.`y` AS `y`,
    `sz_titel_regions`.`width` AS `width`,
    `sz_titel_regions`.`height` AS `height`,
    `sz_page_sizes`.`width` AS `page_width`,
    `sz_page_sizes`.`height` AS `page_height`
from
    (
        (
            (
                (
                    (
                        (
                            `stimmzettel`
                            join `stimmzettel_roi` on(
                                `stimmzettel_roi`.`stimmzettel_id` = `stimmzettel`.`id`
                            )
                        )
                        join `sz_rois` on(`stimmzettel_roi`.`sz_rois_id` = `sz_rois`.`id`)
                    )
                    join `sz_to_region` on(`sz_to_region`.`id_sz` = `stimmzettel`.`id`)
                )
                join `sz_titel_regions` on(
                    `sz_titel_regions`.`id` = `sz_to_region`.`id_sz_titel_regions`
                )
            )
            join `sz_to_page_sizes` on(`sz_to_page_sizes`.`id_sz` = `stimmzettel`.`id`)
        )
        join `sz_page_sizes` on(
            `sz_to_page_sizes`.`id_sz_page_sizes` = `sz_page_sizes`.`id`
        )
    )
group by
    `sz_titel_regions`.`x`,
    `sz_titel_regions`.`y`,
    `sz_titel_regions`.`width`,
    `sz_titel_regions`.`height`,
    `sz_page_sizes`.`width`,
    `sz_page_sizes`.`height`;