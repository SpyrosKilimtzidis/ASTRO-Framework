function [key1,key2,key3,key4,key5]=create_meshsurf_iso(surfs,num)
curves1=mat2str(surfs);
curves2=strrep(curves1,'[','');curves3=strrep(curves2,']','');
key1='INTEGER fem_create_mesh_surfa_num_nodes';
key2='INTEGER fem_create_mesh_surfa_num_elems';
key3='STRING fem_create_mesh_s_nodes_created[VIRTUAL]';
key4='STRING fem_create_mesh_s_elems_created[VIRTUAL]';
key5=sprintf('fem_create_mesh_surf_4( "IsoMesh", 49152, "Surf %s", 1, ["%f"], "Quad4", "#", "#", "Coord 0", "Coord 0", fem_create_mesh_surfa_num_nodes, fem_create_mesh_surfa_num_elems, fem_create_mesh_s_nodes_created, fem_create_mesh_s_elems_created )',curves3,num);

