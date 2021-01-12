classdef KNNDigitClassificator
    properties
        onlineTraining = []
        KNNs = []
        data = []
        labels = []
        
        stdDev = 10;
        r = 2;
        
        testResults = []
    end
    methods
        function [obj] = KNNDigitClassificator(maxIterationNumber, data, k)
            for i = 1:10
                obj.KNNs = [obj.KNNs KNN(data(1,:), k, i-1)];
            end
            obj.onlineTraining = OnlineTraining(0.001, maxIterationNumber);
            obj.r = maxIterationNumber;
        end
        function [obj] = adaptData(obj, data, labels)
            obj.labels = labels(:, 1);
            obj.data = data';
        end
        function [obj] = train(obj, data, labels)
            [obj] = adaptData(obj, data, labels);
            for i = 1:10
                [obj.KNNs(i)] = obj.KNNs(i).binaryLabels(obj.labels);
                [obj.KNNs(i)] = obj.onlineTraining.train(obj.KNNs(i), obj.data);
            end
        end
        
        function [obj] = evaluateTestSet(obj, labels, data)
            for i = 1:10
                [obj.KNNs(i)] = obj.KNNs(i).addTestLabels(labels);
                [result] = obj.KNNs(i).getResults(data');
                %[output] = obj.KNNs(i).getOutput(data');
                obj.KNNs(i) = obj.KNNs(i).addTestResult(result);
                %obj.testResults = [obj.testResults; sign(sum(obj.KNNs(i).getAlphas()*K_test))];
            end
        end
        
        function [obj, trainError, testError] = classificationError(obj)
            trainMatrixResults = [];
            testMatrixResults = [];
            for i = 1:10
                testMatrixAux = obj.KNNs(i).testResults;
                trainMatrixAux = obj.KNNs(i).getResults(obj.data);
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
                testDetections(i, :) = (testDetections(i, :) ~= (obj.KNNs(i).testLabels == 1));
                trainDetections(i, :) = (trainDetections(i, :) ~= (obj.KNNs(i).labels == 1));
            end
            testError = sum(sum(testDetections))/(length(testDetections));
            trainError = sum(sum(trainDetections))/(length(trainDetections));
        end
    end
end