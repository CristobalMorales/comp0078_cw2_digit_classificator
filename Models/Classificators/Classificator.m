classdef Classificator
    properties
        labels = []
        testLabels = []
        weights = []
        
        testResults = []
    end
    methods
        
        function [obj] = Classificator()
        end
        
        function [labels] = getLabels(obj)
            if ~isempty(obj.labels)
                labels = obj.labels;
            else
                labels = [];
            end
        end
        
        function [weights] = getWeights(obj)
            if ~isempty(obj.weights)
                weights = obj.weights;
            else
                weights = [];
            end
        end
        
        function [obj] = binaryLabels(obj, labels_)
            obj.labels = zeros(1, length(labels_));
            for i = 1:length(labels_)
                if labels_(i) == obj.digit
                    obj.labels(1, i) = 1;
                    continue;
                end
                obj.labels(1, i) = -1;
            end
        end
        
        function [obj] = addTestLabels(obj, labels_)
            obj.testLabels = zeros(1, length(labels_));
            for i = 1:length(labels_)
                if labels_(i) == obj.digit
                    obj.testLabels(1, i) = 1;
                    continue;
                end
                obj.testLabels(1, i) = -1;
            end
        end
                
        function [obj] = addTestResult(obj, testResults)
            obj.testResults = testResults;
        end
        
        function [obj] = updateParameters(obj)
        end
        
    end
end