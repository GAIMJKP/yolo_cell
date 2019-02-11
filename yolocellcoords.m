function [coords] = yolocellcoords(outVector, c, m, p)
%takes a yolo_cell 1xk output vector, image width m, number of cells c,
% and probability threshold p, and returns a list of [x,y] cell coordinates
% relative to the upper left corner of an mxm image.

cellProb = outVector(1:49);
boxDims = outVector(50:147);

for j = 0:6
    for i = 0:6
        outArray(i+1,j+1,1) = cellProb(i*c+j+1);
        outArray(i+1,j+1,2) = boxDims(i*c+j+1);
        outArray(i+1,j+1,3) = boxDims(i*c+j+1+c^2);
    end
end

contain = outArray(:,:,1) >p;
coords = [];
counter = 0;
for i = 1:7
    for j = 1:7
        if contain(i,j) ==1
            counter = counter + 1;
            x = outArray(i,j,2);
            y = outArray(i,j,3);
            coords(counter,1) = (j-1+x)*m/c;
            coords(counter,2) = (i-1+y)*m/c;
        end
    end
end

end

