function [pointid,curveid,key1,key2]=create_curveprojectplane(pointid,curveid,vector,plane,curve,ident)
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
key1='STRING sgm_create_curve_pr_created_ids[VIRTUAL]';
key2=sprintf('sgm_const_curve_project_v1( "%d", "Curve %d", "Plane %d", 2, FALSE, 3, "Vector %d", "Coord 0", 0.0049999999, sgm_create_curve_pr_created_ids )',curveid(end),curve,plane,vector);