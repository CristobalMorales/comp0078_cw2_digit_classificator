clear all;
clc;
combo_set_table = readtable('zipcombo.dat');
combo_set_complete = table2array(combo_set_table);
clear combo_set_table;
combo_set_data = combo_set_complete(:, 2:end);
combo_set_labels = combo_set_complete(:, 1);
clear combo_set_complete;

confusionMatrices = zeros(10, 10, 20);
worstDetections = containers.Map;
for i = 1:10
    worstDetections(num2str(i)) = [];
end
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
    bestParameterErrors = [];
    for r = 1:7
        disp("Polynomial N: " + string(r));
        crossValErrors = [];
        for pos = 1:5
            disp("Cross-Validation step N: " + string(pos));
            interval = floor(length(trainSet)/5);
            auxTestSet = trainSet((pos-1)*interval + 1: pos*interval,:);
            auxTestLabels = trainLabels((pos-1)*interval + 1: pos*interval);
            if pos ~= 1 && pos ~= 5
                auxTrainSet1 = trainSet(1:(pos-1)*interval + 1,:);
                auxTrainLabels1 = trainLabels(1:(pos-1)*interval + 1);
                auxTrainSet2 = trainSet(pos*interval + 1: end,:);
                auxTrainLabels2 = trainLabels(pos*interval + 1: end);
                auxTrainSet = [auxTrainSet1; auxTrainSet2];
                auxTrainLabels = [auxTrainLabels1; auxTrainLabels2];
            else
                if pos == 1
                    auxTrainSet = trainSet(pos*interval + 1: end,:);
                    auxTrainLabels = trainLabels(pos*interval + 1: end);
                else
                    auxTrainSet = trainSet(1:(pos-1)*interval + 1,:);
                    auxTrainLabels = trainLabels(1:(pos-1)*interval + 1);
                end
            end
            SVMDigitClass = SVMDigitClassificator("polynomial", maxIterNumb, r);
            SVMDigitClass = SVMDigitClass.train(auxTrainSet, auxTrainLabels);
            SVMDigitClass = SVMDigitClass.evaluateTestSet(auxTestLabels, auxTestSet);
            [SVMDigitClass, trainError, testError] = SVMDigitClass.classificationError();
            crossValErrors = [crossValErrors testError];
        end
        bestParameterErrors = [bestParameterErrors; mean(crossValErrors)];
    end
    bestParameter = find(bestParameterErrors == min(bestParameterErrors));
    SVMDigitClass = SVMDigitClassificator("polynomial", 150, bestParameter(1));
    SVMDigitClass = SVMDigitClass.train(trainSet, trainLabels);
    SVMDigitClass = SVMDigitClass.evaluateTestSet(testLabels, testSet);
    [confusionMat, badDetections] = SVMDigitClass.confusionMatrix();
    for num = 1:10
        worstDetections(num2str(num))  = [worstDetections(num2str(num)); testSet((find(sum(badDetections(:,:,num)))),:)];
    end
    confusionMatrices(:, :, i) = confusionMat;
end
save('Q1_3_confusion_matrix_and_worst.mat','confusionMatrices', 'worstDetections');