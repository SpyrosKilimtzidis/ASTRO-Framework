function [data_ses,pointidn,curveidn,planeid,coordid,surfsfuse1,maxsurfid,boundaryp4,boundaryc4,surfs,curves]=fuselage_outer_section_1(x,data_ses,maxsurfid,pointid,curveid,surfsfuse,dstringers,boundaryp2,boundaryc2,boundaryvec2,coordid,planeid,surfs,curves)
%% Geometrical parameters
dx1=10.719434;   % Axial Length 
%Frame and stringer spacing 
dframe1=x(1);
% Number of frames based on length
numframes=round(dx1/dframe1);
% Normalize values to get dframes and dstringers
dframes1=0:1/numframes:1;dframes=[0 1 dframes1(2:end-1)];
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
surfid=maxsurfid+length(surfsfuse1)+1;
surfini=maxsurfid+length(surfsfuse1)+1;
framewidth=0.2;
vectorfloor=[0 0 -0.1];
dirframes=2;
framesurfsu=[];
framesurfsl=[];
framepoints=[];
%% Create axial midline curve
numstringers=2*(length(dstringers)+2);
midpointboundary=boundaryp2((numstringers/2));
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurvesurf(pointid,surfini,midpointboundary);jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveid,surfini,midpointboundary,pointidn(end));jk=jk+2;
pointidn=pointidn(end);
curveidn=curveidn(end);
axialfirstc=curveidn(end);
outerpoints=[midpointboundary pointidn(end)];
%% Extract outer edges
boundaryp5=boundaryp2(1:numstringers-1);
for ik=1:2
    if ik==1
        ident2=0; % No points generated for first section since it exists from previous surfaces
    else
        ident2=2;
    end
[pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromsurf(dframes(ik),dirframes,pointidn,curveidn,surfini,ident2);jk=jk+2;
   if ik==1
    framepoints=[boundaryp5(1) boundaryp5(end)];
   else
    framepoints=[framepoints pointidn(end-1) pointidn(end)];
   end
end
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
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[orbcurveouter(2) axialfirstc orbcurveouter(4) outeredge2]);jk=jk+2;
surf2=[surfid(end-1) surfid(end)];
%% Loop over frame spacing, generating curves and surfaces
orbmidp=[];
ident2=0; %%Three points are generated
for ik=3:length(dframes) %3 because two first have already been processed
[pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromsurfs(dframes(ik),dirframes,pointidn,curveidn,surf2,ident2);jk=jk+2;
if ik==3 
 [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_surface2p(surfid,pointidn(end-2),pointidn(end-1),surf2(1),0);jk=jk+2;
 [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_surface2p(surfid,pointidn(end-1),pointidn(end),surf2(2),0);jk=jk+2;
 surfbreakl=surfid(end-3);surfbreaku=surfid(end-1);
framesurfsl=[framesurfsl surfid(end-2)];framesurfsu=[framesurfsu surfid(end)];
elseif ik>=4 && ik<length(dframes)
 [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_surface2p(surfid,pointidn(end-2),pointidn(end-1),surfbreakl,1);jk=jk+2;
 [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_surface2p(surfid,pointidn(end-1),pointidn(end),surfbreaku,1);jk=jk+2;
  surfbreakl=surfid(end-3);surfbreaku=surfid(end-1);
  framesurfsl=[framesurfsl surfid(end-2)];framesurfsu=[framesurfsu surfid(end)];
elseif ik==length(dframes)
 [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_surface2p(surfid,pointidn(end-2),pointidn(end-1),surfbreakl,1);jk=jk+2;
 [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_surface2p(surfid,pointidn(end-1),pointidn(end),surfbreaku,1);jk=jk+2;
  surfbreakl=surfid(end-3);surfbreaku=surfid(end-1);
  framesurfsl=[framesurfsl surfid(end-2) surfid(end-3)];framesurfsu=[framesurfsu surfid(end) surfid(end-1)];
end
 framepoints=[framepoints pointidn(end-2) pointidn(end)];
 orbmidp=[orbmidp pointidn(end-1)];
end
% Reorder framepoints and brake into upper and lower
framepointsn=[framepoints(1:2) framepoints(5:end) framepoints(3:4)];
framepointslower=framepointsn(1:2:end);
framepointsupper=framepointsn(2:2:end);
%% Delete additional surfaces (Keep Surface 1 - Will be used for the generation of stringer lines)
framesurfs=[framesurfsu framesurfsl];
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=delete_surfs(surfid,framesurfs);jk=jk+2;
[~,b1]=ismember(outeredge1,curveidn);
[~,b2]=ismember(outeredge2,curveidn);
orbcurv=[curveidn(2:b1-1) curveidn(b2+1:end)] ;
orbcurv=[orbcurv(1:2) orbcurv(5:end) orbcurv(3:4)];
orbcurv3u=[orbcurv(4:2:end-1)];orbcurv3l=[orbcurv(3:2:end-2)]; %% We dont need outer ones since points exist there, thats why the counter
radcurves=[];
extpoints=[];
for kk=1:length(surf2)
    if kk==1
boundarp3=boundaryp5(2:((length(boundaryp5)-1)/2));
projcurve=orbcurv(end-1);
    else
boundarp3=boundaryp5(length(boundaryp5)-1:-1:(length(boundaryp5)-1)/2+2);
projcurve=orbcurv(end);
    end
 for ik=1:length(dstringers)
     % Project and manifold
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointidn,projcurve,boundarp3(ik));jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_manifoldcurve(curveidn,surf2(kk),boundarp3(ik),pointidn(end));jk=jk+2;
radcurves=[radcurves curveidn(end)];
extpoints=[extpoints boundarp3(ik) pointidn(end)];
 end
end
radcurvesu=radcurves(length(radcurves)/2+1:end);
radcurvesl=radcurves(1:length(radcurves)/2);
%% Create frame surfaces by extrusion (Attention to normal direction)
framesurfs1=[];
frameupperpoints=[];
normdir=1;
for ik=3:length(orbcurv)
    if mod(ik,2)==1   %% Remove one point since they have a common edge
        ident=1;
        [data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.005);jk=jk+3;
  [surfid,pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extrude_surfnormal(surfid,pointidn,framewidth,orbcurv(ik),normdir,ident);jk=jk+2;
    else
        ident=0;
        [data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.05);jk=jk+3;
  [surfid,pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extrude_surfnormal(surfid,pointidn,framewidth,orbcurv(ik),normdir,ident);jk=jk+2;
    end
  framesurfs1=[framesurfs1 surfid(end)];
  frameupperpoints=[frameupperpoints pointidn(end-1) pointidn(end)];
end
% Reorder framesurfs to match PATRAN
framesurfsf=framesurfs1;
%% Double loop to find intersection points between axial and orbital lines (Upper and lower curves)
%%Lower part
for ik=1:length(radcurvesl)
    for ikk=1:length(orbcurv3l)
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pintersectcurves_dupl(pointidn,radcurvesl(ik),orbcurv3l(ikk));jk=jk+2;
lowerpoints(ik,ikk)=pointidn(end);
    end
end
%%Upper part
for ik=1:length(radcurvesu)
    for ikk=1:length(orbcurv3u)
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pintersectcurves_dupl(pointidn,radcurvesu(ik),orbcurv3u(ikk));jk=jk+2;
upperpoints(ik,ikk)=pointidn(end);
    end
end
%%Break curves with newly generated points - Lower part
for ik=1:length(radcurvesl)
    for ikk=1:size(lowerpoints,2)
        if ikk==1
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,lowerpoints(ik,ikk),radcurvesl(ik));jk=jk+2;
        else
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,lowerpoints(ik,ikk),curveidn(end));jk=jk+2;
        end     
        if ikk<size(lowerpoints,2)
    lowercurves(ik,ikk)=curveidn(end-1);
        else
    lowercurves(ik,ikk)=curveidn(end-1);
    lowercurves(ik,ikk+1)=curveidn(end); 
        end
    end
end
%%Break curves with newly generated points - Upper part
for ik=1:length(radcurvesu)
    for ikk=1:size(lowerpoints,2)
        if ikk==1
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,upperpoints(ik,ikk),radcurvesu(ik));jk=jk+2;
        else
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,upperpoints(ik,ikk),curveidn(end));jk=jk+2;
        end     
        if ikk<size(lowerpoints,2)
    uppercurves(ik,ikk)=curveidn(end-1);
        else
    uppercurves(ik,ikk)=curveidn(end-1);
    uppercurves(ik,ikk+1)=curveidn(end); 
        end
    end
end
%%Break middle and outer edges 
orbmidpn=[outerpoints(1) orbmidp outerpoints(2)];
for ik=2:length(orbmidpn)-1 %Outer points not used for breaking
        if ik==2
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,orbmidpn(ik),axialfirstc);jk=jk+2;
        else
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,orbmidpn(ik),curveidn(end));jk=jk+2;
        end     
        if ik<size(upperpoints,2)-1
    midcurves(ik-1)=curveidn(end-1);
        else
    midcurves(ik-1)=curveidn(end-1);
    midcurves(ik)=curveidn(end); 
        end
end
% Outer edges
for ik=2:length(framepointslower)-1
        if ik==2
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,framepointslower(ik),outeredge1);jk=jk+2;
        else
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,framepointslower(ik),curveidn(end));jk=jk+2;
        end     
        if ik<size(upperpoints,2)-1
    outercurves1(ik-1)=curveidn(end-1);
        else
    outercurves1(ik-1)=curveidn(end-1);
    outercurves1(ik)=curveidn(end); 
        end
