classdef PerceptronDigitClassificator
    properties
        onlineTraining = []
        perceptrons = []
        data = []
        labels = []
        
        stdDev = 10;
        r = 2;
        
        testResults = []
    end
    methods
        function [obj] = PerceptronDigitClassificator(maxIterationNumber, data)
            for i = 1:10
                obj.perceptrons = [obj.perceptrons Perceptron(data(1,:), i-1)];
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
                [obj.perceptrons(i)] = obj.perceptrons(i).binaryLabels(obj.labels);
                [obj.perceptrons(i)] = obj.onlineTraining.train(obj.perceptrons(i), obj.data);
            end
        end
        
        function [obj] = evaluateTestSet(obj, labels, data)
            for i = 1:10
                [obj.perceptrons(i)] = obj.perceptrons(i).addTestLabels(labels);
                obj.perceptrons(i) = obj.perceptrons(i).addTestResult(obj.perceptrons(i).getWeights()*data');
                %obj.testResults = [obj.testResults; sign(sum(obj.perceptrons(i).getAlphas()*K_test))];
            end
        end
        
        function [obj, trainError, testError] = classificationError(obj)
            trainMatrixResults = [];
            testMatrixResults = [];
            for i = 1:10
                testMatrixAux = obj.perceptrons(i).testResults;
                trainMatrixAux = obj.perceptrons(i).weights*obj.data;
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
                testDetections(i, :) = (testDetections(i, :) ~= (obj.perceptrons(i).testLabels == 1));
                trainDetections(i, :) = (trainDetections(i, :) ~= (obj.perceptrons(i).labels == 1));
            end
            testError = sum(sum(testDetections))/(length(testDetections));
            trainError = sum(sum(trainDetections))/(length(trainDetections));
        end
    end
end
           