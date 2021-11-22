classdef DataSetManager

    properties (Access=protected)
        labels = []
        data = []
        
        train_set = []
        train_labels = []
        test_set = []
        test_labels = []
    end

    methods

        function [obj] = DataSetManager(labels_, data_)
            % Add the data, labels and kernels
            % inputs:
            %       - labels_: array of labels
            %       - data_: matrix of data
            %       - kernel_: kernel object
            obj.labels = labels_(:, 1);
            obj.data = data_';
        end

        function [obj] = split_dataset(obj, n_train_percentage)
            % Split the dataset into train and test set
            % inputs: 
            %       - n_train_percentage: porcentaje of training set
            n_train = floor(length(obj.labels)*n_train_percentage);
            rand_serie = randperm(length(obj.labels));
            obj.train_set = obj.data(:, rand_serie(1:n_train));
            obj.train_labels = obj.labels(rand_serie(1:n_train));
            obj.test_set = obj.data(:, rand_serie(n_train:end));
            obj.test_labels = obj.labels(rand_serie(n_train:end));
        end

        function [obj] = compute_kernels(obj)
        end

        %% Getters
        function [labels] = get_train_labels(obj)
            % Train labels getter
            % outputs: 
            %       - labels: train labels
            labels = obj.train_labels;
        end

        function [labels] = get_test_labels(obj)
            % Test labels getter
            % outputs: 
            %       - labels: test labels
            labels = obj.test_labels;
        end

        function [kernel] = get_train_data(obj)
            % Train kernel getter
            % outputs:
            %       - labels: train kernel
            kernel = obj.train_set;
        end

        function [kernel] = get_test_data(obj)
            % Train labels getter
            % outputs:
            %       - labels: train labels
            kernel = obj.test_set;
        end

        function [results] = get_test_results(obj, model, bin_labels)
            % Obtain the test results
            % inputs:
            %       - model: classifier model
            % output:
            %       - results: array of results
            results = model.get_output(obj.test_set, bin_labels);
        end
    end
end