end
for ik=2:length(framepointsupper)-1
        if ik==2
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,framepointsupper(ik),outeredge2);jk=jk+2;
        else
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,framepointsupper(ik),curveidn(end));jk=jk+2;
        end     
        if ik<size(upperpoints,2)-1
    outercurves2(ik-1)=curveidn(end-1);
        else
    outercurves2(ik-1)=curveidn(end-1);
    outercurves2(ik)=curveidn(end); 
        end
end
%% Break frame curves after grouping points
totplower=[extpoints(1:2:length(extpoints)/2)' lowerpoints extpoints(2:2:length(extpoints)/2)'];
totpupper=[extpoints(length(extpoints)/2+1:2:length(extpoints))' upperpoints extpoints(length(extpoints)/2+2:2:length(extpoints))'];
totpupper1=flip(totpupper);
%%Break frame curves with newly generated points - Lower part
orbcurv2l=orbcurv(1:2:end);
for ik=2:length(orbcurv2l)
    for ikk=1:size(totplower,1)
        if ikk==1
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,totplower(ikk,ik),orbcurv2l(ik));jk=jk+2;
        else
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,totplower(ikk,ik),curveidn(end));jk=jk+2;
        end     
        if ikk<size(totplower,1)
    lowerorb(ik,ikk)=curveidn(end-1);
        else
    lowerorb(ik,ikk)=curveidn(end-1);
    lowerorb(ik,ikk+1)=curveidn(end); 
        end
    end
end
%%Break frame curves with newly generated points - Upper part
orbcurv2u=orbcurv(2:2:end);
for ik=2:length(orbcurv2u)
    for ikk=1:size(totpupper1,1)
        if ikk==1
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,totpupper1(ikk,ik),orbcurv2u(ik));jk=jk+2;
        else
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,totpupper1(ikk,ik),curveidn(end));jk=jk+2;
        end     
        if ikk<size(totpupper1,1)
    upperorb(ik,ikk)=curveidn(end-1);
        else
    upperorb(ik,ikk)=curveidn(end-1);
    upperorb(ik,ikk+1)=curveidn(end); 
        end
    end
end
%% Introduce left boundary curves
boundaryc5=boundaryc2(1:numstringers-2);
lowerorb(1,:)=boundaryc5(1:((length(boundaryc5))/2));
upperorb(1,:)=boundaryc5(numstringers/2:end);
%% Generate patch surfaces - Lower part 
%Merge upper and lower orbit curves
totorb=[lowerorb upperorb]';
totrad=[outercurves1 ;lowercurves;midcurves;flip(uppercurves);outercurves2];
for ik=1:size(totrad,2)
   for ikk=1:size(totorb,1)
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[totorb(ikk,ik) totorb(ikk,ik+1) totrad(ikk,ik) totrad(ikk+1,ik)]);jk=jk+3;
surfsfinal(ikk,ik)=surfid(end);
   end
