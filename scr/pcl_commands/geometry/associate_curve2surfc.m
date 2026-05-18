function [key1,key2]=associate_curve2surfc(curve,surf)
key1='STRING sgm_associate_cu_associated_ids[VIRTUAL]';
key2=sprintf('sgm_associate_curve_surface( "Curve %d", "Surface %d", sgm_associate_cu_associated_ids )',curve,surf);