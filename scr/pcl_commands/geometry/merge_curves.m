function [curveid,key1,key2]=merge_curves(curveid,curve1,curve2)
curveid=[curveid curveid(end)+1];
[~,b1]=find(curve1==curveid);
[~,b2]=find(curve2==curveid);
vec=[b1 b2];
curveid(vec)=[];
key1='STRING sgm_edit_curve_merg_created_ids[VIRTUAL]';
key2=sprintf('sgm_edit_curve_merge( "%d", "Curve %d %d", 1, 0.00050000002, TRUE, sgm_edit_curve_merg_created_ids )',curveid(end),curve1,curve2);
