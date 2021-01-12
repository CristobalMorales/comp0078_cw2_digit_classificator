
means = [];
stds = [];
for j = 1:100
    quantity = countLeast(find(countLeast(:,j)),j);
    number = find(countLeast(:,j));
    array = [];
    for i = 1:length(countLeast(find(countLeast(:,j)),j))
        array = [array ones(1, quantity(i))*number(i)];
    end
    means = [means mean(array)];
    stds = [stds std(array)];
end
errorbar(means, stds, 'r');
hold on;
means = [];
stds = [];
for j = 1:100
    quantity = countPerceptron(find(countPerceptron(:,j)),j);
    number = find(countPerceptron(:,j));
    array = [];
    for i = 1:length(countPerceptron(find(countPerceptron(:,j)),j))
        array = [array ones(1, quantity(i))*number(i)];
    end
    means = [means mean(array)];
    stds = [stds std(array)];
end
errorbar(means, stds, 'b');
means = [];
stds = [];
for j = 1:100
    quantity = countWinnow(find(countWinnow(:,j)),j);
    number = find(countWinnow(:,j));
    array = [];
    for i = 1:length(countWinnow(find(countWinnow(:,j)),j))
        array = [array ones(1, quantity(i))*number(i)];
    end
    means = [means mean(array)];
    stds = [stds std(array)];
end
errorbar(means, stds, 'k');
means = [];
stds = [];
for j = 1:21
    quantity = countKNN(find(countKNN(:,j)),j);
    number = find(countKNN(:,j));
    array = [];
    for i = 1:length(countKNN(find(countKNN(:,j)),j))
        array = [array ones(1, quantity(i))*number(i)];
    end
    means = [means mean(array)];
    stds = [stds std(array)];
end
errorbar(means, stds, 'g');
xlim([0 100])
ylim([0 120])