function [key1]=create_pshellprops(propid,matid,thickness,surfs)
curves1=mat2str(surfs);
curves2=strrep(curves1,'[','');curves3=strrep(curves2,']','');
key1=sprintf('elementprops_create( "%s", 51, 25, 35, 1, 1, 20, [13, 20, 36, 4037, 4111, 4118, 4119, 8111, 4401, 4402, 4403, 4404, 4405, 4406, 4407, 4408, 4409], [5, 9, 1, 1, 1, 1, 1, 4, 4, 1, 1, 1, 1, 1, 1, 4, 4], ["m:%s", "", "%f", "", "", "", "", "", "", "", "", "", "", "", "", "", ""], "Surface %s" )',...
propid,matid,thickness,curves3);