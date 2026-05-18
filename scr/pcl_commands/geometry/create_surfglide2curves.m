function [surfid,key1,key2]=create_surfglide2curves(surfid,c1,c2,dirc)
surfid=[surfid surfid(end)+1];
key1='STRING sgm_surface_glide_2_created_ids[VIRTUAL]';
key2=sprintf('sgm_const_surface_glide_2curve( "%d", TRUE, "Curve %d", "Curve %d", "Curve %d", sgm_surface_glide_2_created_ids )',surfid(end),c1,c2,dirc);