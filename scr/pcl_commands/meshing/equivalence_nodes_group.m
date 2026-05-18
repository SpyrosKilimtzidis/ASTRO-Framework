function [key1,key2,key3]=equivalence_nodes_group(tol,groupid)
key1='REAL fem_equiv_group_x_equivtol';
key2='INTEGER fem_equiv_group_x_segment';
key3=sprintf('fem_equiv_all_group4( ["%s"], 1, "", 1, 1, %f, FALSE, fem_equiv_group_x_equivtol, fem_equiv_group_x_segment )',groupid,tol);
