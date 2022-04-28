clear

img = im2double(imread("img.jpg"));

%predetermined
original = [0 0 0; 0 1 0; 0 0 0];
ridge = [0 -1 0; -1 4 -1; 0 -1 0];
invridge = [0 1 0; 1 -4 1; 0 1 0];
sharp = [0 -1 0; -1 5 -1; 0 -1 0];

%custom
%n must be odd
n = 5;
sigma = 10;
boxblur = fspecial("average", n);
disk = fspecial("disk", n);
gaussian = fspecial("gaussian", n, sigma);

out = convolution(img, ridge);

img(150, 150, :)
out(150, 150, :)

montage({img, out}, "Size", [1 2])

function out = convolution(img, kern)
    imgsize = size(img);
    imgrows = imgsize(1);
    imgcols = imgsize(2);
    kernsize = size(kern);
    kernrows = kernsize(1);
    kerncols = kernsize(2);
    out = zeros(imgrows, imgcols, 3);

    for imgrow = 1:imgrows
        for imgcol = 1:imgcols
            accum = [0 0 0];
            for kernrow = 1:kernrows
                for kerncol = 1:kerncols
                    x = imgrow + kernrow - (kernrows + 1) / 2;
                    y = imgcol + kerncol - (kerncols + 1) / 2;
                    if x >= 1 && x < imgrows + 1 && y >= 1 && y < imgcols + 1
                        pix = [img(x, y, 1) img(x, y, 2) img(x, y, 3)];
                        weight = ones(1, 3) * kern(kernrow, kerncol);
                        accum = accum + times(weight, pix);
                    end
                end    
            end
            out(imgrow, imgcol, :) = accum;
        end
    end
end