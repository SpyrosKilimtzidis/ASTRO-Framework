function [pointid,curveid,key1,key2]=create_curveintersurf2surf(pointid,curveid,surf1,surf2,pointident)
curveid=[curveid curveid(end)+1];
if pointident==0
    pointid=pointid;
elseif pointident==1
    pointid=[pointid pointid(end)+1];
else
    pointid=[pointid pointid(end)+1 pointid(end)+2];
end
key1='STRING sgm_create_curve_in_created_ids[VIRTUAL]';
key2=sprintf('sgm_const_curve_intersect( "%d", 1, "Surface %d", "Surface %d", 0.050000001, 0.5, sgm_create_curve_in_created_ids )',curveid(end),surf1,surf2);