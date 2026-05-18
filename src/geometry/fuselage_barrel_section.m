function [data_ses,pointidn,curveidn,coordid,planeid,surfsfuse1,maxsurfid,boundaryp4,boundaryc4,boundaryvec4,bulkhead_c1,side_curves,interc_curves,surfs,curves]=fuselage_barrel_section(x,data_ses,maxsurfid,spar_points,spar_curves,str_points,pointid,curveid,surfsfuse,dstringers,boundaryp1,boundaryc1,boundaryvec1,surfid_fus,surfs,curves)
%% Geometrical parameters
coordid=1;
planeid=[];
rootchord=10.98357; 
distle2surf1=5.0514736;
distte2surf3=8.7546463;
sparloc1=[0.2 0.7];
dx2=24.789373; %Length 
dframe1=x(1); %dstringers should be the same to ensure continuity
%%3 new sections emerge, need frame spacing for each
dx_sec1=distle2surf1+sparloc1(1)*rootchord;
dx_sec2=0.5*rootchord*(sparloc1(2)-sparloc1(1));
dx_sec3=distte2surf3+(1-sparloc1(2))*rootchord;
frames_sec1=round(dx_sec1/dframe1);
% First section
dframes1=(0:1/frames_sec1:1)*(dx_sec1/dx2);
% Second section - Split into two halves
frames_sec2_1=round(dx_sec2/dframe1);
frames_sec2=2*frames_sec2_1;
dframes2_1=dframes1(end)+(0:1/frames_sec2_1:1)*(dx_sec2/dx2);
dframes2_2=dframes2_1(end)+(0:1/frames_sec2_1:1)*(dx_sec2/dx2);
dframes2=[dframes2_1 dframes2_2(2:end)];
% Third section
frames_sec3=round(dx_sec3/dframe1);
dframes3=dframes2(end)+(0:1/frames_sec3:1)*(dx_sec3/dx2);
% Organize dframes
dframes=[0 1 dframes1(2:end) dframes2(2:end) dframes3(2:end-1)];
midindex=frames_sec1+frames_sec2/2+1;
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
surfid=maxsurfid+length(surfid_fus)-1;
surfini=maxsurfid+length(surfid_fus)-1;
framewidth=0.2;
vectorfloor=[0 0 -0.1];
dirframes=2;
framepoints=[];
%% Create axial midline curve
numstringers=2*(length(dstringers)+2);
midpointboundary=boundaryp1((numstringers/2));
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurvesurf(pointid,surfini,midpointboundary);jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,midpointboundary,pointidn(end));jk=jk+2;
pointidn=pointidn(end);
curveidn=curveidn(end);
axialfirstc=curveidn(end);
outerpoints=[midpointboundary pointidn(end)];
%% Extract outer edges
boundaryp5=boundaryp1(1:numstringers-1);
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
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surfglide2curves(surfid,outeredge1,axialfirstc,orbcurveouter(1));jk=jk+2;
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surfglide2curves(surfid,outeredge2,axialfirstc,orbcurveouter(2));jk=jk+2;
surf2=[surfid(end-1) surfid(end)];
dstringersext=[0 dstringers 1];
dframesext=[dframes(1) dframes(3:end) dframes(2)];
%% Lower surfaces
for ik=1:length(dframesext)
    for kk=1:length(dstringersext)
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pextractsurf(pointidn,surf2(1),dstringersext(kk),dframesext(ik));jk=jk+2;
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
%% Upper surfaces
dstringersextu=flip(dstringersext);
for ik=1:length(dframesext)
    for kk=1:length(dstringersextu)
        if kk==1
        upperpoints(kk,ik)=lowpoints(end,ik);
        else
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pextractsurf(pointidn,surf2(2),dstringersextu(kk),dframesext(ik));jk=jk+2;
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
framepointsmid=lowpoints(end,:);
framepointsupper=upperpoints(end,:);
% Surfaces
for ik=1:size(curvesradu,2)
   for ikk=1:size(curvesorbu,1)
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[curvesorbu(ikk,ik) curvesorbu(ikk,ik+1) curvesradu(ikk,ik) curvesradu(ikk+1,ik)]);jk=jk+3;
surfsfupp(ikk,ik)=surfid(end);
   end
