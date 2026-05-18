function [] = properties_total_taper(x,mat,surfs,curves)
% Root-to-tip prescribed taper ratios
r_skin = 0.25;   % t_tip/t_root for wing skins
r_cap  = 0.30;   % t_tip/t_root for spar caps
% Tail parameters
r_tail_skin = 0.40;      % prescribed tip/root ratio
t_tail_skin_root = x(14);  % if using 18-variable setup
tail_span = 9.8646412;
zm=x(6);
vdir1=zm/tail_span;
vtot=0:vdir1:1;
if vtot(end)~=1
vtot(end+1)=1;
end
n_tail_bays = length(vtot) - 1;
t_tail_skin_bay = zeros(1,n_tail_bays);

for i = 1:n_tail_bays
    eta_mid_tail = 0.5*(vtot(i) + vtot(i+1));
    t_tail_skin_bay(i) = t_tail_skin_root * ...
        (1 - eta_mid_tail*(1 - r_tail_skin));
end
% Named thickness variables
t_us_root  = x(8);
t_ls_root  = x(9);
t_usc_root = x(10);
t_lsc_root = x(11);

t_wing_spar_web = x(12);
t_wing_rib      = x(13);
t_tail_spar     = x(15);
t_tail_rib      = x(16);
t_fuse_frame    = x(17);
t_fuse_skin     = x(18);

t_fuse_floor = max(t_fuse_skin, 0.008);

% Beam dimensions
w_beams = 0.15;
h_beams = 0.05;
w_wing_stringers = 0.150;
w_wing_caps = 0.150;

% Spanwise coordinate for tapering
wing_span = [8.03 24.90855];
zm = [x(3) x(4)];
vdir1 = zm ./ wing_span;

vtot1 = 0:vdir1(1):0.995;
vtot2 = 0:vdir1(2):1;

if 1-vtot2(end) <= 0.01
    vtot2(end) = 1;
end
if vtot2(end) ~= 1
    vtot2(end+1) = 1;
end

L1 = wing_span(1);
L2 = wing_span(2);
eta_break = L1/(L1+L2);

eta1 = vtot1 * eta_break;
eta2 = eta_break + vtot2*(1-eta_break);

eta_global = [eta1 eta2];

assert(abs(eta_global(1)) < 1e-10, 'eta_global does not start at 0');
assert(abs(eta_global(end)-1) < 1e-10, 'eta_global does not end at 1');
assert(all(diff(eta_global) > 0), 'eta_global has duplicate/decreasing values');

n_stations = length(eta_global);
n_bays = n_stations - 1;

t_us  = zeros(1,n_bays);
t_ls  = zeros(1,n_bays);
t_usc = zeros(1,n_bays);
t_lsc = zeros(1,n_bays);

for i = 1:n_bays
    eta_mid = 0.5*(eta_global(i) + eta_global(i+1));
    t_us(i)  = t_us_root  * (1 - eta_mid*(1-r_skin));
    t_ls(i)  = t_ls_root  * (1 - eta_mid*(1-r_skin));
    t_usc(i) = t_usc_root * (1 - eta_mid*(1-r_cap));
    t_lsc(i) = t_lsc_root * (1 - eta_mid*(1-r_cap));
end
% Initialize ses file counter
jkk=1;
% Material entries
[data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1}]=create_mat1(mat.name,mat.E,mat.G,mat.rho,mat.X,mat.Y,mat.S);jkk=jkk+2;
%% Properties - Shell Elements
% Wing
wing_ribs=reshape(surfs.wing.ribs,[1 size(surfs.wing.ribs,1)*size(surfs.wing.ribs,2)]);
wing_fs=surfs.wing.fs(:,end)';
wing_ms=surfs.wing.ms(:,end)';
wing_rs=surfs.wing.rs(:,end)';
% Write properties for upper and lower skins
for nrb = 1:n_bays
    us_surfs = surfs.wing.us(nrb, :);
    ls_surfs = surfs.wing.ls(nrb, :);
    prop_name_us = ['wing_us_' num2str(nrb)];
    prop_name_ls = ['wing_ls_' num2str(nrb)];
    [data_sesupd3{1}{jkk}]=create_pshellprops(prop_name_us,mat.name,t_us(nrb),us_surfs);jkk=jkk+1;
    [data_sesupd3{1}{jkk}]=create_pshellprops(prop_name_ls,mat.name,t_ls(nrb),ls_surfs);jkk=jkk+1;
