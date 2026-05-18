function [surfid,pointid,key1,key2]=create_surfextrudecurvevector(surfid,pointid,curveid,vecid,point)
pointid=[pointid pointid(end)+1] ;
surfid=[surfid surfid(end)+1];
key1='STRING sgm_sweep_surface_e_created_ids[VIRTUAL]';
key2=sprintf('sgm_const_surface_extrude( "%d", "Vector %d", 1., 0., "Point %d", "Coord 0", "Curve %d", sgm_sweep_surface_e_created_ids )',surfid(end),vecid,point,curveid);
