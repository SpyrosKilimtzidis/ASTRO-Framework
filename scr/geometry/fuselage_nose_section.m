function [data_ses,pointidn,curveidn,surfsfuse,maxsurfid,dstringers,boundaryp,boundaryc,boundaryvec,surfs,curves]=fuselage_nose_section(x,data_ses,surfid_fus,pointid,curveid,maxsurfid,surfs,curves)
%% Geometrical parameters
dx1=13.887518;   % Axial Length 
dz1=5.6959467/2; % Radial Length 
% Frame and stringer spacing 
dframe1=x(1);
dstr1=x(2);
% Number of frames and stringers
numframes=round(dx1/dframe1);
numstringers=round(dz1/dstr1);
% Normalize values to get dframes and dstringers
dframes1=0:1/numframes:1;dframes=[0 1 dframes1(2:end-1)];
dstringers1=0:1/numstringers:1;dstringers=dstringers1(2:end-1);  %% Exclude 0 1 since this value corresponds to the floor in the middle of the geometry
framewidth=0.2;
vectorfloor=[0 0 -0.1];
dirframes=2;
jk=length(data_ses{1})+1;  %% This is the starting point for the file
framepoints=[];
lastcurveid=curveid(end);
lastpointid=pointid(end);
count=0;
surfsfuse=[];
vecid=[];
%% Renumber remaining surface ids so that current surface has the maximum ID
for ik=length(surfid_fus):-1:1  %Last surface should take current surface ID
count=count+1;
[data_ses{1}{jk},data_ses{1}{jk+1}]=renumber_surf(maxsurfid+count,surfid_fus(ik));jk=jk+2;
if ik>1
surfsfuse=[surfsfuse maxsurfid+count];
end
end
surfid=maxsurfid+length(surfid_fus);
surfini=maxsurfid+length(surfid_fus);
%% Create axial midline curve
ident1=2;
[pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromsurf(0.5,1,lastpointid,lastcurveid,surfini,ident1);jk=jk+2;
curveidn(end-1)=[];
pointidn(end-2)=[];
axialfirstc=curveidn(end);
outerpoints=[pointidn(end-1) pointidn(end)];
ident2=2;
for ik=1:2
[pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromsurf(dframes(ik),dirframes,pointidn,curveidn,surfini,ident2);jk=jk+2;
    framepoints=[framepoints pointidn(end-1) pointidn(end)];
end
[data_ses{1}{jk},data_ses{1}{jk+1}]=reverse_curve(curveidn(3));jk=jk+2;
%% Break outer edges 
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,outerpoints(1),curveidn(end-1));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,outerpoints(2),curveidn(2));jk=jk+2;
orbcurveouter=curveidn(2:end);
%% Create surfaces after extracting outer edge curves
% Extract outer edge lines
ident2=0; %% Explained below in floor surface generation
[pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromsurf(0,1,pointidn,curveidn,surfini,ident2);jk=jk+2;
outeredge1=curveidn(end);
[pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromsurf(1,1,pointidn,curveidn,surfini,ident2);jk=jk+2;
outeredge2=curveidn(end);
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[orbcurveouter(1) axialfirstc orbcurveouter(3) outeredge1]);jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[orbcurveouter(2) outeredge2 orbcurveouter(4) axialfirstc]);jk=jk+2;
surf2=[surfid(end-1) surfid(end)];
dstringersext=[0 dstringers 1];
dframesext=[dframes(1) dframes(3:end) dframes(2)];
%% Lower surfs
for ik=1:length(dframesext)
    for kk=1:length(dstringersext)
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pextractsurf(pointidn,surf2(1),dframesext(ik),dstringersext(kk));jk=jk+2;
lowpoints(kk,ik)=pointidn(end);
    if kk>=2 
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,surf2(1),lowpoints(kk-1,ik),lowpoints(kk,ik));jk=jk+2;
curvesorbl(kk-1,ik)=curveidn(end);
    end
    if ik>=2
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,surf2(1),lowpoints(kk,ik-1),lowpoints(kk,ik));jk=jk+2;
curvesradl(kk,ik-1)=curveidn(end);
    end
    end
