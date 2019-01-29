function [outVect] = yolocellvector(c,m,objectCoords)
%Takes an nx2 array of n coordinates, relative to an mxm image, and
%translates to a 1xk modified YOLO output vector. k = 3*c^2 where an image
%is defined by a cxc grid of cells per YOLO. k(1:c^2) are cell probabilities
%(numbered starting with UL and working L to R and U to D). k(c^2+1:2*c^2) are
%object center x coordinates relative to cell. k(2*c^2+1:3*c^2) are y...



outVect = zeros(1,3*c^2);
cellWidth = m/c;
for i = 1:size(objectCoords,1)
    xRel = objectCoords(i,1);
    yRel = objectCoords(i,2);
    xCell = ceil(xRel/cellWidth);
    yCell = ceil(yRel/cellWidth);
    cellIndex = (yCell-1)*c+xCell;
    xCellFract = mod(xRel,cellWidth)/cellWidth;
    yCellFract = mod(yRel,cellWidth)/cellWidth;
    
    outVect(cellIndex)=1;
    outVect(cellIndex+c^2) = xCellFract;
    outVect(cellIndex+2*c^2) = yCellFract;    
end

