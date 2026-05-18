function [data_ses,side_curves_outer,surfs,curves,surfidstail]=fuselage_outer_section_2(x,data_ses,maxsurfid,pointid,curveid,planeid,coordid,surfsfuse,boundaryp2,boundaryc2,surfs,curves)
%% Geometrical parameters
dxtot=10.948498;
dxle=2.8667259;
fsloc=0.2;
rsloc=0.7;
% Tail root chord
rootc=5.2839966; 
%% Renumber remaining surface ids so that current surface has the maximum ID
count=0;
jk=length(data_ses{1})+1;
surfsfuse1=[];
for ik=1:length(surfsfuse)  %Last surface should take current surface ID
count=count+1;
[data_ses{1}{jk},data_ses{1}{jk+1}]=renumber_surf(maxsurfid+count,surfsfuse(ik));jk=jk+2;
if ik<length(surfsfuse)
surfsfuse1=[surfsfuse1 maxsurfid+count];
end
end
surfid_tail=surfsfuse1;
surfini=maxsurfid+length(surfsfuse1)+1;
%% Create tail surfaces
[data_ses,pointid,curveid,planeid,coordid,maxsurfid,spar_points,spar_curves,str_points,rootcurves,surfs,curves,surfidstail]=tail(x,data_ses,surfid_tail,pointid,curveid,planeid,coordid,surfs,curves);
jk=length(data_ses{1})+1;
surfid=maxsurfid+1;
%% Create rest of surfaces for fuselage outer section 2
% Upper and lower surface points
lowpoint1=(dxle+fsloc*rootc)/dxtot;
lowpoint2=(dxle+rsloc*rootc)/dxtot;
%Extract points from relevant curves
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurvesurf(pointid,surfini,lowpoint1,4);jk=jk+2;
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurvesurf(pointid,surfini,lowpoint1,2);jk=jk+2;
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurvesurf(pointid,surfini,lowpoint2,4);jk=jk+2;
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurvesurf(pointid,surfini,lowpoint2,2);jk=jk+2;
bulkouterp=[pointid(end-3) pointid(end-2) pointid(end-1) pointid(end)];
% Create curves
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterp(1),bulkouterp(2));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterp(3),bulkouterp(4));jk=jk+2;
% Project spar points on these curves
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointid,curveid(end-1),spar_points(1));jk=jk+2;
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointid,curveid(end-1),spar_points(2));jk=jk+2;
bulkouterpmid1=[pointid(end-1) pointid(end)];
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointid,curveid(end),spar_points(3));jk=jk+2;
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointid,curveid(end),spar_points(4));jk=jk+2;
bulkouterpmid2=[pointid(end-1) pointid(end)];
% Create outer curves - Bulkhead 1
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterpmid1(1),bulkouterpmid1(2));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterpmid1(1),bulkouterp(2));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterpmid1(2),bulkouterp(1));jk=jk+2;
outerbu1c=[curveid(end) curveid(end-2) curveid(end-1)];
% Create outer curves - Bulkhead 2
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterpmid2(1),bulkouterpmid2(2));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterpmid2(1),bulkouterp(4));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterpmid2(2),bulkouterp(3));jk=jk+2;
outerbu2c=[curveid(end) curveid(end-2) curveid(end-1)];
% Interconnection curves - Bulkhead 1
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterpmid1(1),spar_points(1));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterpmid1(2),spar_points(2));jk=jk+2;
interbu1c=[curveid(end-1) curveid(end)];
% Interconnection curves - Bulkhead 2
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterpmid2(1),spar_points(3));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterpmid2(2),spar_points(4));jk=jk+2;
interbu2c=[curveid(end-1) curveid(end)];
% Manifold curves - Bulkhead 1
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveid,surfini,spar_points(1),bulkouterp(2));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveid,surfini,spar_points(2),bulkouterp(1));jk=jk+2;
manifbu1c=[curveid(end-1) curveid(end)];
% Manifold curves - Bulkhead 2
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveid,surfini,spar_points(3),bulkouterp(4));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveid,surfini,spar_points(4),bulkouterp(3));jk=jk+2;
manifbu2c=[curveid(end-1) curveid(end)];
% Bulkhead surfaces - Bulkhead 1
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf3(surfid,[outerbu1c(3) interbu1c(1) manifbu1c(1)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[interbu1c(2) outerbu1c(2) interbu1c(1) spar_curves(1)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf3(surfid,[outerbu1c(1) interbu1c(2) manifbu1c(2)]);jk=jk+2;
bu1surfs=[surfid(end-2) surfid(end-1) surfid(end)];
% Bulkhead surfaces - Bulkhead 2
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf3(surfid,[outerbu2c(3) interbu2c(1) manifbu2c(1)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[interbu2c(2) outerbu2c(2) interbu2c(1) spar_curves(2)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf3(surfid,[outerbu2c(1) interbu2c(2) manifbu2c(2)]);jk=jk+2;
bu2surfs=[surfid(end-2) surfid(end-1) surfid(end) ];
% Merge bulkhead curves to match neighboring surfaces - Bulkhead 1
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=merge_curveslist_tol(curveid,[manifbu1c(1) manifbu1c(2) spar_curves(1)],0.005);jk=jk+2;
manicb1tot=curveid(end);
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,boundaryp2(1),bulkouterp(1));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,boundaryp2(end-2),bulkouterp(2));jk=jk+2;
sidecurves1=[curveid(end-1) curveid(end)];
[pointid,curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromedge(pointid,curveid,surfini,0,1,1);jk=jk+2;
% Merge bulkhead curves to match neighboring surfaces - Bulkhead 2
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=merge_curveslist_tol(curveid,[manifbu2c(1) manifbu2c(2) spar_curves(2)],0.005);jk=jk+2;
manicb2tot=curveid(end);
[pointid,curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromedge(pointid,curveid,surfini,2,1,3);jk=jk+2;
outerblkp=[pointid(end-1) pointid(end)];
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,pointid(end),bulkouterp(3));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,pointid(end-1),bulkouterp(4));jk=jk+2;
sidecurves2=[curveid(end-1) curveid(end)];
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[manicb2tot curveid(end-1) curveid(end) curveid(end-2)]);jk=jk+2;
% Create last curve and closing bulkhead
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,pointid(end),pointid(end-1));jk=jk+2;
% Mid point in this curve
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurve(pointid,curveid(end),0.5);jk=jk+2;
% Coordinate system
[coordid,data_ses{1}{jk},data_ses{1}{jk}]=create_coordeuler(coordid,pointid(end));jk=jk+1;
% Mid point to bulk point curve for revolve
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,pointid(end),pointid(end-1));jk=jk+2;
% Revolve curve to create closing surface
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surfrevolve(coordid(end),curveid(end),1,180,surfid);jk=jk+2;
% [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf2edge(surfid,[curveid(end-3) curveid(end)]);jk=jk+2;
extcurve=curveid(end-4);
bulksurfs=[bu1surfs bu2surfs surfid(end)];
%% Project neighboring points to bulkhead 1 curve and create manifold curves
pointsbulk1=[];
boundaryp2int=boundaryp2(2:end-3);
bulk1sidecurves=[];
for jkk=1:length(boundaryp2int)
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointid,manicb1tot,boundaryp2int(jkk));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,boundaryp2int(jkk),pointid(end));jk=jk+2;
pointsbulk1=[pointsbulk1 pointid(end)];
bulk1sidecurves=[bulk1sidecurves curveid(end)];
end
%% Break curves and create patch surfaces
ext_curvu=[];side1points=[bulkouterp(1) pointsbulk1 bulkouterp(2)];
for ik=1:length(side1points)-2
    if ik==1
  [curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveid,side1points(ik+1),manicb1tot);jk=jk+2;
  breakcurve=curveid(end-1);
    ext_curvu=[ext_curvu curveid(end)];
    elseif ik>1 && ik<length(side1points)-2
        [curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveid,side1points(ik+1),breakcurve);jk=jk+2;
          breakcurve=curveid(end-1);
     ext_curvu=[ext_curvu curveid(end)];
    else
         [curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveid,side1points(ik+1),breakcurve);jk=jk+2;
     ext_curvu=[ext_curvu curveid(end) curveid(end-1)];
    end