end
%% Break frame surfaces  --- (Extract upper curves, points and lines)
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
brokpframes=reshape(brokenframepoints',[2*length(dstringers) length(dframes)-1])';
brokpframesl=brokpframes(:,1:length(dstringers))';
brokpframesu=brokpframes(:,length(dstringers)+1:end)';
frameuppercurvesl=frameuppercurves(1:2:end);frameuppercurvesu=frameuppercurves(2:2:end);
for ik=1:length(frameuppercurvesl)
    for ikk=1:size(brokpframesl,1)
        if ikk==1
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,brokpframesl(ikk,ik),frameuppercurvesl(ik));jk=jk+2;
        else
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,brokpframesl(ikk,ik),curveidn(end));jk=jk+2;
        end     
        if ikk<size(brokpframesl,1)
    brokenframeuppcl(ik,ikk)=curveidn(end-1);
        else
    brokenframeuppcl(ik,ikk)=curveidn(end-1);
    brokenframeuppcl(ik,ikk+1)=curveidn(end); 
        end
    end
end
for ik=1:length(frameuppercurvesu)
    for ikk=1:size(brokpframesu,1)
        if ikk==1
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,brokpframesu(ikk,ik),frameuppercurvesu(ik));jk=jk+2;
        else
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveidn,brokpframesu(ikk,ik),curveidn(end));jk=jk+2;
        end     
        if ikk<size(brokpframesu,1)
    brokenframeuppcu(ik,ikk)=curveidn(end-1);
        else
    brokenframeuppcu(ik,ikk)=curveidn(end-1);
    brokenframeuppcu(ik,ikk+1)=curveidn(end); 
        end
    end
end
%Create lines between points 
frameupperpointsf=unique(frameupperpoints);
frameupperpointsl1=reshape(frameupperpointsf',[3 length(dframes)-1]);
%Reorder to match PATRAN    
totupperfpl=[frameupperpointsl1(1,:) ;brokpframesl ;frameupperpointsl1(2,:) ;brokpframesu ;frameupperpointsl1(3,:)];
totlowerfpl1=[framepointslower ;totplower ;orbmidpn ;flip(totpupper);framepointsupper ];
totlowerfpl=totlowerfpl1(:,2:end);
%%Main loop (KAPPA KEEPO)
for ik=1:size(totlowerfpl,2)
    for ikk=1:size(totlowerfpl,1)
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,totlowerfpl(ikk,ik),totupperfpl(ikk,ik));jk=jk+2;
intercurves(ikk,ik)=curveidn(end);
    end
end
%%Create frame intermediate surfaces
brokenframeuppctot=[brokenframeuppcl';brokenframeuppcu'];
totorbnew=totorb(:,2:end);
for ik=1:size(brokenframeuppctot,2)
   for ikk=1:size(intercurves,1)-1
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[brokenframeuppctot(ikk,ik) totorbnew(ikk,ik) intercurves(ikk,ik) intercurves(ikk+1,ik)]);jk=jk+3;
intersurfs(ikk,ik)=surfid(end);
   end
