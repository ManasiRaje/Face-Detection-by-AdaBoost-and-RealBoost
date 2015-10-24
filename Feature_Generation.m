close all;
clear all;

% read the images
sdirectory = 'newface16';
bmpfiles = dir([sdirectory '\*.bmp']);

for p = 1:10000
    
    %read each image
    filename = [sdirectory '\' bmpfiles(p).name];
    tempImage = imread(filename);
  
    %for this RGB image, convert it to grey scale
    I = rgb2gray(tempImage);
    
    %find the integral image
    II = getIntegralImage(I);
    
    %find the value of each feature for this image
    count=0;
    for i = 1 : 5 %type
        for scale_x = 1 : 16 %scale_x
            for scale_y = 1 : 16 %scale_y
                for x = 1 : 16 %x
                    for y = 1 : 16 %y
                        if(possible_feature(i,x,y,scale_x,scale_y) == true)
                            count= count+1;
                            %find the value (difference of rectangles)
                            value_face(count,p) = feature_value(II,i,x,y,scale_x,scale_y);
                        end
                    end
                end
            end
        end
    end
end


sdirectory = 'nonface16x16\nonface16';
bmpfiles = dir([sdirectory '\*.bmp']);

for p = 1:1000
    
    %read each image
    filename = [sdirectory '\' bmpfiles(p).name];
    tempImage = imread(filename);
  
    %for this RGB image, convert it to grey scale
    I = rgb2gray(tempImage);
    
    %find the integral image
    II = integralImage(I);
    
    %find the value of each feature for this image
    count=0;
    for i = 1 : 5 %type
        for scale_x = 1 : 16 %scale_x
            for scale_y = 1 : 16 %scale_y
                for x = 1 : 16 %x
                    for y = 1 : 16 %y
                        if(possible_feature(i,x,y,scale_x,scale_y) == true)
                            count= count+1;
                            %find the value (difference of rectangles)
                            value_nonface(count,p) = feature_value(II,i,x,y,scale_x,scale_y);
                        end
                    end
                end
            end
        end
    end
end   

%{
  %display a histogram
[n1, xout1] = hist(value_face(1,:));
[n2, xout2] = hist(value_nonface(1,:));
plot(xout1, n1, 'r'); % Plot in red
hold on;
plot(xout2, n2, 'g'); % Plot in green
%}

% plot a histogram for each feature and find the threshold for each histogram
for i =  1 : 32384
    hist_face = (value_face(i,:)); %11838
    hist_nonface = (value_nonface(i,:)); %45356
    mean_face = mean(hist_face);
    mean_nonface = mean(hist_nonface);
    variance_face = var(hist_face);
    variance_nonface = var(hist_nonface);
    a = ((variance_face * mean_nonface) - (variance_nonface * mean_face)) / (variance_face - variance_nonface);
    b = ((variance_face * (mean_nonface^2)) - (variance_nonface * (mean_face^2)) - (variance_face * variance_nonface * log(variance_face/variance_nonface)))/(variance_face - variance_nonface);
    threshold(i,1) = (a + real(sqrt(a^2 - b)));
    threshold(i,2) = (a - real(sqrt(a^2 - b)));
end