delimiter ;
create or replace view view_ballotpaper_barcode as
select
    kandidaten.barcode,
    stimmzettelgruppen.stimmzettel ballotpaper
from
    kandidaten
    join stimmzettelgruppen on kandidaten.stimmzettelgruppen = stimmzettelgruppen.id
    ;
call fill_ds('view_ballotpaper_barcode');
call fill_ds_column('view_ballotpaper_barcode');