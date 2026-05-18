function [key1,key2,key3]=equivalence_nodes_groups(tol,groupid1,groupid2)
key1='REAL fem_equiv_group_x_equivtol';
key2='INTEGER fem_equiv_group_x_segment';
key3=sprintf('fem_equiv_all_group4( ["%s", "%s"], 2, "", 1, 1, %f, FALSE, fem_equiv_group_x_equivtol, fem_equiv_group_x_segment )',groupid1,groupid2,tol);
