classdef BinaryClassifier
    properties % (Access=private)
        weights = []
        labels = []
        test_labels = []
        test_results = []
    end

    methods
        
        function [obj] = BinaryClassifier()
        end

        function [labels] = get_labels(obj)
            % Return the labels for the training purpose
            labels = obj.labels;
        end

        function [weights] = get_weights(obj)
            % Retrieve the weights of the classifier
            weights = obj.weights;
        end
        
        %% Deprecated
        
        function [obj] = add_test_labels(obj, labels_)
            obj.test_labels = zeros(1, length(labels_));
            for i = 1:length(labels_)
                if labels_(i) == obj.digit
                    obj.test_labels(1, i) = 1;
                    continue;
                end
                obj.test_labels(1, i) = -1;
            end
        end

        function [obj] = add_test_results(obj, test_results_)
            obj.test_results = test_results_;
        end

        function [obj] = train(obj)
        end
    end
end