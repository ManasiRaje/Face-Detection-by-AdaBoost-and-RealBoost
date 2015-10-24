
clear all;
close all;

load('value_face200.mat');
load('value_nonface200.mat');

number_images = 1000;

size_features = size(value_face(:,1));
number_features = size_features(1,1);

load('threshold200.mat');

load('hInitial200.mat');

load('et200_50.mat');
load('track_features_j200_50.mat');
load('alpha200_50.mat');


[et_sorted_values,et_sorted_index] = sort(et);
top_ten_indices_ht = et_sorted_index(1:10);  %required ts


for i = 1 : 10
	top_ten_indices_features(i) = track_features_j(top_ten_indices_ht(i));
	info = feature_info(top_ten_indices_features(i),i);
end


count = 0;
for type = 1 %type of feature
    for scale_x = 1 : 16 %scale_x
        for scale_y = 1 : 16 %scale_y
            for x = 1 : 16 %x (column location)
                for y = 1 : 16 %y (row location)
                    if(possible_feature(type,x,y,scale_x,scale_y) == true)
                        count = count + 1;
                        info(count,:)  = [type x y scale_x scale_y];
                    end
                end
            end
        end
    end
end

                        
%*****************************************************************************************

sdirectory = 'newface16';
bmpfiles = dir([sdirectory '\*.bmp']);
ht_test=[];
for p = 10001 : 11000

	filename = [sdirectory '\' bmpfiles(p).name];
	tempImage = imread(filename);
  
	%for this RGB image, convert it to grey scale
	I = rgb2gray(tempImage);
    II = integralImage(I);
	% for each image calculate the feature value for each t
	for t = 1 : 50
		j = track_features_j(t);
		%info = feature_info(j,1);
		f_value_face(t,p-10000) = feature_value(II, info(j,1), info(j,2), info(j,3), info(j,4), info(j,5));
		%for this value, classify the feature
        
		if threshold(j,1) < f_value_face(t,p-10000) && f_value_face(t,p-10000) < threshold(j,2)
                		if hInitial(j) == 0
                            ht_test(t,p-10000) = -1;
                        else
                            ht_test(t,p-10000) = 1;
                        end
        else
                        if hInitial(j) == 1
                            ht_test(t,p-10000) = -1;
                        else
                            ht_test(t,p-10000) = 1;
                        end
        end
        %for this t, find the sum atht == F(x)
        sum = 0;
        sum_at = 0;
		for i = 1 : t
            sum = sum + alpha(i) * ht_test(i,p-10000);
            sum_at = sum_at + alpha(i);
        end
        
        F_face(t,p-10000) =  - sum + 0.5 * sum_at;
        
    end
end

sdirectory = 'nonface16x16\nonface16';
bmpfiles = dir([sdirectory '\*.bmp']);
ht_test=[];
for p = 10001 : 20000

	filename = [sdirectory '\' bmpfiles(p).name];
	tempImage = imread(filename);
  
	%for this RGB image, convert it to grey scale
	I = rgb2gray(tempImage);
    II = integralImage(I);
	% for each image calculate the feature value for each t
	for t = 1 : 50
		j = track_features_j(t);
		%info = feature_info(j,1);
		f_value_face(t,p-10000) = feature_value(II, info(j,1), info(j,2), info(j,3), info(j,4), info(j,5));
		%for this value, classify the feature
        
		if threshold(j,1) < f_value_face(t,p-10000) && f_value_face(t,p-10000) < threshold(j,2)
                		if hInitial(j) == 0
                            ht_test(t,p-10000) = -1;
                        else
                            ht_test(t,p-10000) = 1;
                        end
        else
                        if hInitial(j) == 1
                            ht_test(t,p-10000) = -1;
                        else
                            ht_test(t,p-10000) = 1;
                        end
        end
        %for this t, find the sum atht == F(x)
        sum = 0;
        sum_at = 0;
		for i = 1 : t
            sum = sum + alpha(i) * ht_test(i,p-10000);
            sum_at = sum_at + alpha(i);
        end
        
        F_nonface(t,p-10000) = sum - 0.5 * sum_at;
        
    end
end

for t = 1 : 50
   
        [n1, xout1] = hist(F_face(t,:),25);
        [n2, xout2] = hist(F_nonface(t,:),25);
         bh=bar(xout2,n2);
        set(bh,'facecolor',[0 1 0]);
        hold on;
       
        bh=bar(xout1,n1);
        set(bh,'facecolor',[1 0 0]);
        hold off;
        pause;
end

%******************************************************************************

