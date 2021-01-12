classdef SupportVector < Classificator
    properties
        alphas = []
        digit = 0
    end
    methods
        
        function [obj] = SupportVector(digit)
            obj.digit = digit;
        end
                
        function [alphas] = getAlphas(obj)
            if ~isempty(obj.alphas)
                alphas = obj.alphas;
            else
                alphas = [];
            end
        end
        
        function [obj] = binaryLabels(obj, labels_)
            obj.weights = zeros(1, length(labels_));
            obj = binaryLabels@Classificator(obj, labels_);
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
    end
end