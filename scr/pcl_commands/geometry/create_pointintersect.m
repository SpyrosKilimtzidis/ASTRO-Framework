function [pointid,key1,key2]=create_pointintersect(pointid,curve1,curve2)
pointid=[pointid pointid(end)+1]  ;
key1='STRING asm_create_grid_int_created_ids[VIRTUAL]';
key2=sprintf('asm_const_grid_intersect_v1( "%d", "Curve %d", "Curve %d", asm_create_grid_int_created_ids )',pointid(end),curve1,curve2);