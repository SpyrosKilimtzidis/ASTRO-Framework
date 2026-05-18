function [pointid,curveid,key1,key2]=extract_curvefromsurf(dist,direction,pointid,curveid,surfid,unq)
% Check if curveid already exists otherwise initialize
if isempty(curveid)==0
curveid=[curveid curveid(end)+1];
else
 curveid=1;  
end
curveidloc=curveid(end);
key1='STRING sgm_create_curve_ex_created_ids[VIRTUAL]';
key2=sprintf('sgm_const_curve_extract( "%d", "Surface %d", %d, %f, sgm_create_curve_ex_created_ids )',curveidloc,surfid,direction,dist);
if unq==2 
    if isempty(pointid)==0
pointid=[pointid pointid(end)+1 pointid(end)+2]  ;
    else
        pointid=[1 2];
    end
elseif unq==1
    if isempty(pointid)==0
        pointid=[pointid pointid(end)+1]  ;
    else
         pointid=1;  
    end
else
    pointid=pointid;
end

