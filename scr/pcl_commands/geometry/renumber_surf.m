function [key1,key2]=renumber_surf(surfidnew,surfidold)
key1='STRING sgm_renum_surface_new_ids[VIRTUAL]';
key2=sprintf('sgm_renumber( 1, "surface", "%d", "Surface %d", sgm_renum_surface_new_ids )',surfidnew,surfidold);