end
surfsfinal=[surfsflow ;surfsfupp];
%% Create frame surfaces by extrusion (Attention to normal direction)
% Merge orbital curves
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
%% Store FS, MS and RS lower orbital curves, needed for bulkhead surfaces construction
bulkhead_c1=[orbcurvl(frames_sec1+1) orbcurvl(midindex) orbcurvl(frames_sec1+frames_sec2+1)];
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
for ik=3:length(orbcurvtot)
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
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.005);jk=jk+3;
framesurfsf=framesurfs1;
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
% Create lines between points 
frameupperpointsf=unique(frameupperpoints);
frameupperpointsl1=reshape(frameupperpointsf',[3 length(dframes)-1]);
% Reorder to match PATRAN    
totupperfpl=[frameupperpointsl1(1,:) ;brokpframesl ;frameupperpointsl1(2,:) ;brokpframesu ;frameupperpointsl1(3,:)];
totlowerfpl1=[lowpoints(1:end-1,:);upperpoints];
totlowerfpl=totlowerfpl1(:,2:end);
% Main loop 
for ik=1:size(totlowerfpl,2)
    for ikk=1:size(totlowerfpl,1)
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,totlowerfpl(ikk,ik),totupperfpl(ikk,ik));jk=jk+2;
intercurves(ikk,ik)=curveidn(end);
    end
end
% Create frame intermediate surfaces
brokenframeuppctot=[brokenframeuppcl';brokenframeuppcu'];
totorb=[curvesorbl;curvesorbu];
totorbnew=totorb(:,2:end);
for ik=1:size(brokenframeuppctot,2)
   for ikk=1:size(intercurves,1)-1
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[brokenframeuppctot(ikk,ik) totorbnew(ikk,ik) intercurves(ikk,ik) intercurves(ikk+1,ik)]);jk=jk+3;
intersurfs(ikk,ik)=surfid(end);
   end
