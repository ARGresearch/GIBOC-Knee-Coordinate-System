function [TrPRox, TrDist] = cutLongBoneMesh(TrLB)
%CUTLONGBONEMESH Separate the Mesh of long bone io two parts, a proximal 
% and a distal one.
% WARNING : Assumption about the CT coordinate system :
%               Zct is approximetly distal to proximal

% Get eigen vectors V_all of the Long Bone 3D geometry and volumetric center
[ V_all, CenterVol ] = TriInertiaPpties( TrLB );

% Initial estimate of the Distal-to-Proximal (DP) axis Z0
Z0 = V_all(:,1);

% Assumption CT CS orientation
Z0 = sign(Z0(3))*Z0;


% Fast and dirty wat to split the bone
LengthBone = max(TrLB.Points*Z0) - min(TrLB.Points*Z0);

Zprox = max(TrLB.Points*Z0) - 0.48* LengthBone;
ElmtsProx = find(TrLB.incenter*Z0>Zprox);
TrProx = TriReduceMesh( TrLB, ElmtsProx);
TrProx = TriFillPlanarHoles( TrProx );

Zdist = min(TrLB.Points*Z0) + 0.48* LengthBone;
ElmtsDist = find(TrLB.incenter*Z0<Zdist);
TrDist = TriReduceMesh( TrLB, ElmtsDist);
TrDist = TriFillPlanarHoles( TrDist );





% Alt = linspace( min(TrLB.Points*Z0)+0.5 ,max(TrLB.Points*Z0)-0.5, 100);
% Area= zeros(size(Alt));
% i=0;
% for d = -Alt
%     i = i + 1;
%     [ ~ , Area(i), ~ ] = TriPlanIntersect(TrLB, Z0 , d );
% end





end