end
for ik=1:size(curvesradl,2)
   for ikk=1:size(curvesorbl,1)
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[curvesorbl(ikk,ik) curvesorbl(ikk,ik+1) curvesradl(ikk,ik) curvesradl(ikk+1,ik)]);jk=jk+3;
surfsflow(ikk,ik)=surfid(end);
   end
end
%% Upper surfs
dstringersextu=dstringersext;
for ik=1:length(dframesext)
    for kk=1:length(dstringersextu)
        if kk==1
        upperpoints(kk,ik)=lowpoints(end,ik);
        else
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pextractsurf(pointidn,surf2(2),dframesext(ik),dstringersextu(kk));jk=jk+2;
upperpoints(kk,ik)=pointidn(end);
        end
    if kk>=2
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,surf2(2),upperpoints(kk-1,ik),upperpoints(kk,ik));jk=jk+2;
curvesorbu(kk-1,ik)=curveidn(end);
    end
    if ik>=2 && kk==1
    curvesradu(kk,ik-1)=curvesradl(end,ik-1) ;
    elseif ik>=2 &&kk>=2
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,surf2(2),upperpoints(kk,ik-1),upperpoints(kk,ik));jk=jk+2;
curvesradu(kk,ik-1)=curveidn(end);
    end
    end
end
framepointslower=lowpoints(1,:);
framepointsupper=upperpoints(end,:);
%Surfaces
for ik=1:size(curvesradu,2)
   for ikk=1:size(curvesorbu,1)
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[curvesorbu(ikk,ik) curvesorbu(ikk,ik+1) curvesradu(ikk,ik) curvesradu(ikk+1,ik)]);jk=jk+3;
surfsfupp(ikk,ik)=surfid(end);
   end