end
% Add bulkheads and extended surfaces
[data_sesupd3{1}{jkk}]=create_pshellprops('wing_skins_ext_us',mat.name,t_us(1),[surfs.fuse_barrel.ext_skins_surfs_outer(1) surfs.fuse_barrel.ext_skins_surfs_outer(3) surfs.fuse_barrel.interc_skins(1) surfs.fuse_barrel.interc_skins(3)]);jkk=jkk+1;
[data_sesupd3{1}{jkk}]=create_pshellprops('wing_skins_ext_ls',mat.name,t_ls(1),[surfs.fuse_barrel.ext_skins_surfs_outer(2) surfs.fuse_barrel.ext_skins_surfs_outer(4) surfs.fuse_barrel.interc_skins(2) surfs.fuse_barrel.interc_skins(4)]);jkk=jkk+1;
% Rest of wing
[data_sesupd3{1}{jkk}]=create_pshellprops('wing_spars',mat.name,t_wing_spar_web,[wing_fs wing_ms wing_rs surfs.fuse_barrel.bulksurfs surfs.fuse_barrel.spars_to_bulks]); jkk=jkk+1;
[data_sesupd3{1}{jkk}]=create_pshellprops('wing_ribs',mat.name,t_wing_rib,wing_ribs); jkk=jkk+1;
[data_sesupd3{1}{jkk}]=create_pshellprops('wing_te',mat.name,t_wing_rib,surfs.wing.te(:,end)'); jkk=jkk+1;

% Fuselage
fuse_skins=[surfs.fuse_nose.skins surfs.fuse_barrel.skins surfs.fuse_barrel.skin_surfs surfs.fuse_outer_section_1.skins surfs.fuse_outer_section_2.skins surfs.fuse_outer_section_2.skin_surfs_blk surfs.fuse_outer_section_2.outer_section ];
fuse_floor=[surfs.fuse_nose.floor surfs.fuse_barrel.floor surfs.fuse_outer_section_1.floor surfs.fuse_outer_section_2.floor];
fuse_stiffeners=[surfs.fuse_nose.stiffeners surfs.fuse_barrel.stiffeners surfs.fuse_outer_section_1.stiffeners];
[data_sesupd3{1}{jkk}]=create_pshellprops('fuse_skins',mat.name,t_fuse_skin,fuse_skins); jkk=jkk+1;
[data_sesupd3{1}{jkk}]=create_pshellprops('fuse_floor',mat.name,t_fuse_floor,fuse_floor); jkk=jkk+1;
[data_sesupd3{1}{jkk}]=create_pshellprops('fuse_stiff',mat.name,t_fuse_frame,fuse_stiffeners); jkk=jkk+1;
% Tail

tail_us=reshape(surfs.tail.us,[1 size(surfs.tail.us,1)*size(surfs.tail.us,2)]);
tail_ls=reshape(surfs.tail.ls,[1 size(surfs.tail.ls,1)*size(surfs.tail.ls,2)]);
tail_ribs=reshape(surfs.tail.ribs,[1 size(surfs.tail.ribs,1)*size(surfs.tail.ribs,2)]);
tail_fs=surfs.tail.fs(:,end)';
tail_rs=surfs.tail.rs(:,end)';
% Write properties
for i = 1:n_tail_bays
    tail_us_i = surfs.tail.us(i,:);
    tail_ls_i = surfs.tail.ls(i,:);

    prop_name_tail_us = ['tail_us_' num2str(i)];
    prop_name_tail_ls = ['tail_ls_' num2str(i)];

    [data_sesupd3{1}{jkk}] = create_pshellprops( ...
        prop_name_tail_us, mat.name, t_tail_skin_bay(i), tail_us_i);
    jkk = jkk + 1;

    [data_sesupd3{1}{jkk}] = create_pshellprops( ...
        prop_name_tail_ls, mat.name, t_tail_skin_bay(i), tail_ls_i);
    jkk = jkk + 1;
end
[data_sesupd3{1}{jkk}] = create_pshellprops( 'tail_skins_ext', mat.name, t_tail_skin_bay(1), surfs.fuse_outer_section_2.ext_skins);jkk=jkk+1;
[data_sesupd3{1}{jkk}]=create_pshellprops('tail_spars',mat.name,t_tail_spar,[tail_fs tail_rs surfs.fuse_outer_section_2.bulkheads]); jkk=jkk+1;
[data_sesupd3{1}{jkk}]=create_pshellprops('tail_ribs',mat.name,t_tail_rib,tail_ribs); jkk=jkk+1;
[data_sesupd3{1}{jkk}]=create_pshellprops('tail_te',mat.name,t_tail_rib,surfs.tail.te(:,end)'); jkk=jkk+1;
%% Properties - Beam Elements
% Fuselage 
fuse_str=[curves.fuse_nose.stringers curves.fuse_barrel.stringers curves.fuse_outer_section_1.stringers curves.fuse_outer_section_2.stringers];
[data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1}] = create_cbeamprops( ...
    fuse_str,h_beams,w_beams,mat.name,'fuse_str','fuse_str',[0 0 1],t_fuse_skin,1);
jkk=jkk+2;
% Wing
% Write properties for upper and lower spar caps and stringers (front and rear)
for nrb = 1:n_bays
    prop_name_fscu = ['wing_fscu_' num2str(nrb)];
    prop_name_fscl = ['wing_fscl_' num2str(nrb)];
    prop_name_mscu = ['wing_mscu_' num2str(nrb)];
    prop_name_mscl = ['wing_mscl_' num2str(nrb)];
    prop_name_rscu = ['wing_rscu_' num2str(nrb)];
    prop_name_rscl = ['wing_rscl_' num2str(nrb)];
    prop_name_strcu = ['wing_strcu_' num2str(nrb)];
    prop_name_strcl = ['wing_strcl_' num2str(nrb)];
    % FSC - Upper and lower
    [data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1}]=create_cbeamprops(curves.wing.fscaps_u(nrb),t_usc(nrb),w_wing_caps,mat.name,prop_name_fscu,prop_name_fscu,[1 0 0],t_us(nrb),1);jkk=jkk+2;
    [data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1}]=create_cbeamprops(curves.wing.fscaps_l(nrb),t_lsc(nrb),w_wing_caps,mat.name,prop_name_fscl,prop_name_fscl,[1 0 0],t_ls(nrb),1);jkk=jkk+2;
    % MSC - Upper and lower
    [data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1}]=create_cbeamprops(curves.wing.mscaps_u(nrb),t_usc(nrb),w_wing_caps,mat.name,prop_name_mscu,prop_name_mscu,[1 0 0],t_us(nrb),1);jkk=jkk+2;
    [data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1}]=create_cbeamprops(curves.wing.mscaps_l(nrb),t_lsc(nrb),w_wing_caps,mat.name,prop_name_mscl,prop_name_mscl,[1 0 0],t_ls(nrb),1);jkk=jkk+2;
    % RSC - Upper and lower
    [data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1}]=create_cbeamprops(curves.wing.rscaps_u(nrb),t_usc(nrb),w_wing_caps,mat.name,prop_name_rscu,prop_name_rscu,[1 0 0],t_us(nrb),1);jkk=jkk+2;
    [data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1}]=create_cbeamprops(curves.wing.rscaps_l(nrb),t_lsc(nrb),w_wing_caps,mat.name,prop_name_rscl,prop_name_rscl,[1 0 0],t_ls(nrb),1);jkk=jkk+2;
    % Stringers - Upper and lower
    [data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1}]=create_cbeamprops(curves.wing.stringers_u(nrb,:),t_us(nrb),w_wing_stringers,mat.name,prop_name_strcu,prop_name_strcu,[0 0 1],t_us(nrb),1);jkk=jkk+2;
    [data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1}]=create_cbeamprops(curves.wing.stringers_l(nrb,:),t_ls(nrb),w_wing_stringers,mat.name,prop_name_strcl,prop_name_strcl,[0 0 1],t_ls(nrb),1);jkk=jkk+2;
