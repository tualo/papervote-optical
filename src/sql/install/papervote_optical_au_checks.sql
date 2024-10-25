


alter table papervote_optical add if not exists anzahl_markierungen	int(10) default 0;
alter table papervote_optical add if not exists anzahl_stimmzettel_kreuze	int(10) default 0;
alter table papervote_optical add if not exists stimmzettel_ungueltig	tinyint(4) default 0;
alter table papervote_optical add if not exists stimmzettel_enthaltung	tinyint(4) default 0;
alter table papervote_optical add if not exists stimmzettelgruppen_ungueltig tinyint(4) default 0;
alter table papervote_optical add if not exists stimmzettelgruppen_enthaltung tinyint(4) default 0;

alter table papervote_optical add if not exists stimmzettel_name	varchar(255) default 0;
alter table papervote_optical add if not exists stimmzettel_sitze	int(10) default 0;

alter table papervote_optical add if not exists is_informed	tinyint(4) default 0;
alter table papervote_optical add if not exists is_pending	tinyint(4) default 0;
alter table papervote_optical add if not exists for_review	tinyint(4) default 0;


 

CREATE OR REPLACE TRIGGER `papervote_optical_bu_checks` 
BEFORE
UPDATE ON `papervote_optical` FOR EACH ROW BEGIN



    SET new.stimmzettel_sitze = (select sitze from stimmzettel where id = new.ballotpaper_id);
    SET new.stimmzettel_name = (select name from stimmzettel where id = new.ballotpaper_id);

    
    SET new.anzahl_markierungen = json_length(new.`marks`) ;
    SET new.anzahl_stimmzettel_kreuze = length(REGEXP_REPLACE(new.marks, '[^X]', ''));

    SET new.stimmzettel_ungueltig = if ( new.stimmzettel_sitze < new.anzahl_stimmzettel_kreuze  , 1, 0);
    SET new.stimmzettel_enthaltung = if ( new.anzahl_stimmzettel_kreuze =0, 1, 0);
    


    SET new.is_pending = if ( json_value(NEW.edited_marks,'$[0]')!="W" and NEW.edited_marks<> NEW.marks,  1, 0  );
    SET new.is_informed = if (new.marks='[]',1,0);
    SET new.for_review =  if(        (new.is_pending + new.pre_processed + new.stimmzettel_ungueltig + new.stimmzettel_enthaltung + new.is_informed    )>0 and new.is_final <> 1,1,0);
    
END //



CREATE OR REPLACE TRIGGER `papervote_optical_bi_checks` 
BEFORE
INSERT ON `papervote_optical` FOR EACH ROW BEGIN



    SET new.stimmzettel_sitze = (select sitze from stimmzettel where id = new.ballotpaper_id);
    SET new.stimmzettel_name = (select name from stimmzettel where id = new.ballotpaper_id);

    
    SET new.anzahl_markierungen = json_length(new.`marks`) ;
    SET new.anzahl_stimmzettel_kreuze = length(REGEXP_REPLACE(new.marks, '[^X]', ''));

    SET new.stimmzettel_ungueltig = if ( new.stimmzettel_sitze < new.anzahl_stimmzettel_kreuze  , 1, 0);
    SET new.stimmzettel_enthaltung = if ( new.anzahl_stimmzettel_kreuze =0, 1, 0);
    


    SET new.is_pending = if ( json_value(NEW.edited_marks,'$[0]')!="W" and NEW.edited_marks<> NEW.marks,  1, 0  );
    SET new.is_informed = if (new.marks='[]',1,0);
    SET new.for_review =  if(        (new.is_pending + new.pre_processed + new.stimmzettel_ungueltig + new.stimmzettel_enthaltung + new.is_informed    )>0 and new.is_final <> 1,1,0);
    
END //
