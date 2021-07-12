function  [segmentsM] = doseRoiRasterSeg(structNum,planC);
% 参考CERR的getRasterSegs.m，栅格化等剂量线，否则CERR的gui几个ROI之间不能布尔操作

indexS = planC{end};
structName  = lower(planC{indexS.structures}(structNum).structureName);
scanNum     = getStructureAssociatedScan(structNum, planC);
slicesV = 1:length(planC{indexS.scan}(scanNum).scanInfo);
segOptS.ROIxVoxelWidth = planC{indexS.scan}(scanNum).scanInfo(1).grid2Units;
segOptS.ROIyVoxelWidth = planC{indexS.scan}(scanNum).scanInfo(1).grid1Units;
segOptS.ROIImageSize   = double([planC{indexS.scan}(scanNum).scanInfo(1).sizeOfDimension1  planC{indexS.scan}(scanNum).scanInfo(1).sizeOfDimension2]);
xCTOffset = planC{indexS.scan}(scanNum).scanInfo(1).xOffset;
yCTOffset = planC{indexS.scan}(scanNum).scanInfo(1).yOffset;
segOptS.xCTOffset = xCTOffset;
segOptS.yCTOffset = yCTOffset;
dummyM = zeros(segOptS.ROIImageSize);
segmentsM = [];
%Wipe out old rasterSegments for slices we are about to recalc.
if ~isempty(planC{indexS.structures}(structNum).rasterSegments)
    toRecalc = ismember(planC{indexS.structures}(structNum).rasterSegments(:,6), slicesV);
    planC{indexS.structures}(structNum).rasterSegments(toRecalc,:) = [];
    segmentsM = planC{indexS.structures}(structNum).rasterSegments;
end

for j = 1:length(slicesV)
    slice = slicesV(j);
    numSegs = length(planC{indexS.structures}(structNum).contour(slice).segments);
    maskM = dummyM;
    mask3M = [];
    % APA: added Tim's function
    for k = 1 : numSegs
        pointsM = planC{indexS.structures}(structNum).contour(slice).segments(k).points;
        if ~isempty(pointsM)
            str4 = ['Scan converting structure ' num2str(structNum) ', slice ' num2str(slice) ', segment ' num2str(k) '.'];
            CERRStatusString(str4)
            [xScanV, yScanV, zScanV] = getScanXYZVals(planC{indexS.scan}(scanNum), slice);
            %convertedContour = convertContourToPixels_1(xScanV, yScanV, planC{indexS.structures}(structNum).contour(slice),k);
            [rowV, colV] = xytom(planC{indexS.structures}(structNum).contour(slice).segments(k).points(:,1), planC{indexS.structures}(structNum).contour(slice).segments(k).points(:,2), slice, planC,scanNum);
            if any(rowV < 1) || any(rowV > segOptS.ROIImageSize(1))
                %if any(rowV+5 < 1) || any(rowV-5  > segOptS.ROIImageSize(1))
                %    %warning('A row index is off the edge of image mask: these set of points will be discarded');
                %    continue
                %end
                %warning('A row index is off the edge of the image mask:  automatically shifting to the edge.')
                rowV = rowV .* ([rowV >= 1] & [rowV <= segOptS.ROIImageSize(1)]) + ...
                    [rowV > segOptS.ROIImageSize(1)] .* segOptS.ROIImageSize(1) + ...
                    [rowV < 1];
            end
            if any(colV < 1) || any(colV > segOptS.ROIImageSize(2))
                %if any(colV+5 < 1) || any(colV-5  > segOptS.ROIImageSize(2))
                %    %warning('A column index is off the edge of image mask: these set of points will be discarded');
                %    continue
                %end
                %warning('A column index is off the edge of the image mask:  automatically shifting to the edge.')
                colV = colV .* ([colV >= 1] & [colV <= segOptS.ROIImageSize(2)]) + ...
                    [colV > segOptS.ROIImageSize(2)] .* segOptS.ROIImageSize(2) + ...
                    [colV < 1];
            end
            %convertedContour.segments.points = [round(rowV), round(colV)];
            convertedContour.segments.points = [(rowV), (colV)];
            maskM = uint32(polyFill(length(yScanV), length(xScanV), rowV, colV));
            if (size(pointsM,1) == 1) || (size(pointsM,1) == 2 && isequal(pointsM(1,:),pointsM(2,:)))
                maskM(floor(rowV(1)):ceil(rowV(1)),floor(colV(1)):ceil(colV(1))) = uint32(1);
            end
            mask3M(:,:,k) = maskM;
            zValue = pointsM(1,3);
        end
    end
    % APA: added Tim's function ends
    if ~isempty(find(mask3M))
        %Combine masks
        %Add segments together:
        %Any overlap is interpreted as a 'hole'
        baseM = dummyM;
        for m = 1 : size(mask3M,3)
            baseM = baseM + mask3M(:,:,m);  %to catalog overlaps
        end
        maskM = [baseM == 1];  %% To leave alone self-intersecting contours (eg. baseM == 2,3.. are left alone)
        tmpM = mask2scan(maskM, segOptS, slice);       %convert mask into scan segment format
        zValuesV = ones(size(tmpM,1),1) * zValue;
        try    %%JOD, 16 Oct 03
            voxelThickness = planC{indexS.scan}(scanNum).scanInfo(slice).voxelThickness;
        catch
            voxelThicknessV = deduceVoxelThicknesses(scanNum, planC);
            for p = 1 : length(voxelThicknessV)  %put back into planC
                planC{indexS.scan}(scanNum).scanInfo(p).voxelThickness = voxelThicknessV(p);
            end
            voxelThickness = planC{indexS.scan}(scanNum).scanInfo(slice).voxelThickness;
        end
        thicknessV = ones(size(tmpM,1),1) * voxelThickness;
        segmentsM = [segmentsM; [zValuesV, tmpM, thicknessV]];
    end
end

