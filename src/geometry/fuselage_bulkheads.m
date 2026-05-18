function [data_ses,surfid,curveidn,pointidn,surfsfinal2,intersurfs2,bulkhead_c1,side_curves,interc_curves,surfs,curves]=fuselage_bulkheads(data_ses,frames_sec1,frames_sec2,frames_sec2_1,surfid,curveidn,pointidn,framepointslower,framepointsupper,framepointsmid,spar_points,spar_curves,intersurfs,surfsfinal,bulkhead_c1,bulk_upper_curves,bottom_points_outer,str_points,floor2,surfs,curves)
% Initialize session file counter
jk=length(data_ses{1})+1;
% Delete extruded frame lower surfaces between front and rear spar and floor
strrowhalf=size(intersurfs,1)/2;
delframes1=intersurfs(1:strrowhalf,frames_sec1:frames_sec1+frames_sec2);
delframes=reshape(delframes1,[1 size(delframes1,1)*size(delframes1,2)]);
delsurfs1=surfsfinal(1:strrowhalf,frames_sec1+1:frames_sec1+frames_sec2);
delsurfs2=reshape(delsurfs1,[1 size(delsurfs1,1)*size(delsurfs1,2)]);
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=delete_surfs(surfid,delframes);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=delete_surfs(surfid,delsurfs2);jk=jk+2;
% Return rest of surfaces
surfsfinal2=setdiff(surfsfinal,delsurfs2);
intersurfs2=setdiff(intersurfs,delframes);
sidesurfs(:,1)=surfsfinal(1:strrowhalf,frames_sec1);
sidesurfs(:,2)=surfsfinal(1:strrowhalf,frames_sec1+frames_sec2+1);
framepointsmid_bulk=[framepointsmid(frames_sec1+1) framepointsmid(frames_sec1+1+frames_sec2_1) framepointsmid(frames_sec1+frames_sec2+1)];
framepointsmid_intermediate=[framepointsmid(frames_sec1+2:frames_sec1+frames_sec2_1) framepointsmid(frames_sec1+frames_sec2_1+2:frames_sec1+frames_sec2)];
%% Create bulkhead surfaces
% Create 2p curves for the surfaces outer edges to generate skin surfaces(x2)
% Create 4 new lines for the outer edges 
% Upper 
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framepointsmid_bulk(1),framepointsmid_bulk(2));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framepointsmid_bulk(2),framepointsmid_bulk(3));jk=jk+2;
skin_upper_curves=[curveidn(end-1) curveidn(end)];
% Lower 
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framepointslower(frames_sec1+1),framepointslower(frames_sec1+1+frames_sec2_1));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framepointslower(frames_sec1+1+frames_sec2_1),framepointslower(frames_sec1+frames_sec2+1));jk=jk+2;
skin_lower_curves=[curveidn(end-1) curveidn(end)];
% Create skin surface - Store surrounding curves, adding middle one
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[skin_upper_curves(1) skin_lower_curves(1) bulkhead_c1(1) bulkhead_c1(2)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[skin_upper_curves(2) skin_lower_curves(2) bulkhead_c1(2) bulkhead_c1(3)]);jk=jk+2;
skin_surfs=[surfid(end-1) surfid(end)];
% Vertical outer curves
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framepointslower(frames_sec1+1),framepointsupper(frames_sec1+1));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framepointslower(frames_sec1+1+frames_sec2_1),framepointsupper(frames_sec1+1+frames_sec2_1));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framepointslower(frames_sec1+frames_sec2+1),framepointsupper(frames_sec1+frames_sec2+1));jk=jk+2;
frame_curves=[curveidn(end-2) curveidn(end-1) curveidn(end)];
% Project spar points on these curves - First
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointidn,frame_curves(1),spar_points(1));jk=jk+2;
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointidn,frame_curves(1),spar_points(2));jk=jk+2;
bulkouter1=[pointidn(end-1) pointidn(end)];
% Project spar points on these curves - Middle
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointidn,frame_curves(2),spar_points(3));jk=jk+2;
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointidn,frame_curves(2),spar_points(4));jk=jk+2;
bulkoutermid=[pointidn(end-1) pointidn(end)];
% Project spar points on these curves - Second
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointidn,frame_curves(3),spar_points(5));jk=jk+2;
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointidn,frame_curves(3),spar_points(6));jk=jk+2;
bulkouter2=[pointidn(end-1) pointidn(end)];
% Curves bulk-spar 1
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,pointidn(end-5),spar_points(1));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,pointidn(end-4),spar_points(2));jk=jk+2;
bulkintercurves1=[curveidn(end-1) curveidn(end)];
% Curves bulk-spar mid
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,pointidn(end-3),spar_points(3));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,pointidn(end-2),spar_points(4));jk=jk+2;
bulkintercurvesmid=[curveidn(end-1) curveidn(end)];
% Curves bulk-spar 3
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,pointidn(end-1),spar_points(5));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,pointidn(end),spar_points(6));jk=jk+2;
bulkintercurves2=[curveidn(end-1) curveidn(end)];
% Intersect - Bulkhead 1
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pointintersect(pointidn,bulkintercurves1(1),bulkhead_c1(1));jk=jk+2;
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pointintersect(pointidn,bulkintercurves1(2),bulkhead_c1(1));jk=jk+2;
bulkpointsinter1=[pointidn(end-1) pointidn(end)];
% Intersect - Bulkhead Mid
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pointintersect(pointidn,bulkintercurvesmid(1),bulkhead_c1(2));jk=jk+2;
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pointintersect(pointidn,bulkintercurvesmid(2),bulkhead_c1(2));jk=jk+2;
bulkpointsintermid=[pointidn(end-1) pointidn(end)];
% Intersect - Bulkhead 2
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pointintersect(pointidn,bulkintercurves2(1),bulkhead_c1(3));jk=jk+2;
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pointintersect(pointidn,bulkintercurves2(2),bulkhead_c1(3));jk=jk+2;
bulkpointsinter2=[pointidn(end-1) pointidn(end)];
% Create new vertical curves between projected points(upper and lower) - store
% new vertical curves
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,bottom_points_outer(1),framepointslower(frames_sec1+1));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,bottom_points_outer(2),framepointslower(frames_sec1+1+frames_sec2_1));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,bottom_points_outer(3),framepointslower(frames_sec1+frames_sec2+1));jk=jk+2;
bulkhead_outer_curves=[curveidn(end-2) curveidn(end-1) curveidn(end)];
% Create bulkhead surfaces
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf3(surfid,[bulkhead_outer_curves(1) bulk_upper_curves(1) bulkhead_c1(1)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf3(surfid,[bulkhead_outer_curves(2) bulk_upper_curves(2) bulkhead_c1(2)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf3(surfid,[bulkhead_outer_curves(3) bulk_upper_curves(3) bulkhead_c1(3)]);jk=jk+2;
bulk_surfs=[surfid(end-2) surfid(end-1) surfid(end)];
% Create most inner bulkhead curves - store values
% Bulkhead 1
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,spar_points(1),bulkpointsinter1(1));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,spar_points(2),bulkpointsinter1(2));jk=jk+2;
bulk_1_inner_1=[curveidn(end-1) curveidn(end)];
% Bulkhead Mid
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,spar_points(3),bulkpointsintermid(1));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,spar_points(4),bulkpointsintermid(2));jk=jk+2;
bulk_mid_inner_1=[curveidn(end-1) curveidn(end)];
% Bulkhead 2
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,spar_points(5),bulkpointsinter2(1));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,spar_points(6),bulkpointsinter2(2));jk=jk+2;
bulk_2_inner_1=[curveidn(end-1) curveidn(end)];
% Create outer inner bulkhead curves - store values
% Bulkhead 1
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,bulkouter1(1),bulkpointsinter1(1));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,bulkouter1(2),bulkpointsinter1(2));jk=jk+2;
bulk_1_inner_2=[curveidn(end-1) curveidn(end)];
% Bulkhead Mid
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,bulkoutermid(1),bulkpointsintermid(1));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,bulkoutermid(2),bulkpointsintermid(2));jk=jk+2;
bulk_mid_inner_2=[curveidn(end-1) curveidn(end)];
% Bulkhead 2
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,bulkouter2(1),bulkpointsinter2(1));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,bulkouter2(2),bulkpointsinter2(2));jk=jk+2;
bulk_2_inner_2=[curveidn(end-1) curveidn(end)];
% Radial skin curves
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,skin_surfs(1),bulkpointsinter1(1),bulkpointsinter1(2));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,skin_surfs(1),bulkpointsintermid(1),bulkpointsintermid(2));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,skin_surfs(2),bulkpointsinter2(1),bulkpointsinter2(2));jk=jk+2;
side_curves=[curveidn(end-2) curveidn(end-1) curveidn(end)];
% Create surface connecting spars to bulkheads
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[side_curves(1) bulk_1_inner_1(1) bulk_1_inner_1(2) spar_curves(1)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[side_curves(2) bulk_mid_inner_1(1) bulk_mid_inner_1(2) spar_curves(2)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[side_curves(3) bulk_2_inner_1(1) bulk_2_inner_1(2) spar_curves(3)]);jk=jk+2;
spars_to_bulks=[surfid(end-2) surfid(end-1) surfid(end)];
%% Create extended skins
% Generate skin curves between front-middle middle-rear spars (Upper and
% lower)
% Front to Middle
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,1,spar_points(1),spar_points(3));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,2,spar_points(2),spar_points(4));jk=jk+2;
curves_fs_ms=[curveidn(end-1) curveidn(end)];
% Middle to Rear
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,1,spar_points(3),spar_points(5));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,2,spar_points(4),spar_points(6));jk=jk+2;
curves_ms_rs=[curveidn(end-1) curveidn(end)];
% Glide the curves to generate surfaces between fuselage skins and wing
% skins- Store surface ID's
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surfglide2curves(surfid,bulkintercurves1(1),bulkintercurvesmid(1),curves_fs_ms(1));jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surfglide2curves(surfid,bulkintercurves1(2),bulkintercurvesmid(2),curves_fs_ms(2));jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surfglide2curves(surfid,bulkintercurvesmid(1),bulkintercurves2(1),curves_ms_rs(1));jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surfglide2curves(surfid,bulkintercurvesmid(2),bulkintercurves2(2),curves_ms_rs(2));jk=jk+2;
ext_skins_1=[surfid(end-3) surfid(end-2) surfid(end-1) surfid(end)];
% Intersect big surfs to generate skin curves
for ik=1:4
    if ik<=2
[pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curveintersurf2surf(pointidn,curveidn,skin_surfs(1),ext_skins_1(ik),0);jk=jk+2;
    else
[pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curveintersurf2surf(pointidn,curveidn,skin_surfs(2),ext_skins_1(ik),0);jk=jk+2;   
    end
end
ext_curves_1=[curveidn(end-3) curveidn(end-2) curveidn(end-1) curveidn(end)];
% Extract skin curves at the symmetry plane
for ik=1:4
[pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromedge(pointidn,curveidn,ext_skins_1(ik),0,1,4);jk=jk+2;
end
ext_curves_2=[curveidn(end-3) curveidn(end-2) curveidn(end-1) curveidn(end)];
% Create extended skin surfaces - Wing to fuselage (Inner--> Outer --> Upper --> Lower --> FS-MS-RS --> 8 surfaces)
% First set 
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[ext_curves_1(1) curves_fs_ms(1) bulk_1_inner_1(1) bulk_mid_inner_1(1)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[ext_curves_1(1) ext_curves_2(1) bulk_1_inner_2(1) bulk_mid_inner_2(1)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[ext_curves_1(2) curves_fs_ms(2) bulk_1_inner_1(2) bulk_mid_inner_1(2)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[ext_curves_1(2) ext_curves_2(2) bulk_1_inner_2(2) bulk_mid_inner_2(2)]);jk=jk+2;
% Second set
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[ext_curves_1(3) curves_ms_rs(1) bulk_2_inner_1(1) bulk_mid_inner_1(1)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[ext_curves_1(3) ext_curves_2(3) bulk_2_inner_2(1) bulk_mid_inner_2(1)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[ext_curves_1(4) curves_ms_rs(2) bulk_2_inner_1(2) bulk_mid_inner_1(2)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[ext_curves_1(4) ext_curves_2(4) bulk_2_inner_2(2) bulk_mid_inner_2(2)]);jk=jk+2;
ext_skins_surfs_inner=[surfid(end-7) surfid(end-5) surfid(end-3)  surfid(end-1)];
ext_skins_surfs_outer=[surfid(end-6) surfid(end-4) surfid(end-2)  surfid(end)];
%% Associations
% Interconnection points (two per spar) to side skin surfs)
% FS
for num_sides=1:length(sidesurfs)
    for ikk=1:2
        [data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(bulkpointsinter1(ikk),sidesurfs(num_sides,1));jk=jk+2;
    end
end
% RS
for num_sides=1:length(sidesurfs)
    for ikk=1:2
        [data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(bulkpointsinter2(ikk),sidesurfs(num_sides,2));jk=jk+2;
    end
end
% MS (to bulkhead surface)
 for ikk=1:2
        [data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(bulkpointsinter2(ikk),bulk_surfs(2));jk=jk+2;
 end
 % Spar internal curves to spar surfaces (Upper-->Lower --> FS --> MS -->RS)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(bulk_1_inner_2(1),bulk_surfs(1));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(bulk_1_inner_2(2),bulk_surfs(1));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(bulk_mid_inner_2(1),bulk_surfs(2));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(bulk_mid_inner_2(2),bulk_surfs(2));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(bulk_2_inner_2(1),bulk_surfs(3));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(bulk_2_inner_2(2),bulk_surfs(3));jk=jk+2;
% Fuselage curves (Extended skins to fuselage skin surfaces) 
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(ext_curves_1(1),skin_surfs(1));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(ext_curves_1(2),skin_surfs(1));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(ext_curves_1(3),skin_surfs(2));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(ext_curves_1(4),skin_surfs(2));jk=jk+2;
% Associate upper fuselage skin points to lower skin surfaces (x2)
for num_points=1:length(framepointsmid_intermediate)
    for num_surf=1:2
        [data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(framepointsmid_intermediate(num_points),skin_surfs(num_surf));jk=jk+2;
    end
end
% Associate stringer points to skin interconnection surfaces
lx = length(str_points);
half = ceil(lx/2); 
str_p_left = str_points(1:half-1);
str_p_right = str_points(half + 2:length(str_points));
ext_skins_surfs_inner_upper=ext_skins_surfs_inner(1:2);
ext_skins_surfs_inner_lower=ext_skins_surfs_inner(3:end);
% Left to middle spar stringer points
for num_points=1:length(str_p_left)
    if mod(str_p_left(num_points),2)==1 % Upper
        [data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(str_p_left(num_points),ext_skins_surfs_inner_upper(1));jk=jk+2;
    else % Lower
        [data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(str_p_left(num_points),ext_skins_surfs_inner_upper(2));jk=jk+2;
    end
end
% Right to middle spar stringer points
for num_points=1:length(str_p_right)
    if mod(str_p_right(num_points),2)==1 % Upper
        [data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(str_p_right(num_points),ext_skins_surfs_inner_lower(1));jk=jk+2;
    else % Lower
        [data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(str_p_right(num_points),ext_skins_surfs_inner_lower(2));jk=jk+2;
    end
end
% Floor to bulkhead curves
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(bulk_upper_curves(1),floor2(frames_sec1+1));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(bulk_upper_curves(2),floor2(frames_sec1+frames_sec2_1+1));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(bulk_upper_curves(3),floor2(frames_sec1+frames_sec2+1));jk=jk+2;
interc_curves=[ext_curves_1 curves_fs_ms curves_ms_rs];
% Store geometric entities
surfs.fuse_barrel.sidesurfs=sidesurfs;
surfs.fuse_barrel.bulksurfs=bulk_surfs;
surfs.fuse_barrel.spars_to_bulks=spars_to_bulks;
surfs.fuse_barrel.skin_surfs=skin_surfs;
surfs.fuse_barrel.interc_skins=ext_skins_surfs_inner;
surfs.fuse_barrel.ext_skins_surfs_outer=ext_skins_surfs_outer;
