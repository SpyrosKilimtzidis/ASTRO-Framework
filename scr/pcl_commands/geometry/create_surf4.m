function [surfid,key1,key2]=create_surf4(surfid,curvelist)
surfid=[surfid surfid(end)+1];
key1='STRING sgm_surface_4edge_created_ids[VIRTUAL]';
key2=sprintf('sgm_const_surface_4edge( "%d", "Curve %d", "Curve %d", "Curve %d", "Curve %d", sgm_surface_4edge_created_ids )',surfid(end),curvelist(1),curvelist(2),curvelist(3),curvelist(4));