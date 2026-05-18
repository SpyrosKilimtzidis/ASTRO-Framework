function [curveid,key1,key2]=merge_curveslist(curveid,curvelist)
curveid=[curveid curveid(end)+1];
curves1=mat2str(curvelist);
curves2=strrep(curves1,'[','');curves3=strrep(curves2,']','');
key1='STRING sgm_edit_curve_merg_created_ids[VIRTUAL]';
key2=sprintf('sgm_edit_curve_merge( "%d", "Curve %s", 1, 0.0049999999, FALSE, sgm_edit_curve_merg_created_ids )',curveid(end),curves3);
