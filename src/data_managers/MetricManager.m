classdef MetricManager
    
    properties
        true_positives = []
        false_positives = []
        false_negatives = []
        true_negatives = []

        higher_results = []
    end

    methods

        function [obj] = MetricManager()
            % Initialize the basic metrics
            obj.higher_results = containers.Map.empty;
        end
        
        function [obj] = compute_results(obj)
        end
    end

end