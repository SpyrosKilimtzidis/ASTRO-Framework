function [surfid,pointid,key1,key2]=extrude_surfnormal(surfid,pointid,thick,curveid,ident1,ident2)
surfid=[surfid surfid(end)+1];
if ident2==1   %% Check if input edge has a point that has been already generated from an adjacent edge
pointid=[pointid pointid(end)+1 pointid(end)+2];
else
pointid=[pointid pointid(end)+1 ];
end
key1='STRING sgm_sweep_surface_n_created_ids[VIRTUAL]';
if ident1==1
key2=sprintf('asm_const_surface_normal( "%d", "%f", "", " ", 1, TRUE, "Curve %d", sgm_sweep_surface_n_created_ids )',surfid(end),thick,curveid);
else
key2=sprintf('asm_const_surface_normal( "%d", "%f", "", " ", 1, FALSE, "Curve %d", sgm_sweep_surface_n_created_ids )',surfid(end),thick,curveid);
end
