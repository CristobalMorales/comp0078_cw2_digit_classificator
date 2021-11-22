classdef OutcomeHandler

    properties
        test_results = []
        test_labels = []
    end

    methods

        function [obj] = OutcomeHandler()
            % Set the class
        end

        function [obj] = add_results(obj, test_results_, test_labels_)
            % Set the results
            % inputs:
            %       - test_results_: test results
            %       - test_labels_: test labels
            obj.test_results = test_results_;
            obj.test_labels = test_labels_;
        end

        %% Getters
        function [test_results] = get_test_results(obj)
            % Get test results
            % outputs:
            %       - test_results: test results
            test_results = obj.test_results;
        end

        function [test_labels] = get_test_labels(obj)
            % Get test labels
            % outputs:
            %       - test_labels: test labels
            test_labels = obj.test_labels;
        end
    end
end