classdef BinaryClassifier

    properties
        weights = []
        labels = []
    end

    methods
        
        function [obj] = BinaryClassifier()
        end

        function [weights] = get_weights(obj)
            % Retrieve the weights of the classifier
            % outputs:
            %       - weights: weights of the classifier
            weights = obj.weights;
        end

        function [obj] = train(obj)
        end
    end
end