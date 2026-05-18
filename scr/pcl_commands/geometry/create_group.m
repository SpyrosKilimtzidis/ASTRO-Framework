function [key1,key2,key3]=create_group(grpid,surfs2)
curves1=mat2str(surfs2);
curves2=strrep(curves1,'[','');curves3=strrep(curves2,']','');
key1=sprintf('ga_group_create( "%s" )',grpid);
key2=sprintf('ga_group_entity_add( "%s", "Surface %s" )',grpid,curves3);
key3=sprintf('bv_group_reorganize( 1, ["%s"], [0, 0, 0, 0, 0, 0, 0], [0, 1, 1, 0] )',grpid);