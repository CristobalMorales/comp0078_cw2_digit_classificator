classdef KNNDatasetManager < DataSetManager

    properties (Access=private)
    end

    methods

        function [results] = get_test_results(obj, model, test_labels, class_)
            % Obtain the test results
            % inputs:
            %       - model: classifier model
            % output:
            %       - results: array of results
            train_bin_labels = Helpers.bynarize_labels(obj.get_train_labels(), class_);
            results = model.get_output(obj.test_set, train_bin_labels, test_labels);
        end
    end
end