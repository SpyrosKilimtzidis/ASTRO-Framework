function [surfid,key1,key2]=create_surfrevolve(coords,curverev,axis,angle,surfid)
surfid=[surfid surfid(end)+1];
key1='STRING sgm_sweep_surface_r_created_ids[VIRTUAL]';
key2=sprintf('sgm_const_surface_revolve( "%d", "Coord %d.%d", %d., 0., "Coord %d", "Curve %d", sgm_sweep_surface_r_created_ids )',surfid(end),coords,axis,angle,coords,curverev);
