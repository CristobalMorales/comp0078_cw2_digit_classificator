clear all;
clc;
error = 0.0001;
n_class_1 = 50;
n_class_2 = 50;
mean_1 = [2; 0];
mean_2 = [1; -1.5];
std_1 = [0.5; 0.5];
std_2 = [0.5; 0.5];
data_1 = mean_1 + randn(2,n_class_1).*std_1;
data_2 = mean_2 + randn(2,n_class_2).*std_2;
label_1 = ones(1,n_class_1);
label_2 = -1*ones(1,n_class_2);
data = [data_1 data_2];
labels = [label_1 label_2];

stdev = 1;
beta = 1/(2*stdev^2);

f = ones(1, n_class_1 + n_class_2);
% H = (labels'.*(data'*data).^2).*labels;

K = ones(100,100);
for i = 1:100
    for j = 1:100
        K(i,j) = exp(-beta*norm(data(:,i) - data(:,j))^2);
    end
end
H = (labels'.*(K(i,j))).*labels;
A = -1*ones(1,n_class_1 + n_class_2);
b = 0;
Aeq = labels;
beq = 0;
C = 100000;
alpha = quadprog(H,-f,[], [], Aeq, beq, zeros(n_class_1 + n_class_2,1 ), C*ones(n_class_1 + n_class_2, 1));
w = alpha'*(data.*labels)';
slope = w(1)/(-w(2));
x_interval = [-10:0.1:10];
index = find((alpha>error).*(alpha<C-error));
%index = find(alpha>error);
sv = data(:,index);
b = labels(index(1)) - w*sv(:,1);
b = b/(-w(2));


plot(data_1(1,:), data_1(2,:), '+g');
hold on;
plot(data_2(1,:),data_2(2,:), '*k');
grid on;
plot(x_interval, x_interval*slope + b, '--b')
plot(sv(1,:),sv(2,:), 'or')

xlim([-3 5]);
ylim([-5 5]);