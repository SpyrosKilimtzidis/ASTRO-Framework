function [pointid,curveid,key1,key2]=extract_curvefromedge(pointid,curveid,surfid,unq,inst,edge)
if inst==0
curveid=curveid+1;
else
curveid=[curveid curveid(end)+1];
end
curveidloc=curveid(end);
key1='STRING sgm_create_curve_ex_created_ids[VIRTUAL]';
key2=sprintf('sgm_const_curve_extract_edge( "%d", "Surface %d.%d", sgm_create_curve_ex_created_ids )',curveidloc,surfid,edge);
if inst==0 
 pointid=[pointid+1 pointid+2]  ;
else
    if unq==2
pointid=[pointid pointid(end)+1 pointid(end)+2]  ;
    elseif unq==1
pointid=[pointid pointid(end)+1 ]  ;
    else
        pointid=pointid;
    end
end

