function featurePossible = possible_feature(type,x,y,scale_x,scale_y)

feature_types = [1 2; 2 1; 1 3; 3 1; 2 2];
end_x = feature_types(type,2) * scale_x;
end_y = feature_types(type,1) * scale_y;

if(x+end_x-1<=16 && y+end_y-1<=16)
    featurePossible = 1;
else
    featurePossible = 0;
end


end
