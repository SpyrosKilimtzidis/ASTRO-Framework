function [data_ses,spar_points,spar_curves,str_points,pointid,curveid,maxsurfid,surfidswing,surfs,curves]=wing(x,surfid_wing)
%% Geometrical Data
% Parameters (Spanwise location of inboard and outboard sections)
wing_span=[8.03  24.90855];
zm=[x(3) x(4)];
vdir1=zm./wing_span;
vtot1=0:vdir1(1):0.995;
vtot2=0:vdir1(2):1;
if 1-vtot2(end)<=0.01 
    vtot2(end)=1;
end
if vtot2(end)~=1
    vtot2(end+1)=1;
end
vtot=[vtot1 vtot2]; %% Remove common edge
nr_1=length(vtot1)+1;
d1=0.2;
d2=0.7;
strspacing0=round(1/x(5));
strspacing1=linspace(0,0.5,strspacing0);
strspacing2=linspace(0.5,1,strspacing0);
strspacingtot=unique([strspacing1 strspacing2]);
if 1-strspacingtot(end)<=0.01 
    strspacingtot(end)=1;
end
if strspacingtot(end)~=1
    strspacingtot(end+1)=1;
end
strspacing=strspacingtot(2:end-1);
midix=find(strspacing==0.5);
dextracut=0.85;                     %% Extra break near TE to avoid bad meshing
%% Loop for each spanwise section, including first and last
nr=1;
pointid=[];
curveid=[];
surfid=1:6;
direction=2;
jk=1;
%% Main loop section
while nr<=length(vtot)
   if nr<=length(vtot1)
       cursurf=surfid_wing(1:3);
   else
       cursurf=surfid_wing(4:6);
   end
%% Extract upper curve 
[pointid,curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromsurf(vtot(nr),direction,pointid,curveid,cursurf(1),2);jk=jk+2;
lepoint(nr,1)=pointid(end);
tepoint(nr,1)=pointid(end-1);
c1=curveid(end);
%% Extract lower curve 
[pointid,curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromsurf(vtot(nr),direction,pointid,curveid,cursurf(2),1);jk=jk+2;
tepoint(nr,2)=pointid(end);
c2=curveid(end);
%% Extract TE curve
[pointid,curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=extract_curvefromsurf(vtot(nr),direction,pointid,curveid,cursurf(3),0);jk=jk+2;
cte(nr,1)=curveid(end);
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
    %% MS
    if nr<=nr_1
     [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[cint(nr-1,midix+1) cint(nr,midix+1) csectu(nr-1,midix+2) csectl(nr-1,midix+2)]);jk=jk+2;
    ms(nr-1,kk)=surfid(end);
    end
    %% TE
    [surfid,data_ses{1}{jk},data_ses{1}{jk+1}]=create_surf4(surfid,[cte(nr-1,1) cte(nr,1) csectu(nr-1,end) csectl(nr-1,end) ]);jk=jk+2;
    ste(nr-1,kk)=surfid(end);
end
nr=nr+1;
end
% %% Export spar points ID's
spar_points=[wgbxp(1,1:2)  wgbxp(1,2*midix+1:2*midix+2) wgbxp(1,end-3:end-2)]; %% Last two are points created by the extra cut
spar_curves=[cint(1,1) cint(1,midix+1) cint(1,end-1)];
str_points=[wgbxp(1,3:end-4)];
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=merge_curveslist(curveid,cs1(1,2:end-2));jk=jk+2;
[curveid,data_ses{1}{jk},data_ses{1}{jk+1}]=merge_curveslist(curveid,cs2(1,2:end-2));jk=jk+2;
surfs.wing.ribs=ribs;
surfs.wing.fs=fs;
surfs.wing.rs=rs;
surfs.wing.ms=ms;
surfs.wing.te=ste;
surfs.wing.us=us;
surfs.wing.ls=ls;
curves.wing.fscaps_u=csectu(:,2);
curves.wing.fscaps_l=csectl(:,2);
curves.wing.mscaps_u=csectu(:,midix+1);
curves.wing.mscaps_l=csectl(:,midix+1);
curves.wing.rscaps_u=csectu(:,end-2);
curves.wing.rscaps_l=csectl(:,end-2);
curves.wing.stringers=reshape([csectu(:,3:end-3) csectl(:,3:end-3)],[1 size(csectu,1)*2*size(csectl(:,3:end-3),2)]);
curves.wing.stringers_u=csectu(:,3:end-3);
curves.wing.stringers_l=csectl(:,3:end-3);
curves.wing.cte=cte;
curves.wing.caps=[curves.wing.fscaps_u; curves.wing.fscaps_l ;curves.wing.mscaps_u ;curves.wing.mscaps_l ;curves.wing.rscaps_u; curves.wing.rscaps_l]';
surfidswing=surfid;
maxsurfid=surfid(end);