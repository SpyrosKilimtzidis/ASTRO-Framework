function meshing(data_ses,bulkhead_c1,side_curves,side_curves_outer,interc_curves,surfidswing,surfidstail,surfs,curves)
% Initialize session file counter
jk=length(data_ses{1})+1;
% Initialize second file counter
jkk=1;
meshte=0.017;
numelte=1;
%% Meshing
% Nose skins-frames-floors
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2},data_ses{1}{jk+3},data_ses{1}{jk+4}]=create_meshsurf_iso(surfs.fuse_nose.skins,0.2);jk=jk+5;
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2},data_ses{1}{jk+3},data_ses{1}{jk+4}]=create_meshsurf_iso(surfs.fuse_nose.stiffeners,0.2);jk=jk+5;
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2},data_ses{1}{jk+3},data_ses{1}{jk+4}]=create_meshsurf_iso(surfs.fuse_nose.floor,0.2);jk=jk+5;
% Barrel (Nose to lft bulkhead surfs only)
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2},data_ses{1}{jk+3},data_ses{1}{jk+4}]=create_meshsurf_iso(surfs.fuse_barrel.skins,0.2);jk=jk+5;
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2},data_ses{1}{jk+3},data_ses{1}{jk+4}]=create_meshsurf_iso(surfs.fuse_barrel.stiffeners,0.2);jk=jk+5;
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2},data_ses{1}{jk+3},data_ses{1}{jk+4}]=create_meshsurf_iso(surfs.fuse_barrel.floor,0.2);jk=jk+5;
% Middle bulkhead surface 
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2},data_ses{1}{jk+3},data_ses{1}{jk+4}]=create_meshsurf_paver(surfs.fuse_barrel.bulksurfs(2),0.2);jk=jk+5;
% Equivalence
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=equivalence_nodes(0.005);jk=jk+3;
% Run ses to get mesh seed
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=create_group('side_surfs',[surfs.fuse_barrel.sidesurfs(:,1)' surfs.fuse_barrel.bulksurfs(2) surfs.fuse_barrel.sidesurfs(:,2)']);
data_ses=write_bdfoutput('side_mesh_wing','side_surfs',data_ses);
%% Write geometry and directly meshable surfaces session file
fsesini='patran_ini.ses';
fidini=fopen(fsesini);
data2=textscan(fidini,'%s', 'delimiter', '\n');
fses='patran_upd_ini.ses';
fid5s=fopen(fses,'w');
for I=1:length(data2{1})+length(data_ses{1})
    if I<=length(data2{1})
  fprintf(fid5s, '%s\n', char(data2{1}{I}));
    elseif I>length(data2{1}) && I<=length(data2{1})+length(data_ses{1})
   fprintf(fid5s, '%s\n', char(data_ses{1}{I-length(data2{1})}));
    end
