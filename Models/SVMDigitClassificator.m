classdef SVMDigitClassificator
    properties
        onlineTraining = []
        svms = []
        data = []
        labels = []
        kernel = []
        
        kernelType = 'default'
        stdDev = 10;
        r = 2;
        
        testResults = []
    end
    methods
        function [obj] = SVMDigitClassificator(kernelType, maxIterationNumber, r)
            obj.kernelType = kernelType;
            for i = 1:10
                obj.svms = [obj.svms SupportVector(i-1)];
            end
            obj.onlineTraining = OnlineTraining(1, maxIterationNumber);
            obj.r = r;
        end
        
        function [obj] = adaptData(obj, data, labels)
            obj.labels = labels(:, 1);
            obj.data = data';
        end
        
        function [obj] = train(obj, data, labels)
            [obj] = adaptData(obj, data, labels);
            [obj] = computeKernel(obj);
            for i = 1:10
                [obj.svms(i)] = obj.svms(i).binaryLabels(obj.labels);
                [obj.svms(i)] = obj.onlineTraining.train(obj.svms(i), obj.kernel);
            end
        end
        function [obj] = computeKernel(obj)
            [~, ndata] = size(obj.data);
            obj.kernel = ones(ndata,ndata);
            if obj.kernelType == "default" || obj.kernelType == "polynomial"
                obj.kernel = (obj.data'*obj.data).^obj.r;
            end
            if obj.kernelType == "gaussian"
                beta = 1/(2*obj.r^2);
                for i = 1:ndata
                    colKernel = exp(-beta*sqrt(sum((obj.data(:, i:end)' - obj.data(:, i)').^2, 2)).^2);
                    obj.kernel(i, i:end) = colKernel';
                    obj.kernel(i:end, i) = colKernel;
                end
            end
        end
        
        function [obj] = evaluateTestSet(obj, labels, data)
            [K_test] = evaluateKernel(obj, data, labels);
            for i = 1:10
                [obj.svms(i)] = obj.svms(i).addTestLabels(labels);
                obj.svms(i) = obj.svms(i).addTestResult(sum(obj.svms(i).getAlphas()*K_test));
                %obj.testResults = [obj.testResults; sign(sum(obj.svms(i).getAlphas()*K_test))];
            end
        end
        
        function [K_test] = evaluateKernel(obj, data, labels)
            [~, ndata] = size(obj.data);
            K_test = ones(ndata, length(labels));
            test_data = data';
            if obj.kernelType == "default" || obj.kernelType == "polynomial"
                K_test = (obj.data'*test_data).^obj.r;
            end
            if obj.kernelType == "gaussian"
                beta = 1/(2*obj.r^2);
                for i = 1:length(labels)
                    colKernel = exp(-beta*sqrt(sum((obj.data' - test_data(:, i)').^2, 2)).^2);
                    K_test(:, i) = colKernel;
                end
            end
        end
        
        function [obj, trainError, testError] = classificationError(obj)
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
                testDetections(i, :) = (testDetections(i, :) ~= (obj.svms(i).testLabels == 1));
                trainDetections(i, :) = (trainDetections(i, :) ~= (obj.svms(i).labels == 1));
            end
            testError = sum(sum(testDetections))/(length(testDetections));
            trainError = sum(sum(trainDetections))/(length(trainDetections));
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