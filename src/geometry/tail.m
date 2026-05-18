function [data_ses,pointid,curveid,planeid,coordid,maxsurfid,spar_points,spar_curves,str_points,rootcurves,surfs,curves,surfidstail]=tail(x,data_ses,surfid_tail,pointid,curveid,planeid,coordid,surfs,curves)
surfid=surfid_tail+1;
span=9.8646412;
%% Geometrical Data
zm=x(6);
d_str=x(7);
vdir1=zm/span;
vtot=0:vdir1:1;
if vtot(end)~=1
vtot(end+1)=1;
end
d1=0.2;
d2=0.7;
strspacing0=round(1/d_str);
strspacing1=linspace(0,1,strspacing0);
strspacing=strspacing1(2:end-1);
dextracut=0.8;                     %% Extra break near TE to avoid bad meshing
%% Loop for each spanwise section, including first and last
nr=1;
jk=length(data_ses{1})+1;  %% This is the starting point for the file
[data_ses{1}{jk},data_ses{1}{jk+1},data_ses{1}{jk+2}]=set_tol(0.005);jk=jk+3;
%% Extract LE curve
data_ses{1}{jk}='STRING sgm_create_curve_ex_created_ids[VIRTUAL]';jk=jk+1;
data_ses{1}{jk}=sprintf('sgm_const_curve_extract_edge( "%d", "Surface %d.2", sgm_create_curve_ex_created_ids )',curveid(end)+1,surfid_tail(2));jk=jk+1;
%% Increment points, curves and surfaces values
lecurve=curveid(end)+1;
curveid=[curveid curveid(end)+1];
pointid=[pointid(end)+1 pointid(end)+2];
identu=1;identl=1;
axis=2;
%% Main loop section
while nr<=length(vtot)
%% Extract upper & lower curves (for the root and tip section extract automatically)
if nr==1
    curpoint=pointid(1);
elseif  nr==length(vtot)
    curpoint=pointid(2);