end
[~,~]=system('C:\MSC.Software\Patran_x64\20190\bin\patran.exe -sfp patran_upd_ini.ses -ans yes -b');
%% Generate mesh for the rest of the surfaces, excluding outer section 2 and tail surfaces
% Read current mesh of sides
side_nodes=meshread_skins('side_mesh_wing.bdf');
%   Generate mesh seed for bulkhead curves and skin surface curves -- Check edge numbering consistency
% FS (Many nodes so use typical routine)
[data_sesupd{1}{jkk}]=create_mseedtabular_curve(side_nodes',bulkhead_c1(1));jkk=jkk+1;
[data_sesupd{1}{jkk}]=create_mseedtabular_curve(side_nodes',side_curves(1));jkk=jkk+1;
% MS
[data_sesupd{1}{jkk}]=create_mseedtabular_curve(side_nodes',side_curves(2));jkk=jkk+1;
% RS
[data_sesupd{1}{jkk}]=create_mseedtabular_curve(side_nodes',bulkhead_c1(3));jkk=jkk+1;
[data_sesupd{1}{jkk}]=create_mseedtabular_curve(side_nodes',side_curves(3));jkk=jkk+1;
% Mesh FS & interconnection
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2},data_sesupd{1}{jkk+3},data_sesupd{1}{jkk+4}]=create_meshsurf_paver([surfs.fuse_barrel.bulksurfs(1) surfs.fuse_barrel.spars_to_bulks(1)],0.2);jkk=jkk+5;
% Mesh fuselage skin left surface
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2},data_sesupd{1}{jkk+3},data_sesupd{1}{jkk+4}]=create_meshsurf_paver(surfs.fuse_barrel.skin_surfs(1),0.2);jkk=jkk+5;
% Mesh left skin surfaces (Iso is good), external and internal
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2},data_sesupd{1}{jkk+3},data_sesupd{1}{jkk+4}]=create_meshsurf_iso(surfs.fuse_barrel.ext_skins_surfs_outer(1:2),0.2);jkk=jkk+5;
% Equivalence
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2}]=equivalence_nodes(0.005);jkk=jkk+3;
% Mesh RS & interconnection
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2},data_sesupd{1}{jkk+3},data_sesupd{1}{jkk+4}]=create_meshsurf_paver([surfs.fuse_barrel.bulksurfs(3) surfs.fuse_barrel.spars_to_bulks(3)],0.2);jkk=jkk+5;
% Mesh fuselage skin right surface
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2},data_sesupd{1}{jkk+3},data_sesupd{1}{jkk+4}]=create_meshsurf_paver(surfs.fuse_barrel.skin_surfs(2),0.2);jkk=jkk+5;
% Mesh right skin surfaces (Iso is good)
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2},data_sesupd{1}{jkk+3},data_sesupd{1}{jkk+4}]=create_meshsurf_iso(surfs.fuse_barrel.ext_skins_surfs_outer(3:4),0.2);jkk=jkk+5;
% Equivalence
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2}]=equivalence_nodes(0.005);jkk=jkk+3;
% Mesh MS interconnection
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2},data_sesupd{1}{jkk+3},data_sesupd{1}{jkk+4}]=create_meshsurf_paver(surfs.fuse_barrel.spars_to_bulks(2),0.2);jkk=jkk+5;
% Equivalence
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2}]=equivalence_nodes(0.005);jkk=jkk+3;
%% Mesh fuselage outer section 1
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2},data_sesupd{1}{jkk+3},data_sesupd{1}{jkk+4}]=create_meshsurf_iso(surfs.fuse_outer_section_1.skins,0.2);jkk=jkk+5;
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2},data_sesupd{1}{jkk+3},data_sesupd{1}{jkk+4}]=create_meshsurf_iso(surfs.fuse_outer_section_1.stiffeners,0.2);jkk=jkk+5;
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2},data_sesupd{1}{jkk+3},data_sesupd{1}{jkk+4}]=create_meshsurf_iso(surfs.fuse_outer_section_1.floor,0.2);jkk=jkk+5;
% Equivalence
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2}]=equivalence_nodes(0.01);jkk=jkk+3;
%% Mesh fuselage outer section 2
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2},data_sesupd{1}{jkk+3},data_sesupd{1}{jkk+4}]=create_meshsurf_iso(surfs.fuse_outer_section_2.skins,0.2);jkk=jkk+5;
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2},data_sesupd{1}{jkk+3},data_sesupd{1}{jkk+4}]=create_meshsurf_iso(surfs.fuse_outer_section_2.floor,0.2);jkk=jkk+5;
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2},data_sesupd{1}{jkk+3},data_sesupd{1}{jkk+4}]=create_meshsurf_iso(surfs.fuse_outer_section_2.outer_section,0.2);jkk=jkk+5;
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2}]=equivalence_nodes(0.005);jkk=jkk+3;
% Run ses to get mesh seed (Side tail and interconnection between fuselage
% and wing skins
[data_sesupd{1}{jkk},data_sesupd{1}{jkk+1},data_sesupd{1}{jkk+2}]=create_group('side_surfs_outer',[surfs.fuse_outer_section_2.skins surfs.fuse_outer_section_2.outer_section]);jkk=jkk+3;
data_sesupd=write_bdfoutput('side_mesh_tail','side_surfs_outer',data_sesupd);
%% Write new session and execute
fses1='patran_upd_ini_2.ses';
fid5s1=fopen(fses1,'w');
for I=1:length(data_sesupd{1})
  fprintf(fid5s1, '%s\n', char(data_sesupd{1}{I}));
end
[~,~]=system('C:\MSC.Software\Patran_x64\20190\bin\patran.exe -db "totalv1.db" -sfp patran_upd_ini_2.ses -ans yes -b');
%% Generate mesh for the rest of the surfaces
% Rest file counter 
jk2=1;
% Read current mesh
side_nodes_tail=meshread_skins('side_mesh_tail.bdf');
% FS
[data_sesupd1{1}{jk2}]=create_mseedtabular_curve(side_nodes_tail',side_curves_outer(1));jk2=jk2+1;
[data_sesupd1{1}{jk2}]=create_mseedtabular_curve_hightol(side_nodes_tail',side_curves_outer(2));jk2=jk2+1;
[data_sesupd1{1}{jk2}]=create_mseedtabular_curve(side_nodes_tail',side_curves_outer(3));jk2=jk2+1;
% RS
[data_sesupd1{1}{jk2}]=create_mseedtabular_curve(side_nodes_tail',side_curves_outer(4));jk2=jk2+1;
[data_sesupd1{1}{jk2}]=create_mseedtabular_curve(side_nodes_tail',side_curves_outer(5));jk2=jk2+1;
[data_sesupd1{1}{jk2}]=create_mseedtabular_curve(side_nodes_tail',side_curves_outer(6));jk2=jk2+1;
% Mesh FS & RS
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshsurf_paver(surfs.fuse_outer_section_2.bulkheads,0.2);jk2=jk2+5;
% Equivalence (Need high tolerance because of tail FS and bulkhead
% mismatch)
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2}]=equivalence_nodes(0.05);jk2=jk2+3;
% Mesh two skin surfaces between FS and RS
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshsurf_paver(surfs.fuse_outer_section_2.skin_surfs_blk,0.2);jk2=jk2+5;
% Equivalence 
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2}]=equivalence_nodes(0.005);jk2=jk2+3;
% Mesh extended skin surfaces
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshsurf_paver(surfs.fuse_outer_section_2.ext_skins,0.2);jk2=jk2+5;
% Equivalence 
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2}]=equivalence_nodes(0.005);jk2=jk2+3;
%% Mesh Tail
for kk=1:length(curves.tail.cte)
    data_sesupd1{1}{jk2}=create_mseed(curves.tail.cte(kk),numelte);jk2=jk2+1;
end
Cexc1 = setdiff(surfidstail,reshape(surfs.tail.ribs,[1 size(surfs.tail.ribs,1)*size(surfs.tail.ribs,2)]));
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshsurf_iso(Cexc1,0.2);jk2=jk2+5;
% Mesh interal surfaces with num2 (excluding TE surfaces due to meshing issues)
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshsurf_iso(reshape(surfs.tail.ribs(:,1:end-1),[1 size(surfs.tail.ribs,1)*(size(surfs.tail.ribs,2)-1)]),0.2);jk2=jk2+5;
% Mesh TE surfaces 
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshsurf_iso(surfs.tail.ribs(:,end)',meshte);jk2=jk2+5;
% Mesh curves- Spar caps
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshcurve(curves.tail.caps,0.2);jk2=jk2+5;
% Mesh curves- Stringers
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshcurve(curves.tail.stringers,0.2);jk2=jk2+5;
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2}]=create_group('tail_surfs',surfidstail);jk2=jk2+3;
% Equivalence nodes
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2}]=equivalence_nodes_group(0.005,'tail_surfs');jk2=jk2+3;
% Mesh fuselage curves
fuse_str=[curves.fuse_nose.stringers curves.fuse_barrel.stringers curves.fuse_outer_section_1.stringers curves.fuse_outer_section_2.stringers];
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshcurve(fuse_str,0.2);jk2=jk2+5;
%% Mesh wing
% Set TE mesh to avoid degenerate elements
for kk=1:length(curves.wing.cte)
    data_sesupd1{1}{jk2}=create_mseed(curves.wing.cte(kk),numelte);jk2=jk2+1;
