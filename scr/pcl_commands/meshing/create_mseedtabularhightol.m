function [key1]=create_mseedtabularhightol(nodes,surf,edge)
curves1=mat2str(nodes);
curves2=strrep(curves1,'[','');curves3=strrep(curves2,']','');
key1=sprintf('mesh_seed_create_tabular_points( "Surface %d.%d", "node %s", 0.5 )',surf,edge,curves3);