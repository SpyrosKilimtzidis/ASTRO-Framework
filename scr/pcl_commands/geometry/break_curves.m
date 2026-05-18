function [curveid,key1,key2]=break_curves(curveid,point,curve1)
curveid=[curveid curveid(end)+1 curveid(end)+2];
[~,b1]=find(curve1==curveid);
curveid(b1)=[];
key1='STRING sgm_curve_break_poi_created_ids[VIRTUAL]';
key2=sprintf('sgm_edit_curve_break_point( "%d", "Point %d", "Curve %d", TRUE, sgm_curve_break_poi_created_ids )',curveid(end-1),point,curve1);