end
%% Create floor surfaces
% Create small surfaces first (Lines,Surfs)
framemidupperpoints=[boundaryp1(end-1) frameupperpointsl1(2,:)];
for ik=1:length(framemidupperpoints)-1
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framemidupperpoints(ik),framemidupperpoints(ik+1));jk=jk+2;
midupperframec(ik)=curveidn(end);
end
midinnercurves1=[boundaryc1(end-1) intercurves(((size(intercurves,1)+1)/2),:)];
totrad=[curvesradl(1:end-1,:);curvesradu];
midinnercurves2=totrad(((size(totrad,1)+1)/2),:);
for ik=1:length(midupperframec)
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[midinnercurves1(ik) midinnercurves1(ik+1) midinnercurves2(ik) midupperframec(ik)]);jk=jk+3;
floor1(ik)=surfid(end);
end
% Curves (Left boundary curve exists)
% Create local cs
[coordid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_coordeuler(coordid,boundaryp1(end));jk=jk+2;
% Create vector and plane with cs
vecid=boundaryvec1;
[vecid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_vec2p(vecid,boundaryp1(end-1),boundaryp1(end));jk=jk+2;
axis1=2;
[planeid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_planepoints(planeid,coordid(end),boundaryp1(end),axis1);jk=jk+2;
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,totlowerfpl(1,end),totlowerfpl(end,end));jk=jk+2;
boundarycurve=curveidn(end);
% Project floor1 curves to this plane up to last before end
identpr=1;
for ik=1:length(midinnercurves2)-1
[pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curveprojectplane(pointidn,curveidn,vecid(end),planeid(end),midinnercurves2(ik),identpr);jk=jk+2;
floorinnerc(ik)=curveidn(end);
floorouterp(ik)=pointidn(end);
end
% Project last point onto boundary curve
[pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointidn,boundarycurve,floorouterp(end));jk=jk+2;
outerfloorpext=[boundaryp1(end) pointidn(end)];
% Create last curve also
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,floorouterp(end),outerfloorpext(2));jk=jk+2;
floorinnerc(end+1)=curveidn(end);
floorouterp=[outerfloorpext(1) floorouterp outerfloorpext(2)];
% Create lines for floor surfaces
for ik=2:length(framemidupperpoints)
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,framemidupperpoints(ik),floorouterp(ik));jk=jk+2;
floorouterc(ik)=curveidn(end);   
end
floorouterc(1)=boundaryc1(end);
% Create outer floor surfaces
for ik=1:length(floorinnerc)
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[floorinnerc(ik) floorouterc(ik+1) floorouterc(ik) midupperframec(ik)]);jk=jk+3;
floor2(ik)=surfid(end);
end
% Extrude outer floor curves to create surfaces
framelowsurfs=framesurfsf(1:2:end);assocpoints=[];intercupperp=[];
for ik=2:length(floorouterc)
    % Extract upper curve of lower frame surfaces
    [pointidn,curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromedge(pointidn,curveidn,framelowsurfs(ik-1),0,1,2);jk=jk+2;
    % Create point offset 
    [pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pointoffset(pointidn,abs(vectorfloor(3)),frameupperpointsl1(1,ik-1),frameupperpointsl1(2,ik-1),curveidn(end));jk=jk+2;
     assocpoints=[assocpoints pointidn(end)];
    %Create vector with two points
    [vecid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_vec2p(vecid,frameupperpointsl1(2,ik-1),pointidn(end));jk=jk+2;
    %Extrude curve along vector 
    [surfid,pointidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surfextrudecurvevector(surfid,pointidn,floorouterc(ik),vecid(end),frameupperpointsl1(2,ik-1));jk=jk+2;
    floor3(ik-1)=surfid(end);
    if ik==frames_sec1+1 || ik==midindex || ik==frames_sec1+frames_sec2+1
    intercupperp=[intercupperp pointidn(end)];
    end
end
%% Create floor curves for bulkheads
% Front Bulkhead
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,lowpoints(end,frames_sec1+1),floorouterp(frames_sec1+1));jk=jk+2;
% Middle Bulkhead
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,lowpoints(end,midindex),floorouterp(midindex));jk=jk+2;
% Rear Bulkhead
[curveidn,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveidn,lowpoints(end,frames_sec1+frames_sec2+1),floorouterp(frames_sec1+frames_sec2+1));jk=jk+2;
bulk_upper_curves=[curveidn(end-2) curveidn(end-1) curveidn(end)];
%% Association
midfloorsurfs=intersurfs(size(intersurfs,1)/2:size(intersurfs,1)/2+3,:);
for ik=1:length(floor3)
    for kk=1:size(midfloorsurfs,1)
[data_ses{1}{jk},data_ses{1}{jk+1}]=associate_p2surf(assocpoints(ik),midfloorsurfs(kk,ik));jk=jk+2;
    end
end
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.005);jk=jk+3;
bottom_points_outer=[floorouterp(frames_sec1+1) floorouterp(frames_sec1+1+frames_sec2_1) floorouterp(frames_sec1+frames_sec2+1)];
%% Create bulkheads and rest of surfaces
[data_ses,surfid,curveidn,pointidn,surfsfinal2,intersurfs2,bulkhead_c1,side_curves,interc_curves,surfs,curves]=fuselage_bulkheads(data_ses,frames_sec1,frames_sec2,frames_sec2_1,surfid,curveidn,pointidn,framepointslower,framepointsupper,framepointsmid,spar_points,spar_curves,intersurfs,surfsfinal,bulkhead_c1,bulk_upper_curves,bottom_points_outer,str_points,floor2,surfs,curves);
%% Output points at common boundary shared with congruent surface
boundaryp4=[totlowerfpl(:,end) ; framemidupperpoints(end) ; floorouterp(end)];
boundaryc4=[ totorb(:,end); midinnercurves1(end) ;floorouterc(end)];
boundaryvec4=vecid(end)+1;
maxsurfid=surfid(end);
% Remove bulkhead surfs for skins and stringers
surfs.fuse_barrel.skins=surfsfinal2';
surfs.fuse_barrel.stiffeners=intersurfs2';
% Exclude floor surfaces in contact with the bulkead upper surfaces
floor3_1=setdiff(floor3,floor3(frames_sec1));
floor3_2=setdiff(floor3_1,floor3(midindex-1));
floor3_3=setdiff(floor3_2,floor3(frames_sec1+frames_sec2));
surfs.fuse_barrel.floor=floor3_3;
surfs.fuse_barrel.floor=[floor1 floor2 floor3_3];
strrowhalf=size(intersurfs,1)/2;
delrads1=totrad(1:strrowhalf,frames_sec1+1:frames_sec1+frames_sec2);
delrads=reshape(delrads1,[1 size(delrads1,1)*size(delrads1,2)]); 
curves.fuse_barrel.stringers=setdiff(totrad,delrads)';