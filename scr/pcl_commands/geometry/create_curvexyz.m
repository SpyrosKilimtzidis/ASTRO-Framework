function [curveid,pointid,key1,key2]=create_curvexyz(curveid,pointid,point,vector,unq)
curveid=[curveid curveid(end)+1];
key1='STRING asm_create_line_xyz_created_ids[VIRTUAL]';
key2=sprintf('asm_const_line_xyz( "%d", "<%f %f %f>", "Point %d", "Coord 0", asm_create_line_xyz_created_ids )',curveid(end),vector(1),vector(2),vector(3),point);
if unq==2
pointid=[pointid pointid(end)+1 pointid(end)+2]  ;
    elseif unq==1
pointid=[pointid pointid(end)+1 ]  ;
    else
        pointid=pointid;
end