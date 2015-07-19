/*TRIGGER TO UPDATE OR CREATE MATERIAL TABLE*/
set search_path to census;
 create or replace function update_material()
 returns trigger as $$
 begin 
	if (TG_OP='INSERT') THEN
	truncate material cascade;
	insert into material(material_no,roof_no,wall_no,floor_no) SELECT (10000*roof_material.roof_no)+(100*wall_material.wall_no)+(1*floor_material.floor_no),roof_material.roof_no,wall_material.wall_no,floor_material.floor_no from roof_material,wall_material,floor_material;
	end if;
	RETURN NULL;
 end;
	$$ LANGUAGE plpgsql;

/*TRIGGER ON UPDATE OF ROOF MATERIAL*/
create trigger update_material_trigger1
after insert on roof_material
for each row execute procedure update_material();

/*TRIGGER ON UPDATE OF WALL MATERIAL*/
create trigger update_material_trigger2
after insert on wall_material
for each row execute procedure update_material();
/*TRIGGER ON UPDATE OF FLOOR MATERIAL*/
create trigger update_material_trigger3
after insert on floor_material
for each row execute procedure update_material();