else
    [pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurve(pointid,lecurve,vtot(nr));jk=jk+2;
    curpoint=pointid(end);
end
if nr==1 % Different method 
    unq=1; % One point
    dist=0;
    direction=2;
[pointid,curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromsurf(dist,direction,pointid,curveid,surfid_tail(3),unq);jk=jk+2;
c1=curveid(end);
[pointid,curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromsurf(dist,direction,pointid,curveid,surfid_tail(2),unq);jk=jk+2;
c2=curveid(end);
lepoint(nr,1)=curpoint;
tepoint(nr,1)=pointid(end-1);tepoint(nr,2)=pointid(end);
%% Extract TE curve
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,tepoint(nr,1),tepoint(nr,2));jk=jk+2;
cte(nr,1)=curveid(end);
else
%Create local cs
[coordid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_coordeuler(coordid,curpoint);jk=jk+2;
%Create plane with cs
[planeid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_planepoints(planeid,coordid(end),curpoint,axis);jk=jk+2;
%Create curve by intersecting plane and surface -- Upper
[pointid,curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curveintersectplanesurf(pointid,curveid,planeid(end),surfid_tail(3),identu);jk=jk+2;
c1=curveid(end);
%Create curve by intersecting plane and surface -- Lower
[pointid,curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curveintersectplanesurf(pointid,curveid,planeid(end),surfid_tail(2),identl);jk=jk+2;
c2=curveid(end);
lepoint(nr,1)=curpoint;
tepoint(nr,1)=pointid(end-1);tepoint(nr,2)=pointid(end);
%% Extract TE curve
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,tepoint(nr,1),tepoint(nr,2));jk=jk+2;
cte(nr,1)=curveid(end);
end
%% Create midpoint in TE upper and lower
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurve(pointid,curveid(end),0.5);jk=jk+2;
%% Create local chord line
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,lepoint(nr,1),pointid(end));jk=jk+2;
%% Extract spar point 1
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurve(pointid,curveid(end),d1);jk=jk+2;
%% Extract spar point 2
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurve(pointid,curveid(end),d2);jk=jk+2;
%% Extract stringer points
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,pointid(end-1),pointid(end));jk=jk+2;
curcur=curveid(end);
curp=[pointid(end-1) pointid(end)];curp1=[];
for kk=1:length(strspacing)
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurve(pointid,curveid(end),strspacing(kk));jk=jk+2;
curp1=[curp1 pointid(end)];
end
%% TE Break
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_pointfromcurve(pointid,curveid(end-1),dextracut);jk=jk+2;
curptot=[curp curp1 pointid(end)];
idx1=1;
if nr==1
    for kk=1:length(curptot)
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointid,c1,curptot(kk));jk=jk+2;
wgbxp(nr,idx1)=pointid(end);
idx1=idx1+1;
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pprojectcurve(pointid,c2,curptot(kk));jk=jk+2;
wgbxp(nr,idx1)=pointid(end);
idx1=idx1+1;
    end
else
%% Create 4 XYZ curves for wingbox and stringer points plus extra break point near TE
for kk=1:length(curptot)
[curveid,pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curvexyz(curveid,pointid,curptot(kk),[0 0 1],1);jk=jk+2;
[curveid,pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curvexyz(curveid,pointid,curptot(kk),[0 0 -1],1);jk=jk+2;
end
%% Merge curves
curcurve=curcur+1:curveid(end);
  for kk=1:2:length(curcurve)
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=merge_curves(curveid,curcurve(kk),curcurve(kk+1));jk=jk+2;
  end
%% Find intersection points between curves
[~,b1]=find(curcur==curveid);
curvesnow=curveid(b1+1:end);
idx1=1;
  for kk=1:length(curvesnow)
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pointintersect(pointid,curvesnow(kk),c1);jk=jk+2;
wgbxp(nr,idx1)=pointid(end);
idx1=idx1+1;
[pointid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_pointintersect(pointid,curvesnow(kk),c2);jk=jk+2;
wgbxp(nr,idx1)=pointid(end);
idx1=idx1+1;
  end
end
%% Create chordwise and spanwise curves
%% Rearrange wingbox points to match correct order
wgbxp(nr,:)=[wgbxp(nr,1:2) wgbxp(nr,5:end-2) wgbxp(nr,3:4) wgbxp(nr,end-1:end)];
ccint=1;
for kk=1:2:size(wgbxp,2)
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,wgbxp(nr,kk),wgbxp(nr,kk+1));jk=jk+2;
cint(nr,ccint)=curveid(end);
ccint=ccint+1;
end
if nr>1
    countccc=1;
 %% LE
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,lepoint(nr-1,1),lepoint(nr,1));jk=jk+2;
csect(nr-1,countccc)=curveid(end);
%% TE
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,tepoint(nr-1,1),tepoint(nr,1));jk=jk+2;
csect(nr-1,countccc+1)=curveid(end);
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,tepoint(nr-1,2),tepoint(nr,2));jk=jk+2;
csect(nr-1,countccc+2)=curveid(end);
countccc=countccc+3;
for kk=1:2:size(wgbxp,2)
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,wgbxp(nr-1,kk),wgbxp(nr,kk));jk=jk+2;
csect(nr-1,countccc)=curveid(end);
countccc=countccc+1;
end
for kk=2:2:size(wgbxp,2)
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_curve2p(curveid,wgbxp(nr-1,kk),wgbxp(nr,kk));jk=jk+2;
csect(nr-1,countccc)=curveid(end);
countccc=countccc+1;
end
csect(nr-1,:)=[csect(nr-1,1) csect(nr-1,4:end) csect(nr-1,2:3)];
csectu(nr-1,:)=[csect(nr-1,1:size(cs1,2)) csect(nr-1,end-1)];
csectl(nr-1,:)=[csect(nr-1, 1) csect(nr-1,size(cs1,2)+1:end-2) csect(nr-1,end)];
end
countc=1;
%% Break upper airfoil section curves
for kk=1:2:size(wgbxp,2) 
    if kk==1
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveid,wgbxp(nr,kk),c1);jk=jk+2;
    else
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveid,wgbxp(nr,kk),curveid(end-1));jk=jk+2;
    end
