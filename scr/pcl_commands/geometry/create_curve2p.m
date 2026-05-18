function [curveid,key1,key2]=create_curve2p(curveid,p1,p2)
curveid=[curveid curveid(end)+1];
key1='STRING asm_line_2point_created_ids[VIRTUAL]';
key2=sprintf('asm_const_line_2point( "%d", "Point %d", "Point %d", 0, "", 50., 1, asm_line_2point_created_ids )',curveid(end),p1,p2);
