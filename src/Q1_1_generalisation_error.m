clear all;
clc;
combo_set_table = readtable('zipcombo.dat');
combo_set_complete = table2array(combo_set_table);
clear combo_set_table;
combo_set_data = combo_set_complete(:, 2:end);
combo_set_labels = combo_set_complete(:, 1);
clear combo_set_complete;

errorTable = string(zeros(2,7));
for r = 1:7
    testErrors = [];
    trainErrors = [];
    disp("Polynomial N: " + string(r));
    for i = 1:20
        disp("Iteration N: " + string(i));
        randomNum = randperm(length(combo_set_labels));
        trainNum = randomNum(1:floor(length(combo_set_labels)*0.8));
        testNum = randomNum(floor(length(combo_set_labels)*0.8):end);
        trainSet = combo_set_data(trainNum,:);
        trainLabels = combo_set_labels(trainNum);
        testSet = combo_set_data(testNum,:);
        testLabels = combo_set_labels(testNum);
        maxIterNumb = 100;
        SVMDigitClass = SVMDigitClassificator("polynomial", maxIterNumb, r);
        SVMDigitClass = SVMDigitClass.train(trainSet, trainLabels);
        SVMDigitClass = SVMDigitClass.evaluateTestSet(testLabels, testSet);
        [SVMDigitClass, trainError, testError] = SVMDigitClass.classificationError();
        testErrors = [testErrors testError];
        trainErrors = [trainErrors trainError];
    end
    errorTable(1, r) = num2str(mean(trainErrors)*100) + " +- " + num2str(std(trainErrors)*100);
    errorTable(2, r) = num2str(mean(testErrors)*100) + " +- " + num2str(std(testErrors)*100);
end
