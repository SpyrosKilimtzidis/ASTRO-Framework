function [key1,key2]=associate_curve2surfedge(surfc,edge,surfid)
key1='STRING sgm_associate_cu_associated_ids[VIRTUAL]';
key2=sprintf('sgm_associate_curve_surface( "Surface %d.%d", "Surface %d", sgm_associate_cu_associated_ids )',surfc,edge,surfid);