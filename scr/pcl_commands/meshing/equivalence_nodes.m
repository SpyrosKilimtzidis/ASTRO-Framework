function [key1,key2,key3]=equivalence_nodes(tol)
key1='REAL fem_equiv_all_x_equivtol_ab';
key2='INTEGER fem_equiv_all_x_segment';
key3=sprintf('fem_equiv_all_group4( [" "], 0, "", 1, 1, %f, FALSE, fem_equiv_all_x_equivtol_ab, fem_equiv_all_x_segment )',tol);