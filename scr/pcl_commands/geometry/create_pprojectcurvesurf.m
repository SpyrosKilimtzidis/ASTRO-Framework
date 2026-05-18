function [pointid,key1,key2]=create_pprojectcurvesurf(pointid,surfid,p1)
pointid=[pointid pointid(end)+1];
key1='STRING asm_create_grid_pro_created_ids[VIRTUAL]';
key2=sprintf('asm_const_grid_project_v1( "%d", "Point %d", "Surface %d.3", 3, FALSE, 1, "<1 0 0>", "Coord 0", asm_create_grid_pro_created_ids )',pointid(end),p1,surfid);