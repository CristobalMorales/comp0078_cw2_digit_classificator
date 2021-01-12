classdef LeastSquare < Classificator
    properties
        digit = 1
    end
    methods
        
        function [obj] = LeastSquare(data)
            [obj] = initializeWeights(obj, data);
        end
        
        function [obj] = initializeWeights(obj, data)
            obj.weights = rand(1, length(data));
        end
        
        function [obj] = updateParameters(obj, data)
            obj.weights = inv(data*data')*(data*obj.labels');
        end
        
        function [output] = getOutput(obj, data)
            output = sign(obj.getWeights()'*data);
        end
    end
end