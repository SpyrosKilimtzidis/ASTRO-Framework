function [curveid,key1,key2]=create_manifoldcurve(curveid,surfid,p1,p2)
curveid=[curveid curveid(end)+1];
key1='STRING sgm_curve_manifold__created_ids[VIRTUAL]';
key2=sprintf('sgm_const_curve_manifold_2point( "%d", "Surface %d", "Point %d", "Point %d", sgm_curve_manifold__created_ids )',curveid(end),surfid,p1,p2);
