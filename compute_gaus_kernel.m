clear all;
clc;
combo_set_table = readtable('zipcombo.dat');
combo_set_complete = table2array(combo_set_table);
clear combo_set_table;
combo_set_data = combo_set_complete(:, 2:end);
combo_set_labels = combo_set_complete(:, 1);
clear combo_set_complete;


randomNum = randperm(length(combo_set_labels));
trainNum = randomNum(1:floor(length(combo_set_labels)*0.8));
testNum = randomNum(floor(length(combo_set_labels)*0.8):end);
trainSet = combo_set_data(trainNum,:);
trainLabels = combo_set_labels(trainNum);

data = trainSet';
[~, ndata] = size(data);
kernelNormal = zeros(ndata,ndata);
kernelOptimazed = zeros(ndata,ndata);
kernelMoreOptimazed = zeros(ndata,ndata);
beta = 1/(2*10^2);

tic
for i = 1:ndata
    for j = 1:ndata
        kernelNormal(i,j) = exp(-beta*norm(data(:,i) - data(:,j))^2);
    end
end
toc

tic
for i = 1:ndata
    colKernel = exp(-beta*sqrt(sum((data' - data(:, i)').^2, 2)).^2);
    kernelOptimazed(i,:) = colKernel;
end
toc

tic
for i = 1:ndata
    colKernel = exp(-beta*sqrt(sum((data(:, i:end)' - data(:, i)').^2, 2)).^2);
    kernelMoreOptimazed(i, i:end) = colKernel';
    kernelMoreOptimazed(i:end, i) = colKernel;
end
toc