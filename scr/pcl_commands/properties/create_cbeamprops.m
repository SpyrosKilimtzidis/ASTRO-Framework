function [key1,key2]=create_cbeamprops(curves,w,h,mat,propname,sectid,orient,tskin,identifier)
if identifier==1
    offset=tskin/2+h/2;
else
    offset=-(tskin/2+h/2);
end
curves1=mat2str(curves);
curves2=strrep(curves1,'[','');curves3=strrep(curves2,']','');
key1=sprintf('beam_section_create( "%s", "BAR", ["%f", "%f"] )',sectid,w,h);
key2=sprintf('elementprops_create( "%s", 11, 2, 42, 1, 1, 20, [39, 13, 6, 4042, 4043, 2047, 2048, 1, 10, 11, 4026, 1026, 4044, 4045, 4037, 4047, 4048, 4050, 4051, 4053, 4054, 4056, 4057, 8112, 4061, 4303, 8111, 4403, 4404, 4410, 4411, 8200, 8201, 8202], [11, 5, 2, 2, 2, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6, 4, 4, 1, 1, 1, 6, 4, 4, 4], ["%s", "m:%s", "<%d %d %d>", "<0 0 %f>", "<0 0 %f>", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "Analysis", "Analysis", "Analysis"], "Curve %s" )'...
    ,propname,sectid,mat,orient(1),orient(2),orient(3),offset,offset,curves3);
