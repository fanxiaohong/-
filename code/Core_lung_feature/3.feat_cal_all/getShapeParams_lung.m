function RadiomicsshapeS = getShapeParams_lung(structNum,planC,rcsV)
% function shapeS = getShapeParams(structNum,planC,rcsV)

if numel(structNum) == 1
    if ~exist('planC','var')
        global planC
    end
    
    indexS = planC{end};
    
    % Get associated scan
    scanNum = getStructureAssociatedScan(structNum,planC);
    
    % Get surface points
    [xValsV, yValsV, zValsV] = getUniformScanXYZVals(planC{indexS.scan}(scanNum));
    yValsV = fliplr(yValsV);
    mask3M = getUniformStr(structNum,planC);
    
    % Crop mask around the structure
    [minr, maxr, minc, maxc, mins, maxs] = compute_boundingbox(mask3M);
    mask3M = mask3M(minr:maxr, minc:maxc, mins:maxs);
    xValsV = xValsV(minc:maxc); 
    yValsV = yValsV(minr:maxr);
    zValsV = zValsV(mins:maxs);
    
else
    mask3M = structNum;
    xValsV = planC{1};
    yValsV = planC{2};
    zValsV = planC{3};
    %voxelVol = 2; %abs((xVals(1)-xVals(2))*(yVals(1)-yVals(2))*(zVals(1)-zVals(2)));
    %volume = planC{4};
end

% Get voxel size
voxelSiz(1) = abs(yValsV(2) - yValsV(1));
voxelSiz(2) = abs(xValsV(2) - xValsV(1));
voxelSiz(3) = abs(zValsV(2) - zValsV(1));
voxelVolume = prod(voxelSiz);

volume = voxelVolume * sum(mask3M(:));

% Fill holes
mask3M = imfill(mask3M,'holes');
filledVolume = voxelVolume * sum(mask3M(:));

