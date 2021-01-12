clear all;
clc;
combo_set_table = readtable('zipcombo.dat');
combo_set_complete = table2array(combo_set_table);
clear combo_set_table;
combo_set_data = combo_set_complete(:, 2:end);
combo_set_labels = combo_set_complete(:, 1);
clear combo_set_complete;


testErrorSumary = [];
for maxIterNumb = 100:100:1000
    testErrors = [];
    trainErrors = [];
    disp("Max iter N: " + string(maxIterNumb));
    for i = 1:20
        disp("Iteration N: " + string(i));
        randomNum = randperm(length(combo_set_labels));
        trainNum = randomNum(1:floor(length(combo_set_labels)*0.8));
        testNum = randomNum(floor(length(combo_set_labels)*0.8):end);
        trainSet = combo_set_data(trainNum,:);
        trainLabels = combo_set_labels(trainNum);
        testSet = combo_set_data(testNum,:);
        testLabels = combo_set_labels(testNum);
        SVMDigitClass = SVMDigitClassificator("polynomial", maxIterNumb, 4);
        SVMDigitClass = SVMDigitClass.train(trainSet, trainLabels);
        SVMDigitClass = SVMDigitClass.evaluateTestSet(testLabels, testSet);
        [SVMDigitClass, trainError, testError] = SVMDigitClass.classificationError();
        testErrors = [testErrors testError];
        trainErrors = [trainErrors trainError];
    end
    testErrorSumary = [testErrorSumary; testErrors];
end