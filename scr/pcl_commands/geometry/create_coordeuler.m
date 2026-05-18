function [coordid,key1,key2]=create_coordeuler(coordid,p1)
if isempty(coordid)==0
coordid=[coordid coordid(end)+1];
else
 coordid=1;  
end
key1='STRING asm_create_cord_eul_created_ids[VIRTUAL]';
key2=sprintf('asm_const_coord_euler( "%d", 3, 1, 3, 0., 0., 0., "Coord 0", 1, "Point %d", asm_create_cord_eul_created_ids )',coordid(end),p1);