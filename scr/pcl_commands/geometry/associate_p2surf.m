function [key1,key2]=associate_p2surf(point,surfid)
key1='STRING sgm_associate_po_associated_ids[VIRTUAL]';
key2=sprintf('sgm_associate_point_surface( "Point %d", "Surface %d", sgm_associate_po_associated_ids )',point,surfid);