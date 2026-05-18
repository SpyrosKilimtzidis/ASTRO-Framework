function [surfid,pointid,key1,key2]=break_surface1p(surfid,pointid,p1,surfbreak,delcheck,np)
if np==1
pointid=[pointid pointid(end)+1]  ;
else
pointid=pointid;
end
key1='STRING sgm_surface_break_p_created_ids[VIRTUAL]';
if delcheck==0
surfid=[surfid surfid(end)+1 surfid(end)+2];
key2=sprintf('sgm_edit_surface_break_v1( "%d", "Surface %d", FALSE, 2, 0, 0., "Point %d", " ", "", sgm_surface_break_p_created_ids )',surfid(end-1),surfbreak,p1);
else
surfid=[surfid surfid(end)+1 surfid(end)+2];
[~,b1]=find(surfbreak==surfid);
surfid(b1)=[];
key2=sprintf('sgm_edit_surface_break_v1( "%d", "Surface %d", TRUE, 2, 0, 0., "Point %d", " ", "", sgm_surface_break_p_created_ids )',surfid(end-1),surfbreak,p1);
end
