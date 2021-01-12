clear all;
clc;
test_set_table = readtable('test.dat');
train_set_table = readtable('train.dat');
test_set_complete = table2array(test_set_table);
train_set_complete = table2array(train_set_table);
clear test_set_table train_set_table;
test_set_data = test_set_complete(:, 2:end);
test_set_labels = test_set_complete(:, 1);
train_set_data = train_set_complete(:, 2:end);
train_set_labels = train_set_complete(:, 1);
clear test_set_complete train_set_complete;

%train_set_data = train_set_data(1:2000,:);
%train_set_labels = train_set_labels(1:2000,:);

% [ndata, mdim] = size(train_set_data);
% data = zeros(mdim, ndata);
% labels = zeros(1, length(train_set_labels));
% for i = 1:length(train_set_labels)
%     data(:,i) = train_set_data(i,:)';
%     if train_set_labels(i) == 7
%         labels(1, i) = 1;
%         continue;
%     end
%     labels(1, i) = -1;
% end
% 
% [ndata_test, mdim_test] = size(test_set_data);
% data_test = zeros(mdim_test, ndata_test);
% labels_test = zeros(1, length(test_set_labels));
% for i = 1:length(test_set_labels)
%     data_test(:,i) = test_set_data(i,:)';
%     if test_set_labels(i) == 7
%         labels_test(1, i) = 1;
%         continue;
%     end
%     labels_test(1, i) = -1;
% end

[ndata, mdim] = size(test_set_data);
data = zeros(mdim, ndata);
labels = zeros(1, length(test_set_labels));
for i = 1:length(test_set_labels)
    data(:,i) = test_set_data(i,:)';
    if test_set_labels(i) == 7
        labels(1, i) = 1;
        continue;
    end
    labels(1, i) = -1;
end

w = zeros(1,ndata);
alpha = zeros(1,ndata);

error = 0.0001;

stdev = 10;
beta = 1/(2*stdev^2);

r = 4;
f = ones(1, ndata);
%H = (labels'.*(data'*data).^r).*labels;

K = ones(ndata,ndata);
for i = 1:ndata
    for j = 1:ndata
        K(i,j) = exp(-beta*norm(data(:,i) - data(:,j))^2); %labels(i)*labels(j)*
    end
end

alphas = [];
error_converge = 100;
iter_n = 0;
while error_converge > 1
    if iter_n == 20
        break
    end
    last_w = w;
    output = sign(w);
    alpha = (output~=labels).*labels;
    w = w + alpha*K;
    alphas = [alphas; alpha];
    error_converge = norm(w -last_w);
    iter_n = iter_n +1;
end

H = K;%(labels'.*(K(i,j))).*labels;
A = -1*ones(1,ndata);
b = 0;
Aeq = labels;
beq = 0;
C = 100;
alpha = quadprog(H,-f,[], [], Aeq, beq, zeros(ndata,1 ), C*ones(ndata, 1));
w = alpha'*(data.*labels)';
slope = w(1)/(-w(2));
x_interval = [-10:0.1:10];
index = find((alpha>error).*(alpha<C-error));
%index = find(alpha>error);
sv = data(:,index);
b = labels(index(1)) - w*sv(:,1);
%b = b/(-w(2));

K_test = ones(ndata, length(find(labels_test == -1)));
test = data_test(:, find(labels_test == -1));
for i = 1:ndata
    for j = 1:length(find(labels_test == -1))
        K_test(i,j) = labels(i)*alpha(i)*exp(-beta*norm(data(:,i) - test(:,j))^2);
    end
end
result = sign(sum(K_test));

% K_test = ones(ndata, length(find(labels == 1)));
% test = data(:, find(labels == 1));
% for i = 1:ndata
%     for j = 1:length(find(labels == 1))
%         K_test(i,j) = labels(i)*alpha(i)*exp(-beta*norm(data(:,i) - test(:,j))^2);
%     end
% end
% result = sign(sum(K_test));


