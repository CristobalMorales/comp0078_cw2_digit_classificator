classdef Winnow < Classificator
    properties
        digit = 1
    end
    methods
        
        function [obj] = Winnow(data)
            [obj] = initializeWeights(obj, data);
        end
        
        function [obj] = initializeWeights(obj, data)
            obj.weights = ones(1, length(data));
        end
        
        function [obj] = updateParameters(obj,lastWeights, data, signApply)
            binaryData = (data ~= 0);
            binaryIncremental = (data == 1);
            binaryDecremental = (data == -1);
            %zerosToSum = (data == 0);
            negativeSum = (signApply == -1)/2;
            positiveSum = (signApply == 1)*2 ;
            binaryIncremental = binaryIncremental.*positiveSum;
            binaryDecremental = binaryDecremental.*negativeSum;
            auxData = binaryDecremental + binaryIncremental;%binaryData.*(negativeSum + positiveSum);
            zerosToSum = (auxData == 0);
            auxData = auxData + zerosToSum;
            obj.weights = lastWeights.*prod(auxData, 2)';
        end
        
        function [output] = getOutput(obj, data)
            % ver si data + 1 esta correcto
            output = (obj.getWeights()*(data)) > length(obj.getWeights())/2;
            output = output + (output == 0)*(-1);
        end
        
        function [signApplied] = getCorrector(obj, output)
            signApplied = (output~=obj.getLabels()).*obj.getLabels();
        end
    end
end