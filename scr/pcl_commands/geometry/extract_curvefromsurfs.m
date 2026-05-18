function [pointid,curveid,key1,key2]=extractcurvefromsurfs(dist,direction,pointid,curveid,surflist,ident)
curves1=mat2str(surflist);
curves2=strrep(curves1,'[','');curves3=strrep(curves2,']','');
if isempty(curveid)==0
curveid=[curveid curveid(end)+1 curveid(end)+2];
else
 curveid=1;  
end
curveidloc=curveid(end-1);
key1='STRING sgm_create_curve_ex_created_ids[VIRTUAL]';
key2=sprintf('sgm_const_curve_extract( "%d", "Surface %s", %d, %f, sgm_create_curve_ex_created_ids )',curveidloc,curves3,direction,dist);
if isempty(pointid)==0 && ident==0
pointid=[pointid pointid(end)+1 pointid(end)+2 pointid(end)+3] ;
elseif isempty(pointid)==1
    pointid=[1 2];
elseif ident==1
pointid=pointid;
end


