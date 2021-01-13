classdef SVMAlternativeDigitClassificator
    properties
        onlineTraining = []
        svms = []
        data = []
        labels = []
        kernel = []
        
        kernelType = 'default'
        stdDev = 10;
        r = 2;
        
        trainResults = []
        testResults = []
    end
    methods
        function [obj] = SVMAlternativeDigitClassificator(kernelType, maxIterationNumber, r)
            obj.kernelType = kernelType;
            for i = 1:10
                for j = i:9
                    obj.svms = [obj.svms AlternativeSupportVector(i-1, j)];
                end
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
            for i = 1:length(obj.svms)
                [obj.svms(i)] = obj.svms(i).binaryLabels(labels);
                [obj.svms(i)] = obj.svms(i).adaptData(data);
                [obj.svms(i)] = obj.svms(i).computeKernel(obj.r, obj.kernelType);
                [obj.svms(i)] = obj.onlineTraining.train(obj.svms(i), obj.svms(i).kernel);
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
            for i = 1:length(obj.svms)
                [obj.svms(i), K_test] = obj.svms(i).evaluateKernel(data, labels, obj.kernelType, obj.r);
                %[obj.svms(i)] = obj.svms(i).addTestLabels(labels);
                [obj.svms(i)] = obj.svms(i).addTestResult(sum(obj.svms(i).getAlphas()*K_test));
                
                [obj.svms(i), K_train] = obj.svms(i).evaluate(obj.data', obj.labels, obj.kernelType, obj.r);
                obj.trainResults = [obj.trainResults; sum(obj.svms(i).getAlphas()*K_train)];
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
        
        function [obj, trainError, testError] = classificationError(obj, labels)
            trainMatrixResults = zeros(10, length(obj.data(1,:)));
            testMatrixResults = zeros( 10, length(obj.svms(1).testLabels));
            for i = 1:length(obj.svms)
                positives = obj.svms(i).testResults > 0;
                negatives = (obj.svms(i).testResults < 0);
                testMatrixResults(obj.svms(i).digitPos + 1, :) = testMatrixResults(obj.svms(i).digitPos + 1, :) + (positives);
                testMatrixResults(obj.svms(i).digitNeg + 1, :) = testMatrixResults(obj.svms(i).digitNeg + 1, :) + (negatives);
                positives = obj.trainResults(i,:) > 0;
                negatives = obj.trainResults(i,:) < 0;
                trainMatrixResults(obj.svms(i).digitPos + 1, :) = trainMatrixResults(obj.svms(i).digitPos + 1, :) + (positives);
                trainMatrixResults(obj.svms(i).digitNeg + 1, :) = trainMatrixResults(obj.svms(i).digitNeg + 1, :) + (negatives);
            end
            maxTestResult = max(testMatrixResults.*(testMatrixResults > 0));
            maxTrainResult = max(trainMatrixResults.*(trainMatrixResults > 0));
            % Using the weights as coefficiente to classify between two
            % positives
            testDetections = (testMatrixResults == maxTestResult).*(maxTestResult ~=0);
            trainDetections = (trainMatrixResults == maxTrainResult).*(maxTrainResult ~=0);
            
            testDetections = testDetections.*(sum(testDetections) == 1);
            trainDetections = trainDetections.*(sum(trainDetections) == 1);
            
            testTruePositiveMat = zeros(10, length(labels));
            positions = ((0:length(labels) - 1)*10) + (labels + 1)';
            testTruePositiveMat(positions) = 1;
            
            trainTruePositiveMat = zeros(10, length(obj.labels));
            positions = ((0:length(obj.labels) - 1)*10) + (obj.labels + 1)';
            trainTruePositiveMat(positions) = 1;
            
            noDetectionsTest = testDetections ~= testTruePositiveMat;
            noDetectionsTrain = trainDetections ~= trainTruePositiveMat;

            testError = sum(sum(noDetectionsTest))/(length(noDetectionsTest));
            trainError = sum(sum(noDetectionsTrain))/(length(noDetectionsTrain));
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