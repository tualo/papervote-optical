delimiter ;


create view view_ballotpaper_sizes as

select 
        stimmzettel.id,
        stimmzettel.name title,
		sz_page_sizes.width page_width,
		sz_page_sizes.height page_height
	from 
		stimmzettel 
		join sz_to_page_sizes 
			on sz_to_page_sizes.id_sz = stimmzettel.id
		join sz_page_sizes 
			on  sz_to_page_sizes.id_sz_page_sizes = sz_page_sizes.id
;

call fill_ds('view_ballotpaper_sizes');
call fill_ds_column('view_ballotpaper_sizes');
