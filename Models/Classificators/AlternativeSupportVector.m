classdef AlternativeSupportVector < Classificator
    properties
        alphas = []
        digitPos = 0
        digitNeg = 0
        digit = 0;
        positivePositions = []
        negativePositions = []
        kernel = []
        positionTrainLabels = []
        data = []
        transformationMat = []
        positionTestLabels = []
    end
    methods
        
        function [obj] = AlternativeSupportVector(digitPos, digitNeg)
            obj.digitPos = digitPos;
            obj.digitNeg = digitNeg;
        end
                
        function [alphas] = getAlphas(obj)
            if ~isempty(obj.alphas)
                alphas = obj.alphas;
            else
                alphas = [];
            end
        end
        
        function [obj] = binaryLabels(obj, labels_)
            obj.positivePositions = find(labels_ == obj.digitPos);
            obj.negativePositions = find(labels_ == obj.digitNeg);
            obj.positionTrainLabels = sort([obj.positivePositions; obj.negativePositions]);
            labelsAux = labels_(obj.positionTrainLabels);
            obj.weights = zeros(1, length(labelsAux));
            obj.digit = obj.digitPos;
            obj = binaryLabels@Classificator(obj, labelsAux);
        end
        
        function [obj] = adaptData(obj, data)
            auxData = data(obj.positionTrainLabels, :);
            obj.data = auxData';
        end
        
        function [obj] = computeKernel(obj, r, kernelType)
            [~, ndata] = size(obj.data);
            obj.kernel = ones(ndata,ndata);
            if kernelType == "default" || kernelType == "polynomial"
                obj.kernel = (obj.data'*obj.data).^r;
            end
            if kernelType == "gaussian"
                beta = 1/(2*r^2);
                for i = 1:ndata
                    colKernel = exp(-beta*sqrt(sum((obj.data(:, i:end)' - obj.data(:, i)').^2, 2)).^2);
                    obj.kernel(i, i:end) = colKernel';
                    obj.kernel(i:end, i) = colKernel;
                end
            end
        end
        
        function [obj] = initializeWeights(obj, labels_)
            obj.weights = zeros(1, length(labels_));
        end
        
        function [obj] = updateParameters(obj, lastWeights, kernel, alpha)
            obj.weights = lastWeights + alpha*kernel;
            obj.alphas = [obj.alphas; alpha];
        end
        
        function [output] = getOutput(obj, ~)
            output = sign(obj.getWeights());
        end
        
        function [alpha] = getCorrector(obj, output)
            alpha = (output~=obj.getLabels()).*obj.getLabels();
        end
        
        function [obj, K_test] = evaluateKernel(obj, data, labels, kernelType, r)
            obj.positionTestLabels = sort([obj.positivePositions; obj.negativePositions]);
%             labelsAux = labels(obj.positionTestLabels);
%             tranMatAux = zeros(length(labels), length(obj.positionTestLabels));
%             positions = ((0:length(obj.positionTestLabels)-1)*length(labels)) + obj.positionTestLabels';
%             tranMatAux(positions) = 1;
%             obj.transformationMat = tranMatAux;
            [obj] = obj.addTestLabels(labels);
%             dataAux = data(obj.positionTestLabels, :);
            [~, ndata] = size(data);
            K_test = ones(ndata, length(labels));
            test_data = data';
            if kernelType == "default" || kernelType == "polynomial"
                K_test = (obj.data'*test_data).^r;
            end
            if kernelType == "gaussian"
                beta = 1/(2*r^2);
                for i = 1:length(labels)
                    colKernel = exp(-beta*sqrt(sum((obj.data' - test_data(:, i)').^2, 2)).^2);
                    K_test(:, i) = colKernel;
                end
            end
        end
        
        function [obj, K_test] = evaluate(obj, data, labels, kernelType, r)
            [~, ndata] = size(data);
            K_test = ones(ndata, length(labels));
            testData = data';
            if kernelType == "default" || kernelType == "polynomial"
                K_test = (obj.data'*testData).^r;
            end
            if kernelType == "gaussian"
                beta = 1/(2*r^2);
                for i = 1:length(labels)
                    colKernel = exp(-beta*sqrt(sum((obj.data' - testData(:, i)').^2, 2)).^2);
                    K_test(:, i) = colKernel;
                end
            end
        end
        
    end
end