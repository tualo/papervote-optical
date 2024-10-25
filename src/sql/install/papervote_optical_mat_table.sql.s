DELIMITER ;



alter table mat_view_papervote_optical_result modify pagination_id bigint(20) primary key;

create index idx_mat_view_papervote_optical_result_box_id on mat_view_papervote_optical_result(box_id);
create index idx_mat_view_papervote_optical_result_stack_id on mat_view_papervote_optical_result(stack_id);
create index idx_mat_view_papervote_optical_result_ballotpaper_id on mat_view_papervote_optical_result(ballotpaper_id);
create index idx_mat_view_papervote_optical_result_stimmzettel_ungueltig on mat_view_papervote_optical_result(stimmzettel_ungueltig);
create index idx_mat_view_papervote_optical_result_stimmzettel_enthaltung on mat_view_papervote_optical_result(stimmzettel_enthaltung);

create index idx_mat_view_papervote_optical_result_is_final on mat_view_papervote_optical_result(is_final);
create index idx_mat_view_papervote_optical_result_is_informed on mat_view_papervote_optical_result(is_informed);
create index idx_mat_view_papervote_optical_result_pre_processed on mat_view_papervote_optical_result(pre_processed);
create index idx_mat_view_papervote_optical_result_is_pending on mat_view_papervote_optical_result(is_pending);
create index idx_mat_view_papervote_optical_result_login on mat_view_papervote_optical_result(login);



update ds set read_table = 'mat_view_papervote_optical_result' where table_name = 'view_papervote_optical_result';
DELIMITER //






CREATE OR REPLACE TRIGGER `papervote_optical_ai_mat_table` 
AFTER
INSERT ON `papervote_optical` FOR EACH ROW BEGIN



insert into mat_view_papervote_optical_result (
    marked,
    pagination_id,
    box_id,
    stack_id,
    modified,
    created,
    ballotpaper_id,
    result_index,
    kandidaten_id,
    stimmzettel_id,
    sz_rois_id,
    anzeige_name,
    anzahl_markierungen,
    marks,
    anzahl_stimmzettel_kreuze,
    stimmzettel_ungueltig,
    stimmzettel_enthaltung,
    stimmzettel_name,
    stimmzettel_sitze,
    stimmzettelgruppen_name,
    stimmzettelgruppen_id,
    stimmzettelgruppen_sitze,
    stimmzettelgruppen_ungueltig,
    stimmzettelgruppen_enthaltung,
    is_final,
    is_informed,
    pre_processed,
    is_pending,
    login,
    edited_marks,
    for_review
)
select 
    marked,
    pagination_id,
    box_id,
    stack_id,
    modified,
    created,
    ballotpaper_id,
    result_index,
    kandidaten_id,
    stimmzettel_id,
    sz_rois_id,
    anzeige_name,
    anzahl_markierungen,
    marks,
    anzahl_stimmzettel_kreuze,
    stimmzettel_ungueltig,
    stimmzettel_enthaltung,
    stimmzettel_name,
    stimmzettel_sitze,
    stimmzettelgruppen_name,
    stimmzettelgruppen_id,
    stimmzettelgruppen_sitze,
    stimmzettelgruppen_ungueltig,
    stimmzettelgruppen_enthaltung,
    is_final,
    is_informed,
    pre_processed,
    is_pending,
    login,
    edited_marks,
    for_review
from view_papervote_optical_result 
where pagination_id = new.pagination_id
on duplicate key update

marked=values(marked),
pagination_id=values(pagination_id),
box_id=values(box_id),
stack_id=values(stack_id),
modified=values(modified),
created=values(created),
ballotpaper_id=values(ballotpaper_id),
result_index=values(result_index),
kandidaten_id=values(kandidaten_id),
stimmzettel_id=values(stimmzettel_id),
sz_rois_id=values(sz_rois_id),
anzeige_name=values(anzeige_name),
anzahl_markierungen=values(anzahl_markierungen),
marks=values(marks),
anzahl_stimmzettel_kreuze=values(anzahl_stimmzettel_kreuze),
stimmzettel_ungueltig=values(stimmzettel_ungueltig),
stimmzettel_enthaltung=values(stimmzettel_enthaltung),
stimmzettel_name=values(stimmzettel_name),
stimmzettel_sitze=values(stimmzettel_sitze),
stimmzettelgruppen_name=values(stimmzettelgruppen_name),
stimmzettelgruppen_id=values(stimmzettelgruppen_id),
stimmzettelgruppen_sitze=values(stimmzettelgruppen_sitze),
stimmzettelgruppen_ungueltig=values(stimmzettelgruppen_ungueltig),
stimmzettelgruppen_enthaltung=values(stimmzettelgruppen_enthaltung),
is_final=values(is_final),
is_informed=values(is_informed),
pre_processed=values(pre_processed),
is_pending=values(is_pending),
login=values(login),
edited_marks=values(edited_marks),
for_review=values(for_review);

