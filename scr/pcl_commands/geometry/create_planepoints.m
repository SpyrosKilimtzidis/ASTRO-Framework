function [planeid,key1,key2]=create_planepoints(planeid,coordid,p1,axis)
if isempty(planeid)==0
planeid=[planeid planeid(end)+1];
else
 planeid=1;  
end
key1='STRING sgm_create_plane_po_created_ids[VIRTUAL]';
key2=sprintf('sgm_const_plane_point_vector( "%d", "Point %d", "Coord %d.%d", sgm_create_plane_po_created_ids )',planeid(end),p1,coordid,axis);