% Get x/y/z coordinates of all the voxels
[iV,jV,kV] = find3d(mask3M);
xV = xValsV(jV);
yV = yValsV(iV);
zV = zValsV(kV);
xyzM = [xV' yV' zV']*10;
meanV = mean(xyzM);
xyzM = bsxfun(@minus,xyzM,meanV)/ sqrt(size(xyzM,1));
eigValV = eig(xyzM' * xyzM);
shapeSmajorAxis = 4*sqrt(eigValV(3));
shapeSminorAxis = 4*sqrt(eigValV(2));
shapeSleastAxis = 4*sqrt(eigValV(1));
shapeSflatness = sqrt(eigValV(1) / eigValV(3));
shapeSelongation = sqrt(eigValV(2) / eigValV(3));

% Get the surface points for the structure mask
surfPoints = getSurfacePoints(mask3M);
sampleRate = 1;
while size(surfPoints,1) > 20000
    sampleRate = sampleRate + 1;
    surfPoints = getSurfacePoints(mask3M, sampleRate, 1);
end
xSurfV = xValsV(surfPoints(:,2));
ySurfV = yValsV(surfPoints(:,1));
zSurfV = zValsV(surfPoints(:,3));

distM = sepsq([xSurfV;ySurfV;zSurfV], [xSurfV;ySurfV;zSurfV]);
shapeSmax3dDiameter = sqrt(max(distM(:))) * 10;

rowV = unique(surfPoints(:,1));
colV = unique(surfPoints(:,2));
slcV = unique(surfPoints(:,3));

% Max diameter along slices
dmax = 0;
for i = 1:length(slcV)
    slc = slcV(i);
    xV = xValsV(surfPoints(surfPoints(:,3)==slc,2));
    yV = yValsV(surfPoints(surfPoints(:,3)==slc,1));
    distM = sepsq([xV;yV], [xV;yV]);
    dmax = max(dmax,max(distM(:)));
end
shapeSmax2dDiameterAxialPlane = sqrt(dmax) * 10;

% Max diameter along cols
dmax = 0;
for i = 1:length(colV)
    col = colV(i);
    zV = zValsV(surfPoints(surfPoints(:,2)==col,3));
    yV = yValsV(surfPoints(surfPoints(:,2)==col,1));
    distM = sepsq([zV;yV], [zV;yV]);
    dmax = max(dmax,max(distM(:)));
end
shapeSmax2dDiameterSagittalPlane = sqrt(dmax) * 10;

% Max diameter along rows
dmax = 0;
for i = 1:length(rowV)
    row = rowV(i);
    xV = xValsV(surfPoints(surfPoints(:,1)==row,2));
    zV = zValsV(surfPoints(surfPoints(:,1)==row,3));
    distM = sepsq([xV;zV], [xV;zV]);
    dmax = max(dmax,max(distM(:)));
end
shapeSmax2dDiameterCoronalPlane = sqrt(dmax) * 10;


% Add a row/col/slice to account for half a voxel
%mask3M = padarray(mask3M,[1 1 1],'replicate');
mask3M = padarray(mask3M,[1 1 1],0);
xValsV = [xValsV(1)-voxelSiz(1) xValsV xValsV(end)+voxelSiz(1)];
yValsV = [yValsV(1)-voxelSiz(2) yValsV yValsV(end)+voxelSiz(2)];
zValsV = [zValsV(1)-voxelSiz(3) zValsV zValsV(end)+voxelSiz(3)];

% Resample the structure mask
if exist('rcsV','var') && ~isempty(rcsV)
    % use the larger dim of mask or the inpur rcsV
    siz = size(mask3M);
    rcsV(rcsV < siz) = siz(rcsV < siz);
    % min/max voxel coordinates for resampling
    minX = min(xValsV)+voxelSiz(2)/2;
    maxX = max(xValsV)-voxelSiz(2)/2;
    minY = min(yValsV)+voxelSiz(1)/2;
    maxY = max(yValsV)-voxelSiz(1)/2;
    minZ = min(zValsV)+voxelSiz(3)/2;
    maxZ = max(zValsV)-voxelSiz(3)/2;
    % new x/y/z grid using the resampled size
    xValsNewV = linspace(minX,maxX,rcsV(2));
    yValsNewV = linspace(minY,maxY,rcsV(1));
    zValsNewV = linspace(minZ,maxZ,rcsV(3));
    [Xm,Ym,Zm] = meshgrid(xValsNewV,yValsNewV,zValsNewV);
    %xFieldV = [min(xValsV) max(xValsV)];
    %yFieldV = [min(yValsV) max(yValsV)];
    %zFieldV = [min(zValsV) max(zValsV)];
    %xyzUpC = {xValsNewV,yValsNewV,zValsNewV,volume};
    %outOfBoundsVal = 0;
    % resample the structure mask
    mask3M = interp3(xValsV, yValsV, zValsV, mask3M, Xm, Ym, Zm,'nearest');
    xValsV = xValsNewV;
    yValsV = yValsNewV;
    zValsV = zValsNewV;
end

% MarchincCubes surface mesh
[xValsM, yValsM, zValsM] = meshgrid(xValsV, yValsV, zValsV);
[tri,Xb] = MarchingCubes(xValsM, yValsM, zValsM, mask3M, 0.5);

% Calculate surface area from triangular mesh
shapeSsurfArea = trimeshSurfaceArea(Xb,tri);

% Calculate Volume of the structure, eq. (22) Aerts Nature suppl.
shapeSvolume = volume;
shapeSfilledVolume = filledVolume;

% Compactness 1 (V/(pi*A^(3/2)), eq. (15) Aerts Nature suppl.
shapeSCompactness1 = shapeSvolume / (pi^0.5*shapeSsurfArea^1.5);

% Compactness 2 (36*pi*V^2/A^3), eq. (16) Aerts Nature suppl.
shapeSCompactness2 = 36*pi*shapeSvolume^2/shapeSsurfArea^3;

% Spherical disproportion (A/(4*pi*R^2) , eq. (18) Aerts Nature suppl.
R = (shapeSvolume*3/4/pi)^(1/3);
shapeSspherDisprop = shapeSsurfArea / (4*pi*R^2);

% Sphericity , eq. (19) Aerts Nature suppl.
shapeSsphericity = pi^(1/3) * (6*shapeSvolume)^(2/3) / shapeSsurfArea;

% Surface to volume ratio , eq. (21) Aerts Nature suppl.
shapeSsurfToVolRatio = shapeSsurfArea / shapeSvolume;

RadiomicsshapeS = [];
RadiomicsshapeS = [shapeSmajorAxis ;shapeSminorAxis ;shapeSleastAxis ;shapeSflatness ;shapeSelongation ;shapeSmax3dDiameter;...
    shapeSmax2dDiameterAxialPlane;shapeSmax2dDiameterSagittalPlane;shapeSmax2dDiameterCoronalPlane;shapeSsurfArea;...
    shapeSvolume ;shapeSfilledVolume ;shapeSCompactness1;shapeSCompactness2;shapeSspherDisprop;shapeSsphericity;...
    shapeSsurfToVolRatio];
