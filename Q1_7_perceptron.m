clear all;
clc;
combo_set_table = readtable('zipcombo.dat');
combo_set_complete = table2array(combo_set_table);
clear combo_set_table;
combo_set_data = combo_set_complete(:, 2:end);
combo_set_labels = combo_set_complete(:, 1);
clear combo_set_complete;

errorTable = string(zeros(2,length(10:10:90)));
pos = 1;
for r = 50:50:400
    testErrors = [];
    trainErrors = [];
    disp("Max iteration Value: " + string(r));
    for i = 1:20
        disp("Iteration N: " + string(i));
        randomNum = randperm(length(combo_set_labels));
        trainNum = randomNum(1:floor(length(combo_set_labels)*0.8));
        testNum = randomNum(floor(length(combo_set_labels)*0.8):end);
        trainSet = combo_set_data(trainNum,:);
        trainLabels = combo_set_labels(trainNum);
        testSet = combo_set_data(testNum,:);
        testLabels = combo_set_labels(testNum);
        perceptronDigitClass = PerceptronDigitClassificator(r, trainSet);
        perceptronDigitClass = perceptronDigitClass.train(trainSet, trainLabels);
        perceptronDigitClass = perceptronDigitClass.evaluateTestSet(testLabels, testSet);
        [perceptronDigitClass, trainError, testError] = perceptronDigitClass.classificationError();
        testErrors = [testErrors testError];
        trainErrors = [trainErrors trainError];
    end
    errorTable(1, pos) = num2str(mean(trainErrors)*100) + " +- " + num2str(std(trainErrors)*100);
    errorTable(2, pos) = num2str(mean(testErrors)*100) + " +- " + num2str(std(testErrors)*100);
    pos = pos + 1;
end
save('Q1_7_Perceptron_error.mat','errorTable')