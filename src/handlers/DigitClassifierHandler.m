classdef DigitClassifierHandler < MultiClassifierHandler
    properties
        kernel_type = 'default'
        stdDev = 10;

        testResults = []
    end
    methods
        function [obj] = DigitClassifierHandler(args)
            obj = obj@MultiClassifierHandler(args);
        end

        function [confusionMat, badDetections] = confusionMatrix(obj)
            badDetections = zeros(10,length(obj.svms(1).testResults), 10);
            confusionMat = zeros(10,10);
            trainMatrixResults = [];
            testMatrixResults = [];
            for i = 1:10
                testMatrixAux = obj.svms(i).testResults;
                trainMatrixAux = obj.svms(i).weights;
                trainMatrixResults = [trainMatrixResults; trainMatrixAux];
                testMatrixResults = [testMatrixResults; testMatrixAux];
            end
            maxTestResult = max(testMatrixResults.*(testMatrixResults > 0));
            maxTrainResult = max(trainMatrixResults.*(trainMatrixResults > 0));
            % Using the weights as coefficiente to classify between two
            % positives
            testDetections = (testMatrixResults == maxTestResult).*(maxTestResult ~=0);
            trainDetections = (trainMatrixResults == maxTrainResult).*(maxTrainResult ~=0);
            for i = 1:10
                testDetectionsAux = testDetections.*(obj.svms(i).testLabels == 1);
                trainDetections = trainDetections.*(obj.svms(i).labels == 1);
                detections = sum(testDetectionsAux, 2);
                pos = 1;
                for j = 1:10
                    if i ~= j
                        confusionMat(i, j) = detections(j);
                        badDetections(pos, :, i) = testDetectionsAux(j,:);
                    else
                        badDetections(pos, :, i) = zeros(1, length(testDetectionsAux(j,:)));
                    end
                    pos = pos + 1;
                end
            end
        end
    end
end