end
%Group axial curves
bulk1sidecurvestot=[sidecurves1(1) bulk1sidecurves sidecurves1(2)];
innersurfs=[];
for ik=1:length(ext_curvu)
 [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[ext_curvu(ik) bulk1sidecurvestot(ik) bulk1sidecurvestot(ik+1) boundaryc2(ik)]);jk=jk+2;
innersurfs=[innersurfs surfid(end)];
end
%% Associate bulkhead orbital points to neighboring surfaces and bulkhead points to patch surfaces
for kk=1:length(pointsbulk1)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(pointsbulk1(kk),bulksurfs(1));jk=jk+2;
end
for kk=1:length(pointsbulk1)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(pointsbulk1(kk),bulksurfs(2));jk=jk+2;
end
for kk=1:length(pointsbulk1)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(pointsbulk1(kk),bulksurfs(3));jk=jk+2;
end
for kk=1:length(innersurfs)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(spar_points(1),innersurfs(kk));jk=jk+2;
end
for kk=1:length(innersurfs)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(spar_points(2),innersurfs(kk));jk=jk+2;
end
%%Same with higher tolerance
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.05);jk=jk+3;
for kk=1:length(pointsbulk1)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(pointsbulk1(kk),bulksurfs(1));jk=jk+2;
end
for kk=1:length(pointsbulk1)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(pointsbulk1(kk),bulksurfs(2));jk=jk+2;
end
for kk=1:length(pointsbulk1)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(pointsbulk1(kk),bulksurfs(3));jk=jk+2;
end
for kk=1:length(innersurfs)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(spar_points(1),innersurfs(kk));jk=jk+2;
end
for kk=1:length(innersurfs)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(spar_points(2),innersurfs(kk));jk=jk+2;
end
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.005);jk=jk+3;
%% Create extended skins
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surfglide2curves(surfid,interbu1c(1),interbu2c(1),rootcurves(1));jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surfglide2curves(surfid,interbu1c(2),interbu2c(2),rootcurves(2));jk=jk+2;
ext_surfs=[surfid(end-1) surfid(end)];
%% Create last surfaces
%Outer curves
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterp(2),bulkouterp(4));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,bulkouterp(1),bulkouterp(3));jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[curveid(end-1) manifbu1c(1) rootcurves(1) manifbu2c(1)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[curveid(end) manifbu1c(2) rootcurves(2) manifbu2c(2)]);jk=jk+2;
skin_surfs_1=[surfid(end-1) surfid(end)];
%Break outer surface & closing bulkhead with RS points
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointid,extcurve,spar_points(3));jk=jk+2;
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointid,extcurve,spar_points(4));jk=jk+2;
outerbulkp=[pointid(end-1) pointid(end)];
%%Manifold curves - surf 
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveid,surfini,spar_points(3),outerbulkp(1));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveid,surfini,spar_points(4),outerbulkp(2));jk=jk+2;
innerbulkcurves=[curveid(end-1) curveid(end)];
%%Manifold curves - on bulkhead 
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveid,surfini,outerblkp(1),outerbulkp(1));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveid,surfini,outerbulkp(1),outerbulkp(2));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveid,surfini,outerblkp(2),outerbulkp(2));jk=jk+2;
outerbulkcurves=[curveid(end-2) curveid(end-1) curveid(end)];
%%Create surfaces
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[manifbu2c(1) outerbulkcurves(1) innerbulkcurves(1) sidecurves2(2)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[innerbulkcurves(1) innerbulkcurves(2) outerbulkcurves(2) spar_curves(2)]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[manifbu2c(2) outerbulkcurves(3) innerbulkcurves(2) sidecurves2(1)]);jk=jk+2;
bulkside2=[surfid(end-2) surfid(end-1) surfid(end)];
% Break last surfs
% [surfid,pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_surface1p(surfid,pointid,outerbulkp(1),bulksurfs(end),delcheck,1);jk=jk+2;
% [surfid,pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_surface1p(surfid,pointid,outerbulkp(2),surfid(end),delcheck,1);jk=jk+2;
% bulksurf_last=[surfid(end-2) surfid(end-1) surfid(end)];
% bulksurfs=[bulksurfs(1:end-1)];
% Create floor surface
% Find mid point
pointsbulk1mid=pointsbulk1(ceil(end/2));
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointid,outerbu1c(1),pointsbulk1mid);jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,pointid(end),boundaryp2(end));jk=jk+2;
floorc1=curveid(end);
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,pointid(end),pointsbulk1mid);jk=jk+2;
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pointoffset(pointid,0.2,pointid(end),pointsbulk1mid,curveid(end));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,pointid(end),boundaryp2(end-1));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,pointid(end-1),pointid(end));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,pointid(end),pointsbulk1mid);jk=jk+2;
% Two floor surfaces
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[curveid(end-1) floorc1 curveid(end-2)  boundaryc2(end) ]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[bulk1sidecurves(ceil(end/2)) curveid(end)  boundaryc2(end-1)   curveid(end-2) ]);jk=jk+2;
% Associate curves to low bulkhead surf
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(curveid(end-1),bulksurfs(3));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(curveid(end),bulksurfs(3));jk=jk+2;
% Associate stringer points to external surfaces
for num_str=1:length(str_points) 
    if mod(num_str,2)==1 % Upper
    [data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(str_points(num_str),ext_surfs(1));jk=jk+2;
    else % Lower
    [data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(str_points(num_str),ext_surfs(2));jk=jk+2;
    end
end
%% Associate two points and two curves to last bulkhead surface
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(outerbulkp(1),bulksurfs(end));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(outerbulkp(2),bulksurfs(end));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(outerbulkcurves(1),bulksurfs(end));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(outerbulkcurves(2),bulksurfs(end));jk=jk+2;
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_curve2surfc(outerbulkcurves(3),bulksurfs(end));jk=jk+2;
%% Output surfaces and curves
surfs.fuse_outer_section_2.outer_section=[bulksurfs bulkside2];
surfs.fuse_outer_section_2.bulkheads=bulksurfs;
surfs.fuse_outer_section_2.skins=innersurfs;
surfs.fuse_outer_section_2.skin_surfs_blk=skin_surfs_1;
surfs.fuse_outer_section_2.floor=[surfid(end-1) surfid(end)];
surfs.fuse_outer_section_2.ext_skins=ext_surfs;
curves.fuse_outer_section_2.stringers=bulk1sidecurvestot;
side_curves_outer=[manifbu1c(1) spar_curves(1) manifbu1c(2) manifbu2c(1) spar_curves(2) manifbu2c(2)];