% Description:
% A program that finds k dominant colours in an image and displays the
% resulting image using only the dominant colours.
%
% Author: Dimitrios Taleporos
%
clc
clear all
% Inputs:
img = imread('house.tiff'); % The image you want to load
k = 2;                      % The number of colour groupings
maxIterations = 15;     % The maximum number of iterations before stopping

% Rearrange the pixels in the image to be used as inputs
x = reshape(img, size(img,1)*size(img,2), 3);
x = double(x);
xlabel = zeros(size(x,1),1);

% Create k means with randomized pixel values
dist = zeros(k,1);
means = zeros(k,3);
for i = 1:k
    means(i,:) = [rand*255 rand*255 rand*255];
end

for iterations = 1:maxIterations
    % Compute which mean is closest to each image pixel
    newMean = zeros(k,3);
    for i = 1:size(x,1)
        for j = 1:k
            dist(j) = sum(norm(x(i,:)-means(j,:)));
        end

        minDist = find(dist==min(dist),1);
        xlabel(i) = minDist;
        newMean(minDist,:) = newMean(minDist,:) + x(i,:);
    end
    
    % Compute change between the current mean and the previous iteration
    diff = ones(k,1);
    for i = 1:k
        if (size(find(xlabel==i),1)==0) % No pixels are closest
            newMean(i,:) = [rand*255 rand*255 rand*255];
        else
            newMean(i,:) = newMean(i,:)/size(find(xlabel==i),1);
        end
        diff(i) = sum(newMean(i,:)-means(i,:));
    end
    
    
    % If none of the means change, stop
    if (sum(diff)==0)
        break
    end
    
    % Assign updated means
    for i = 1:k
        means(i,:) = newMean(i,:);
    end
    iterations % Print out the current number of iterations
end

% Recreate the image using the k-mean colours
imgLabeled = zeros(size(x,1),3);
for i = 1:size(x,1)
    imgLabeled(i,:) = means(xlabel(i),:);
end
imgLabeled = reshape(imgLabeled,size(img,1),size(img,2),3);
imgLabeled = uint8(imgLabeled);

% Plot the results
figure;
imshow(img)
title('Original Image')

figure;
imshow(imgLabeled)
title("Recreated Image Using K-Means Clustering (K=" + k + ")")

figure;
title('Raw Datapoints Grouped by K-Mean Clusters')
view(3)
for i = 1:k
    hold on
    scatter3(x(find(xlabel==i),1),x(find(xlabel==i),2),x(find(xlabel==i),3),1,means(i,:)/255)
end