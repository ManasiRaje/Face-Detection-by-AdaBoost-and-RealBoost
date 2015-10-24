close all;
clear all;

number_images = 10000;
feature_type = 1;

% read the images
sdirectory = 'newface16';
bmpfiles = dir([sdirectory '\*.bmp']);

size_features = size(value_face(:,1));
number_features = size_features(1,1);

%----------------------------------------------------------------------
%{
  %display a histogram
for i = 1 : number_features
i
[n1, xout1] = hist(value_face(i,:));
[n2, xout2] = hist(value_nonface(i,:));
plot(xout1, n1, 'r'); % Plot in red
hold on;
plot(xout2, n2, 'g'); % Plot in green
hold off;
pause;
end
%}


% plot a histogram for each feature and find the threshold for each histogram
for i =  1 : number_features %32384
    hist_face = (value_face(i,:)); %11838
    hist_nonface = (value_nonface(i,:)); %45356
    mean_face = mean(hist_face);
    mean_nonface = mean(hist_nonface);
    variance_face = var(hist_face);
    variance_nonface = var(hist_nonface);
    a = ((variance_face * mean_nonface) - (variance_nonface * mean_face)) / (variance_face - variance_nonface);
    b = ((variance_face * (mean_nonface^2)) - (variance_nonface * (mean_face^2)) - (variance_face * variance_nonface * log(variance_face/variance_nonface)))/(variance_face - variance_nonface);
    threshold(i,1) = (a - real(sqrt(a^2 - b)));
    threshold(i,2) = (a + real(sqrt(a^2 - b)));
end

%Deciding which curve is positive(face = +1) and which is negative(nonface = -1)
for i = 1 : number_features
    [freq_face,valuef] = hist(value_face(i,:));
    [freq_nonface,valuenf] = hist(value_nonface(i,:));
    for j = 1 : 10
        if valuef(j)>threshold(i,1)
            start_index_f = j;
            break;
        end
    end
    
    for j = 1 : 10      
        if valuef(10-j+1)<threshold(i,2)
            end_index_f = 10-j+1;
            break;
        end
    end
    
    for j = 1 : 10     
        if valuenf(j)>threshold(i,1)
            start_index_nf = j;
            break;
        end
    end
       
    for j = 1 : 10  
        if valuenf(10-j+1)<threshold(i,2)
            end_index_nf = 10-j+1;
            break;
        end
    end
    
    %{
    if (end_index_f - start_index_f) < (end_index_nf - start_index_nf)
        n = (end_index_f - start_index_f) + 1;
    else
        n = (end_index_nf - start_index_nf) + 1;
    end
    
   
    for j = 1 : n
        max_face = max_face + valuef(start_index_f+j-1);
        max_nonface = max_nonface + valuenf(start_index_nf+j-1);
    end
    %}
    
    max_face = max(freq_face(start_index_f:end_index_f));
    max_nonface = max(freq_nonface(start_index_nf:end_index_nf));
    
    if max_face > max_nonface
        hInitial(i) = 1;
    else
        hInitial(i) = 0;
    end
end


% number of faces and number of nonfaces
cnt_face= 0;
cnt_nonface = 0;
for i = 1 : number_features
    
    if hInitial(i) == 1
        cnt_face = cnt_face+1;
    else
        cnt_nonface = cnt_nonface+1;
    end
end

%*************************************************************************************************************************
%ADABOOST VIOLA JONES
%weight w(round,sample) | sample = face(+1/positive) (1 to 50) or
%%nonface(-1/negative)(51 to 100)
%w(1,i) = 1/2pos,1/2neg = 1/100 (since pos = neg = 50)
for i = 1 : number_images*2
    w(1,i) = 0.01;
end
t_last = 10;
for t = 1 : 10 %t=1,...,T (round)
    
    %1. Normalize the weights
    for i = 1 : number_images*2
        w(t,i) = w(t,i)/sum(w(t,:));
    end
    
    
    %2. For each feature j, train classifier hj | find error for each classifier
    for j = 1 : number_features
        sum_error = 0;
        for i = 1 : number_images
            if threshold(j,1) < value_face(j,i) && value_face(j,i) < threshold(j,2)
                h(j,i) = hInitial(j);
            else
                h(j,i) = not(hInitial(j));
            end
            sum_error = sum_error +  (w(t,i) * abs(h(j,i) - 1)); %1 = face
        end
        for i = number_images+1 : number_images*2
            if threshold(j,1) < value_nonface(j,i-number_images) && value_nonface(j,i-number_images) < threshold(j,2)
                h(j,i) = hInitial(j);
            else
                h(j,i) = not(hInitial(j));
            end
            sum_error = sum_error +  (w(t,i) * abs(h(j,i) - 0)); %0 = nonface
        end
        
        error(j) = sum_error;
        all_errors(t,j) = error(j);
    end
   
    %3. Choose h with the lowest error
    
    [error_sorted,index_sorted] = sort(error);
    et(t) = error_sorted(1);
    ht(t,:) = h(index_sorted(1),:);
    track_features_j(t) = index_sorted(1);
    %4. Revise weights
    beta(t) = et(t)/(1-et(t));
    %{
    if beta(t) == 0
        t_last = t-1;
        break;
    end
    %}
    alpha(t) = log(1/beta(t));
    for i = 1 : number_images*2
        if (ht(t,i) == 1 && i<=number_images) || (ht(t,i) == 0 && i>=number_images+1)
            e(i) = 0; %correctly claasified
        else 
            e(i) = 1; %incorrectly classified
        end
        w(t+1,i) = w(t,i) * beta(t)^(1-e(i));
    end
end

sum_at = 0;
for t = 1 : t_last
    sum_at = sum_at + alpha(t);
end
    

for i = 1 : number_images*2
    sum_atht = 0;
    for t = 1 : t_last
        sum_atht = sum_atht + alpha(t) * ht(t,i);
        
    end
    if sum_atht >= (0.5 * sum_at)
        H(i) = 1;
    else
        H(i) = 0;
    end
end