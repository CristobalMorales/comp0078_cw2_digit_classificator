classdef DataSetManager
    properties (Access=private)
        labels = []
        data = []
        
        train_set = []
        train_labels = []
        test_set = []
        test_labels = []

        train_kernel = []
        test_kernel = []
    end
    methods

        function [obj] = DataSetManager(labels_, data_, kernel_)
            % Add the data, labels and kernels
            % inputs:
            %       - labels_: array of labels
            %       - data_: matrix of data
            %       - kernel_: kernel object
            obj.labels = labels_(:, 1);
            obj.data = data_';
            if isa(kernel_, "Kernel")
                obj.train_kernel = kernel_;
                obj.test_kernel = Helpers.copy_obj(obj.train_kernel);
            end
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
            % Split the dataset into train and test set
            % inputs: 
            %       - n_train_percentage: porcentaje of training set
            obj.train_kernel = obj.train_kernel.init_kernel(obj.train_set);
            obj.test_kernel = obj.test_kernel.init_kernel(obj.test_set);
            obj.train_kernel = obj.train_kernel.compute(obj.train_set, obj.train_set);
            obj.test_kernel = obj.test_kernel.compute(obj.train_set, obj.test_set);
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

        function [kernel] = get_train_kernel(obj)
            % Train kernel getter
            % outputs: 
            %       - labels: train kernel
            kernel = obj.train_kernel.get_kernel();
        end

        function [kernel] = get_test_kernel(obj)
            % Train labels getter
            % outputs: 
            %       - labels: train labels
            kernel = obj.test_kernel.get_kernel();
        end

    end
end