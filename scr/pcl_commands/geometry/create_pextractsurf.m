function [pointid,key1,key2]=create_pextractsurf(pointid,surf,diru,dirv)
pointid=[pointid pointid(end)+1];
key1='STRING asm_grid_extract_su_created_ids[VIRTUAL]';
key2=sprintf('asm_const_grid_extract_surface( "%d", %f, %f, "Surface %d", asm_grid_extract_su_created_ids )',pointid(end),diru,dirv,surf);
