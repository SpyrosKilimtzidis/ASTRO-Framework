function [surfid,key1,key2]=create_surf3(surfid,curvelist)
surfid=[surfid surfid(end)+1];
key1='STRING sgm_surface_3edge_created_ids[VIRTUAL]';
key2=sprintf('sgm_const_surface_3edge( "%d", "Curve %d", "Curve %d", "Curve %d", sgm_surface_3edge_created_ids )',surfid(end),curvelist(1),curvelist(2),curvelist(3));
