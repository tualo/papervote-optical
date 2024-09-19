DELIMITER;

create

or replace view `view_sz_optical_config` as
select
    json_object(
        'titles',
        `view_sz_titles_by_page`.`t`,
        'titleRegion',
        json_object(
            'x',
            `x`.`titel_regions_x`,
            'y',
            `x`.`titel_regions_y`,
            'width',
            `x`.`titel_regions_width`,
            'height',
            `x`.`titel_regions_height`
        ),
        'pagesize',
        json_object(
            'width',
            `x`.`pagesize_width`,
            'height',
            `x`.`pagesize_height`
        ),
        'circleSize',
        5,
        'circleMinDistance',
        11,
        'rois',
        json_arrayagg(
            json_object(
                'types',
                `x`.`types`,
                'x',
                `x`.`x`,
                'y',
                `x`.`y`,
                'width',
                `x`.`width`,
                'height',
                `x`.`height`,
                'excpectedMarks',
                `x`.`expected_marks`
            )
        )
    ) AS `o`
from
    (
        (
            select
                `stimmzettel`.`id` AS `id`,
                json_arrayagg(
                    json_object(
                        'title',
                        `stimmzettel`.`ocr_name`,
                        'id',
                        `stimmzettel`.`id`
                    )
                ) AS `types`,
                `sz_rois`.`x` AS `x`,
                `sz_rois`.`y` AS `y`,
                `sz_rois`.`width` AS `width`,
                `sz_rois`.`height` AS `height`,
                `sz_titel_regions`.`name` AS `name`,
                `sz_titel_regions`.`x` AS `titel_regions_x`,
                `sz_titel_regions`.`y` AS `titel_regions_y`,
                `sz_titel_regions`.`width` AS `titel_regions_width`,
                `sz_titel_regions`.`height` AS `titel_regions_height`,
                `view_sz_expected_marks`.`expected_marks` AS `expected_marks`,
                `sz_page_sizes`.`width` AS `pagesize_width`,
                `sz_page_sizes`.`height` AS `pagesize_height`
            from
                (
                    (
                        (
                            (
                                (
                                    (
                                        (
                                            `view_sz_expected_marks`
                                            join `stimmzettel` on(
                                                `stimmzettel`.`ridx` = `view_sz_expected_marks`.`id`
                                            )
                                        )
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
                `view_sz_expected_marks`.`expected_marks`,
                `sz_rois`.`x`,
                `sz_rois`.`y`,
                `sz_rois`.`width`,
                `sz_rois`.`height`
        ) `x`
        join `view_sz_titles_by_page` on(
            (
                `view_sz_titles_by_page`.`x`,
                `view_sz_titles_by_page`.`y`,
                `view_sz_titles_by_page`.`width`,
                `view_sz_titles_by_page`.`height`,
                `view_sz_titles_by_page`.`page_width`,
                `view_sz_titles_by_page`.`page_height`
            ) = (
                `x`.`titel_regions_x`,
                `x`.`titel_regions_y`,
                `x`.`titel_regions_width`,
                `x`.`titel_regions_height`,
                `x`.`pagesize_width`,
                `x`.`pagesize_height`
            )
        )
    )
group by
    `x`.`titel_regions_x`,
    `x`.`titel_regions_y`,
    `x`.`titel_regions_width`,
    `x`.`titel_regions_height`,
    `x`.`pagesize_width`,
    `x`.`pagesize_height`;