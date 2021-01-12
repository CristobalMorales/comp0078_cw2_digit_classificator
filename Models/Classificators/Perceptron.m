classdef Perceptron < Classificator
    properties
        digit = 1
    end
    methods
        
        function [obj] = Perceptron(data, digit)
            [obj] = initializeWeights(obj, data);
            obj.digit = digit;
        end
        
        function [obj] = initializeWeights(obj, data)
            obj.weights = rand(1, length(data));
        end
        
        function [obj] = updateParameters(obj,lastWeights, data, signApply)
            obj.weights = lastWeights + sum(data.*signApply, 2)';
        end
        
        function [output] = getOutput(obj, data)
            output = sign(obj.getWeights()*data);
        end
        
        function [signApplied] = getCorrector(obj, output)
            signApplied = (output~=obj.getLabels()).*obj.getLabels();
        end
        
    end
end