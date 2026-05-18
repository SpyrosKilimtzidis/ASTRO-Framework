function [pointid,key1,key2]=extract_pointfromcurvesurf(pointid,surf,dist,edge)
pointid=[pointid pointid(end)+1]  ;
key1='STRING asm_grid_extract_cu_created_ids[VIRTUAL]';
key2=sprintf('asm_const_grid_extract_v1( "%d", "Surface %d.%d", %f, 1, asm_grid_extract_cu_created_ids )',pointid(end),surf,edge,dist);