end
% Tail
t_tail_skin = t_tail_skin_root;
[data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1}]=create_cbeamprops(curves.tail.fscaps,h_beams,w_beams,mat.name,'tail_fsc','tail_fsc',[1 0 0],t_tail_skin,1); jkk=jkk+2;
[data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1}]=create_cbeamprops(curves.tail.rscaps,h_beams,w_beams,mat.name,'tail_rsc','tail_rsc',[1 0 0],t_tail_skin,1); jkk=jkk+2;
[data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1}]=create_cbeamprops(curves.tail.stringers,h_beams,w_beams,mat.name,'tail_str','tail_str',[0 0 1],t_tail_skin,1); jkk=jkk+2;
jkk = jkk + 1;
%% Output FEM model to locate boundary elements for pressure loads application
% Create groups
wing_us=reshape(surfs.wing.us,[1 size(surfs.wing.us,1)*size(surfs.wing.us,2)]);
wing_ls=reshape(surfs.wing.ls,[1 size(surfs.wing.ls,1)*size(surfs.wing.ls,2)]);
[data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1},data_sesupd3{1}{jkk+2}]=create_group('aero_wing',[wing_us wing_ls]);jkk=jkk+3;
[data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1},data_sesupd3{1}{jkk+2}]=create_group('aero_tail',[tail_us tail_ls]);jkk=jkk+3;
[data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1},data_sesupd3{1}{jkk+2}]=create_group('aero_fuse',[fuse_skins surfs.tail.ribs(1,2:end-2)]);jkk=jkk+3;
[data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1},data_sesupd3{1}{jkk+2}]=create_group('wing_fspar',wing_fs);jkk=jkk+3;
[data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1},data_sesupd3{1}{jkk+2}]=create_group('wing_rspar',wing_rs);jkk=jkk+3;
[data_sesupd3{1}{jkk},data_sesupd3{1}{jkk+1},data_sesupd3{1}{jkk+2}]=create_group('wing_ribs',wing_ribs);jkk=jkk+3;
data_sesupd3=write_bdfoutput('aero_wing','aero_wing',data_sesupd3);
data_sesupd3=write_bdfoutput('aero_tail','aero_tail',data_sesupd3);
data_sesupd3=write_bdfoutput('aero_fuse','aero_fuse',data_sesupd3);
data_sesupd3=write_bdfoutput('wing_fspar','wing_fspar',data_sesupd3);
data_sesupd3=write_bdfoutput('wing_rspar','wing_rspar',data_sesupd3);
data_sesupd3=write_bdfoutput('wing_ribs','wing_ribs',data_sesupd3);
% Output FEM model to locate SPC nodes
data_sesupd3=write_bdfoutput_total(data_sesupd3);
%% Run new session file generate properties
fses1='patran_upd_ini_4.ses';
fids55=fopen(fses1,'w');
for I=1:length(data_sesupd3{1})
  fprintf(fids55, '%s\n', char(data_sesupd3{1}{I}));
end
[~,~]=system('C:\MSC.Software\Patran_x64\20190\bin\patran.exe -db "totalv1.db" -sfp patran_upd_ini_4.ses -ans yes -b');