END //

CREATE OR REPLACE TRIGGER `papervote_optical_au_mat_table` 
AFTER
UPDATE ON `papervote_optical` FOR EACH ROW BEGIN



insert into mat_view_papervote_optical_result (
    marked,
    pagination_id,
    box_id,
    stack_id,
    modified,
    created,
    ballotpaper_id,
    result_index,
    kandidaten_id,
    stimmzettel_id,
    sz_rois_id,
    anzeige_name,
    anzahl_markierungen,
    marks,
    anzahl_stimmzettel_kreuze,
    stimmzettel_ungueltig,
    stimmzettel_enthaltung,
    stimmzettel_name,
    stimmzettel_sitze,
    stimmzettelgruppen_name,
    stimmzettelgruppen_id,
    stimmzettelgruppen_sitze,
    stimmzettelgruppen_ungueltig,
    stimmzettelgruppen_enthaltung,
    is_final,
    is_informed,
    pre_processed,
    is_pending,
    login,
    edited_marks,
    for_review
)
select 
    marked,
    pagination_id,
    box_id,
    stack_id,
    modified,
    created,
    ballotpaper_id,
    result_index,
    kandidaten_id,
    stimmzettel_id,
    sz_rois_id,
    anzeige_name,
    anzahl_markierungen,
    marks,
    anzahl_stimmzettel_kreuze,
    stimmzettel_ungueltig,
    stimmzettel_enthaltung,
    stimmzettel_name,
    stimmzettel_sitze,
    stimmzettelgruppen_name,
    stimmzettelgruppen_id,
    stimmzettelgruppen_sitze,
    stimmzettelgruppen_ungueltig,
    stimmzettelgruppen_enthaltung,
    is_final,
    is_informed,
    pre_processed,
    is_pending,
    login,
    edited_marks,
    for_review
from view_papervote_optical_result 
where pagination_id = new.pagination_id
on duplicate key update

    marked=values(marked),
    pagination_id=values(pagination_id),
    box_id=values(box_id),
    stack_id=values(stack_id),
    modified=values(modified),
    created=values(created),
    ballotpaper_id=values(ballotpaper_id),
    result_index=values(result_index),
    kandidaten_id=values(kandidaten_id),
    stimmzettel_id=values(stimmzettel_id),
    sz_rois_id=values(sz_rois_id),
    anzeige_name=values(anzeige_name),
    anzahl_markierungen=values(anzahl_markierungen),
    marks=values(marks),
    anzahl_stimmzettel_kreuze=values(anzahl_stimmzettel_kreuze),
    stimmzettel_ungueltig=values(stimmzettel_ungueltig),
    stimmzettel_enthaltung=values(stimmzettel_enthaltung),
    stimmzettel_name=values(stimmzettel_name),
    stimmzettel_sitze=values(stimmzettel_sitze),
    stimmzettelgruppen_name=values(stimmzettelgruppen_name),
    stimmzettelgruppen_id=values(stimmzettelgruppen_id),
    stimmzettelgruppen_sitze=values(stimmzettelgruppen_sitze),
    stimmzettelgruppen_ungueltig=values(stimmzettelgruppen_ungueltig),
    stimmzettelgruppen_enthaltung=values(stimmzettelgruppen_enthaltung),
    is_final=values(is_final),
    is_informed=values(is_informed),
    pre_processed=values(pre_processed),
    is_pending=values(is_pending),
    login=values(login),
    edited_marks=values(edited_marks),
    for_review=values(for_review);

END //



CREATE OR REPLACE TRIGGER `papervote_optical_ad_mat_table` 
AFTER
DELETE ON `papervote_optical` FOR EACH ROW BEGIN

delete from mat_view_papervote_optical_result where pagination_id = row.pagination_id;



END //

