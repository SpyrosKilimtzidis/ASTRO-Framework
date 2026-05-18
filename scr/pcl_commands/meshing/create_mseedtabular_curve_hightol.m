function [key1]=create_mseedtabular_curve_hightol(nodes,edge)
curves1=mat2str(nodes);
curves2=strrep(curves1,'[','');curves3=strrep(curves2,']','');
key1=sprintf('mesh_seed_create_tabular_points( "Curve %d", "node %s", 0.05 )',edge,curves3);