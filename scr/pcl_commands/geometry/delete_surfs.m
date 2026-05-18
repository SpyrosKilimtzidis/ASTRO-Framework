function [surfid,key1,key2]=delete_surfs(surfid,surfslist)
curves1=mat2str(surfslist);
curves2=strrep(curves1,'[','');curves3=strrep(curves2,']','');
key1='STRING asm_delete_surface_deleted_ids[VIRTUAL]';
key2=sprintf('asm_delete_surface( "Surf %s", asm_delete_surface_deleted_ids )',curves3);
%% Remove from surfid
a1=ismember(surfid,surfslist);
surfid=surfid(a1==0);