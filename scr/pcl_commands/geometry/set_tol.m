function [key1,key2,key3]=set_tol(tol)
key1=sprintf('pref_geo_set_v1( 0, %f, 3 )',tol);
key2=sprintf('pref_global_set_v3( TRUE, 3, "%f", "SAVE" )',tol);
key3='pref_env_set_logical( "revert_enabled", FALSE )';