cs1(nr,countc)=curveid(end);
countc=countc+1;
end
%%Add last curve
cs1(nr,countc)=curveid(end-1);
%% Break lower airfoil section curves
countc=1;
for kk=2:2:size(wgbxp,2)
    if kk==2
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveid,wgbxp(nr,kk),c2);jk=jk+2;
    else
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=break_curves(curveid,wgbxp(nr,kk),curveid(end-1));jk=jk+2;
    end
cs2(nr,countc)=curveid(end);
countc=countc+1;
end
%%Add last curve
cs2(nr,countc)=curveid(end-1);
%% Create surfaces
%% Rearrange cint
cint1=[cint cte];
%%Create chordwise surfaces
for kk=1:size(cs1,2)
    if kk==1
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf3(surfid,[cs1(nr,kk) cs2(nr,kk) cint1(nr,1)]);jk=jk+2;
    else
[surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[cs1(nr,kk) cint1(nr,kk) cs2(nr,kk) cint1(nr,kk-1) ]);jk=jk+2;
    end
    ribs(nr,kk)=surfid(end);
end
if nr>1 
  for kk=1:size(cs1,2)
%Create spanwise surfaces
    %% US
    [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[csectu(nr-1,kk) csectu(nr-1,kk+1) cs1(nr,kk) cs1(nr-1,kk) ]);jk=jk+2;
    us(nr-1,kk)=[surfid(end)];
    %% LS
    [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[csectl(nr-1,kk) csectl(nr-1,kk+1) cs2(nr,kk) cs2(nr-1,kk) ]);jk=jk+2;
    ls(nr-1,kk)=[surfid(end)];
  end
    %% FS
    [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[cint(nr-1,1) cint(nr,1) csectu(nr-1,2) csectl(nr-1,2) ]);jk=jk+2;
    fs(nr-1,kk)=surfid(end);
    %% RS
    [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[cint(nr-1,end-1) cint(nr,end-1) csectu(nr-1,end-2) csectl(nr-1,end-2) ]);jk=jk+2;
    rs(nr-1,kk)=surfid(end);
    %% TE
    [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[cte(nr-1,1) cte(nr,1) csectu(nr-1,end) csectl(nr-1,end) ]);jk=jk+2;
    ste(nr-1,kk)=surfid(end);
end
nr=nr+1;
end
spar_points=[wgbxp(1,1:2) wgbxp(1,end-3:end-2)]; %% Last two are points created by the extra cut
spar_curves=[cint(1,1) cint(1,end-1)];
str_points=[wgbxp(1,3:end-4)];
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=merge_curveslist(curveid,cs1(1,2:end-2));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=merge_curveslist(curveid,cs2(1,2:end-2));jk=jk+2;
rootcurves=[curveid(end-1) curveid(end)];
surfs.tail.ribs=ribs;
surfs.tail.fs=fs;
surfs.tail.rs=rs;
surfs.tail.te=ste;
surfs.tail.us=us;
surfs.tail.ls=ls;
curves.tail.fscaps=[csectu(:,2) csectl(:,2)];
curves.tail.rscaps=[csectu(:,end-2) csectl(:,end-2)];
curves.tail.caps=[csectu(:,2) csectu(:,end-2) csectl(:,2) csectl(:,end-2)];
curves.tail.stringers=reshape([csectu(:,3:end-3) csectl(:,3:end-3)],[1 size(csectu,1)*2*size(csectl(:,3:end-3),2)]);
curves.tail.cte=cte;
surfidstail=surfid(4:end);
maxsurfid=surfid(end);