end
%% Create floor surfaces
%Create small surfaces first (Lines,Surfs)
framemidupperpoints=[boundaryp2(end-1) frameupperpointsl1(2,:)];
for ik=1:length(framemidupperpoints)-1
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framemidupperpoints(ik),framemidupperpoints(ik+1));jk=jk+2;
midupperframec(ik)=curveidn(end);
end
midinnercurves1=[boundaryc2(end-1) intercurves(((size(intercurves,1)+1)/2),:)];
midinnercurves2=totrad(((size(totrad,1)+1)/2),:);
for ik=1:length(midupperframec)
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[midinnercurves1(ik) midinnercurves1(ik+1) midinnercurves2(ik) midupperframec(ik)]);jk=jk+3;
floor1(ik)=surfid(end);
end
% Curves (Left boundary curve exists)
%Create local cs
[coordid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_coordeuler(coordid,boundaryp2(end));jk=jk+2;
%Create vector and plane with cs
vecid=boundaryvec2;
[vecid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_vec2p(vecid,boundaryp2(end-1),boundaryp2(end));jk=jk+2;
axis1=2;
[planeid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_planepoints(planeid,coordid(end),boundaryp2(end),axis1);jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,totlowerfpl(1,end),totlowerfpl(end,end));jk=jk+2;
boundarycurve=curveidn(end);
%Project floor1 curves to this plane up to last before end
identpr=1;
for ik=1:length(midinnercurves2)-1
[pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curveprojectplane(pointidn,curveidn,vecid(end),planeid(end),midinnercurves2(ik),identpr);jk=jk+2;
floorinnerc(ik)=curveidn(end);
floorouterp(ik)=pointidn(end);
end
% Project last point onto boundary curve
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointidn,boundarycurve,floorouterp(end));jk=jk+2;
outerfloorpext=[boundaryp2(end) pointidn(end)];
% Create last curve also
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,floorouterp(end),outerfloorpext(2));jk=jk+2;
floorinnerc(end+1)=curveidn(end);
floorouterp=[outerfloorpext(1) floorouterp outerfloorpext(2)];
%%Create lines for floor surfaces
for ik=2:length(framemidupperpoints)
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framemidupperpoints(ik),floorouterp(ik));jk=jk+2;
floorouterc(ik)=curveidn(end);   
end
floorouterc(1)=boundaryc2(end);
%Create outer floor surfaces
for ik=1:length(floorinnerc)
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[floorinnerc(ik) floorouterc(ik+1) floorouterc(ik) midupperframec(ik)]);jk=jk+3;
floor2(ik)=surfid(end);
end
%%Extrude outer floor curves to create surfaces
framelowsurfs=framesurfsf(1:2:end);assocpoints=[];
for ik=2:length(floorouterc)
    %Extract upper curve of lower frame surfaces
    [pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromedge(pointidn,curveidn,framelowsurfs(ik-1),0,1,2);jk=jk+2;
    % Create point offset 
    [pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pointoffset(pointidn,abs(vectorfloor(3)),frameupperpointsl1(1,ik-1),frameupperpointsl1(2,ik-1),curveidn(end));jk=jk+2;
   assocpoints=[assocpoints pointidn(end)];
    %Create vector with two points
    [vecid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_vec2p(vecid,frameupperpointsl1(2,ik-1),pointidn(end));jk=jk+2;
    %Extrude curve along vector 
    [surfid,pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surfextrudecurvevector(surfid,pointidn,floorouterc(ik),vecid(end),frameupperpointsl1(2,ik-1));jk=jk+2;
    floor3(ik-1)=surfid(end);
end
%% Association
midfloorsurfs=intersurfs(size(intersurfs,1)/2:size(intersurfs,1)/2+3,:);
for ik=1:length(floor3)
    for kk=1:size(midfloorsurfs,1)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(assocpoints(ik),midfloorsurfs(kk,ik));jk=jk+2;
    end
end
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.005);jk=jk+3;
%% Output points at common boundary shared with congruent surface
boundaryp4=[totlowerfpl(:,end) ; framemidupperpoints(end) ; floorouterp(end)];
boundaryc4=[ totorb(:,end); midinnercurves1(end) ;floorouterc(end)];
surfs.fuse_outer_section_1.skins=reshape(surfsfinal,[1 size(surfsfinal,1)*size(surfsfinal,2)]);
surfs.fuse_outer_section_1.stiffeners=reshape(intersurfs,[1 size(intersurfs,1)*size(intersurfs,2)]);
surfs.fuse_outer_section_1.floor=[floor1 floor2 floor3];
totrad2=[outercurves1;lowercurves;midcurves;uppercurves;outercurves2];
curves.fuse_outer_section_1.stringers=reshape(totrad2,[1 size(totrad2,1)*size(totrad2,2)]);
maxsurfid=surfid(end);



