end
% Mesh all external surfaces first with num3
Cexc = setdiff(surfidswing(7:end),reshape(surfs.wing.ribs,[1 size(surfs.wing.ribs,1)*size(surfs.wing.ribs,2)]));
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshsurf_iso(Cexc,0.2);jk2=jk2+5;
% Mesh interal surfaces with num2 (excluding TE surfaces due to meshing issues)
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshsurf_iso(reshape(surfs.wing.ribs(:,1:end-1),[1 size(surfs.wing.ribs,1)*(size(surfs.wing.ribs,2)-1)]),0.2);jk2=jk2+5;
% Mesh TE surfaces with paver
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshsurf_paver(surfs.wing.ribs(:,end)',meshte);jk2=jk2+5;
% Mesh curves- Spar caps
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshcurve(curves.wing.caps,0.2);jk2=jk2+5;
% Mesh curves- Stringers
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2},data_sesupd1{1}{jk2+3},data_sesupd1{1}{jk2+4}]=create_meshcurve(curves.wing.stringers,0.2);jk2=jk2+5;
% Equivalence 
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2}]=create_group('wing_surfs',surfidswing);jk2=jk2+3;
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2}]=equivalence_nodes_group(0.005,'wing_surfs');jk2=jk2+3;
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2}]=create_group('interc_surfs',[surfs.wing.ribs(1,:) surfs.fuse_barrel.ext_skins_surfs_outer surfs.fuse_barrel.interc_skins]);jk2=jk2+3;
[data_sesupd1{1}{jk2},data_sesupd1{1}{jk2+1},data_sesupd1{1}{jk2+2}]=create_group('tail_interc',[surfs.fuse_outer_section_2.skins surfs.fuse_outer_section_2.bulkheads]);jk2=jk2+3;
data_sesupd1=write_bdfoutput('interc_surfs','interc_surfs',data_sesupd1);
% Write new session and execute
fses2='patran_upd_ini_3.ses';
fid5s2=fopen(fses2,'w');
for I=1:length(data_sesupd1{1})
  fprintf(fid5s2, '%s\n', char(data_sesupd1{1}{I}));
