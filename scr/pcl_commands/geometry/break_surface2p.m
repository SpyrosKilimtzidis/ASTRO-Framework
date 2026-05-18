function [surfid,key1,key2]=break_surface2p(surfid,p1,p2,surfbreak,delcheck)
if delcheck==0
surfid=[surfid surfid(end)+1 surfid(end)+2];
key1='STRING sgm_surface_break_2_created_ids[VIRTUAL]';
key2=sprintf('sgm_edit_surface_break_v1( "%d", "Surface %d", FALSE, 2, 0, 0., "Point %d", "Point %d", "", sgm_surface_break_2_created_ids )',surfid(end-1),surfbreak,p1,p2);
else
surfid=[surfid surfid(end)+1 surfid(end)+2];
[~,b1]=find(surfbreak==surfid);
surfid(b1)=[];
key1='STRING sgm_surface_break_2_created_ids[VIRTUAL]';
key2=sprintf('sgm_edit_surface_break_v1( "%d", "Surface %d", TRUE, 2, 0, 0., "Point %d", "Point %d", "", sgm_surface_break_2_created_ids )',surfid(end-1),surfbreak,p1,p2);
end
