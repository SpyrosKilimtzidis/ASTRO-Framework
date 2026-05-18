function [pointid,curveid,key1,key2]=create_curveintersectplanesurf(pointid,curveid,planeid,surf,ident)
if isempty(curveid)==0
curveid=[curveid curveid(end)+1];
else
 curveid=1;  
end
if ident==0
pointid=pointid;
elseif ident==1
pointid=[pointid pointid(end)+1];
else
pointid=[pointid pointid(end)+1 pointid(end)+2];
end
key1='STRING sgm_create_curve_in_created_ids[VIRTUAL]';
key2=sprintf('sgm_const_curve_intersect( "%d", 2, "Plane %d", "Surface %d", 0.0049999999, 0.050000001, sgm_create_curve_in_created_ids )',curveid(end),planeid,surf);
