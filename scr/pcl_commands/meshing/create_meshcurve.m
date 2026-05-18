function [key1,key2,key3,key4,key5]=create_meshcurve(curves,num)
key1='INTEGER fem_create_mesh_curve_num_nodes';
key2='INTEGER fem_create_mesh_curve_num_elems';
key3='STRING fem_create_mesh_c_nodes_created[VIRTUAL]';
key4='STRING fem_create_mesh_c_elems_created[VIRTUAL]';
curves1=mat2str(curves);
curves2=strrep(curves1,'[','');curves3=strrep(curves2,']','');
key5=sprintf('fem_create_mesh_curv_1( "Curve %s", 16384, %f, "Bar2", "#", "#", "Coord 0", "Coord 0", fem_create_mesh_curve_num_nodes, fem_create_mesh_curve_num_elems, fem_create_mesh_c_nodes_created, fem_create_mesh_c_elems_created )',curves3,num);