end
surfsfinal=[surfsflow ;surfsfupp];
%% Create frame surfaces by extrusion (Attention to normal direction)
%Merge orbital curves
orbcurv=[];
for ik=1:size(curvesorbu,2)
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=merge_curveslist(curveidn,curvesorbu(:,ik)');jk=jk+2;
orbcurv=[orbcurv curveidn(end)];
end
for ik=1:size(curvesorbl,2)
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=merge_curveslist(curveidn,curvesorbl(:,ik)');jk=jk+2;
orbcurv=[orbcurv curveidn(end)];
end
orbcurvu=orbcurv(1:length(dframes));
orbcurvl=orbcurv(length(dframes)+1:end);
orbcurvtot=[];count1=1;count2=1;
for jkk=1:2*length(orbcurvu)
    if mod(jkk,2)==1
orbcurvtot=[orbcurvtot orbcurvl(count1)];
count1=count1+1;
    else
orbcurvtot=[orbcurvtot orbcurvu(count2)];
count2=count2+1;
    end
end
frameupperpoints=[];framesurfs1=[];
normdir=1;
for ik=1:length(orbcurvtot)
    if mod(ik,2)==1   %% Remove one point since they have a common edge
        ident=1;
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.005);jk=jk+3;
  [surfid,pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extrude_surfnormal(surfid,pointidn,framewidth,orbcurvtot(ik),normdir,ident);jk=jk+2;
    else
        ident=0;
        [data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.05);jk=jk+3;
  [surfid,pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extrude_surfnormal(surfid,pointidn,framewidth,orbcurvtot(ik),normdir,ident);jk=jk+2;
    end
  framesurfs1=[framesurfs1 surfid(end)];
  frameupperpoints=[frameupperpoints pointidn(end-1) pointidn(end)];
end
% Reorder framesurfs to match PATRAN
frameupperpointsf=unique(frameupperpoints);
frameupperpointsl1=reshape(frameupperpointsf',[3 length(dframes)]);
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.005);jk=jk+3;
[~, i, ~] = unique(frameupperpoints,'first');
indexToDupes = not(ismember(1:numel(frameupperpoints),i));
frameupperpointsmid=frameupperpoints(indexToDupes);
framesurfsf=framesurfs1;
framesurfsupper=framesurfs1(2:2:end);
framesurfslower=framesurfs1(1:2:end);
%% Break frame surfaces  -- (Extract upper curves, points and lines)
ident3=0; % No points generated
frameuppercurves=[];
for ik=1:length(framesurfsf)
    [pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromsurf(1,1,pointidn,curveidn,framesurfsf(ik),ident3);jk=jk+2;
frameuppercurves=[frameuppercurves curveidn(end)];
end
brokenframepoints=[];
for ik=1:length(frameuppercurves)
    for ikk=1:length(dstringers)
        [pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurve(pointidn,frameuppercurves(ik),dstringers(ikk));jk=jk+2;
brokenframepoints(ik,ikk)=[pointidn(end)];
    end
end   
brokpframes=reshape(brokenframepoints',[2*length(dstringers) length(dframes)])';
brokpframesl=brokpframes(:,1:length(dstringers))';
brokpframesu=brokpframes(:,length(dstringers)+1:end)';
brokpframesl1=[frameupperpointsl1(1,:);brokpframesl;frameupperpointsmid];
for kk=1:length(framesurfsupper)
    for ik=1:size(brokpframesl1,1)-1
    [curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,framesurfslower(kk),brokpframesl1(ik,kk),brokpframesl1(ik+1,kk));jk=jk+2;
    brokenframeuppcl(ik,kk)=curveidn(end);
    end
end
brokpframesu1=[frameupperpointsmid;brokpframesu ;frameupperpointsl1(3,:)];
for kk=1:length(framesurfsupper)
    for ik=1:size(brokpframesu1,1)-1
    [curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,framesurfsupper(kk),brokpframesu1(ik,kk),brokpframesu1(ik+1,kk));jk=jk+2;
    brokenframeuppcu(ik,kk)=curveidn(end);
    end
end
totupperfpl=[frameupperpointsl1(1,:) ;brokpframesl ;frameupperpointsl1(2,:) ;brokpframesu ;frameupperpointsl1(3,:)];
totlowerfpl1=[lowpoints(1:end-1,:);upperpoints];
totlowerfpl=totlowerfpl1;
%%Main loop
for ik=1:size(totlowerfpl,2)
    for ikk=1:size(totlowerfpl,1)
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,totlowerfpl(ikk,ik),totupperfpl(ikk,ik));jk=jk+2;
intercurves(ikk,ik)=curveidn(end);
    end
end
%%Create frame intermediate surfaces
brokenframeuppctot=[brokenframeuppcl;brokenframeuppcu];
totorb=[curvesorbl;curvesorbu];
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.05);jk=jk+3;
for ik=1:size(brokenframeuppctot,2)
   for ikk=1:size(intercurves,1)-1
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[brokenframeuppctot(ikk,ik) totorb(ikk,ik) intercurves(ikk,ik) intercurves(ikk+1,ik)]);jk=jk+3;
intersurfs(ikk,ik)=surfid(end);
   end
end
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.005);jk=jk+3;

%% Create floor surfaces
%Create small surfaces first (Lines,Surfs)
totrad=[curvesradl(1:end-1,:);curvesradu];
midinnercurves2=totrad(((size(totrad,1)+1)/2),:);
framemidupperpoints=frameupperpointsl1(2,:);
for ik=1:length(framemidupperpoints)-1
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framemidupperpoints(ik),framemidupperpoints(ik+1));jk=jk+2;
midupperframec(ik)=curveidn(end);
end
midinnercurves1=intercurves(((size(intercurves,1)+1)/2),:);
for ik=1:length(midupperframec)
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[midinnercurves1(ik) midinnercurves1(ik+1) midinnercurves2(ik) midupperframec(ik)]);jk=jk+3;
floor1(ik)=surfid(end);
end
% Curves
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framepoints(1),framepoints(2));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framepoints(3),framepoints(4));jk=jk+2;
% Midpoints
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurve(pointidn,curveidn(end-1),0.5);jk=jk+2;
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurve(pointidn,curveidn(end),0.5);jk=jk+2;
outerfloorpext=[pointidn(end-1) pointidn(end)];
% Curves with midpoints 
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,pointidn(end-1),pointidn(end));jk=jk+2;
%Project points in this curve
for ik=2:length(framemidupperpoints)-1
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointidn,curveidn(end),framemidupperpoints(ik));jk=jk+2;
floorouterp(ik-1)=pointidn(end);
end
floorouterp=[outerfloorpext(1) floorouterp outerfloorpext(2)];
%%Create lines for floor surfaces
for ik=1:length(framemidupperpoints)
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framemidupperpoints(ik),floorouterp(ik));jk=jk+2;
floorouterc(ik)=curveidn(end);   
end
for ik=1:length(floorouterp)-1
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,floorouterp(ik),floorouterp(ik+1));jk=jk+2;
floorinnerc(ik)=curveidn(end);   
end
%Create outer floor surfaces
for ik=1:length(floorinnerc)
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[floorinnerc(ik) floorouterc(ik+1) floorouterc(ik) midupperframec(ik)]);jk=jk+3;
floor2(ik)=surfid(end);
end
%%Extrude outer floor curves to create surfaces
framelowsurfs=framesurfsf(1:2:end);assocpoints=[];
for ik=1:length(floorouterc)
    %Extract upper curve of lower frame surfaces
    [pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromedge(pointidn,curveidn,framelowsurfs(ik),0,1,2);jk=jk+2;
    % Create point offset 
    [pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pointoffset(pointidn,abs(vectorfloor(3)),frameupperpointsl1(1,ik),frameupperpointsl1(2,ik),curveidn(end));jk=jk+2;
    assocpoints=[assocpoints pointidn(end)];
    %Create vector with two points
    [vecid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_vec2p(vecid,frameupperpointsl1(2,ik),pointidn(end));jk=jk+2;
    %Extrude curve along vector 
    [surfid,pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surfextrudecurvevector(surfid,pointidn,floorouterc(ik),vecid(end),frameupperpointsl1(2,ik));jk=jk+2;
    floor3(ik)=surfid(end);
end
%% Association
midfloorsurfs=intersurfs(size(intersurfs,1)/2:size(intersurfs,1)/2+3,:);
for ik=1:length(floor3)
    for kk=1:size(midfloorsurfs,1)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(assocpoints(ik),midfloorsurfs(kk,ik));jk=jk+2;
    end
end
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.05);jk=jk+3;
for ik=1:length(floor3)
    for kk=1:size(midfloorsurfs,1)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(assocpoints(ik),midfloorsurfs(kk,ik));jk=jk+2;
    end
end
maxsurfid=surfid(end);
%% Output points at common boundary shared with congruent surface
boundaryp=[totlowerfpl(:,end) ; framemidupperpoints(end) ; floorouterp(end)];
boundaryc=[ totorb(:,end); midinnercurves1(end) ;floorouterc(end)];
boundaryvec=vecid(end)+1;
surfs.fuse_nose.skins=reshape(surfsfinal,[1 size(surfsfinal,1)*size(surfsfinal,2)]);
surfs.fuse_nose.stiffeners=reshape(intersurfs,[1 size(intersurfs,1)*size(intersurfs,2)]);
surfs.fuse_nose.floor=[floor1 floor2 floor3];
curves.fuse_nose.stringers=reshape(totrad,[1 size(totrad,1)*size(totrad,2)]);