end
[~,~]=system('C:\MSC.Software\Patran_x64\20190\bin\patran.exe -db "totalv1.db" -sfp patran_upd_ini_3.ses -ans yes -b');
%% Obtain mesh seed for inteconnection surfaces (fucking finally!)
jk3=1;
% Read current mesh
interc_nodes=meshread_skins('interc_surfs.bdf');
% Mesh seed for interconnection curves
for num_c=1:length(interc_curves)
[data_sesupd2{1}{jk3}]=create_mseedtabular_curve(interc_nodes',interc_curves(num_c));jk3=jk3+1;
end
% Mesh surfaces
[data_sesupd2{1}{jk3},data_sesupd2{1}{jk3+1},data_sesupd2{1}{jk3+2},data_sesupd2{1}{jk3+3},data_sesupd2{1}{jk3+4}]=create_meshsurf_paver(surfs.fuse_barrel.interc_skins,0.2);jk3=jk3+5;
% Equivalence 
[data_sesupd2{1}{jk3},data_sesupd2{1}{jk3+1},data_sesupd2{1}{jk3+2}]=equivalence_nodes_group(0.005,'interc_surfs');jk3=jk3+3;
[data_sesupd2{1}{jk3},data_sesupd2{1}{jk3+1},data_sesupd2{1}{jk3+2}]=equivalence_nodes_group(0.05,'tail_interc');jk3=jk3+3;
[data_sesupd2{1}{jk3},data_sesupd2{1}{jk3+1},data_sesupd2{1}{jk3+2}]=equivalence_nodes(0.005);jk3=jk3+3;
% Write new session and execute
fses3='patran_upd_ini_final.ses';
fid5s3=fopen(fses3,'w');
for I=1:length(data_sesupd2{1})
  fprintf(fid5s3, '%s\n', char(data_sesupd2{1}{I}));
end
[~,~]=system('C:\MSC.Software\Patran_x64\20190\bin\patran.exe -db "totalv1.db" -sfp patran_upd_ini_final.ses -ans yes -b');
