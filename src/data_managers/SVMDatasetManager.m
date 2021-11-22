classdef SVMDatasetManager < DataSetManager

    properties (Access=private)
        train_kernel = []
        test_kernel = []
    end

    methods

        function [obj] = SVMDatasetManager(labels_, data_, kernel_)
            % Add the data, labels and kernels
            % inputs:
            %       - labels_: array of labels
            %       - data_: matrix of data
            %       - kernel_: kernel object
            obj = obj@DataSetManager(labels_, data_);
            if isa(kernel_, "Kernel")
                obj.train_kernel = kernel_;
                obj.test_kernel = Helpers.copy_obj(obj.train_kernel);
            end
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

        function [kernel] = get_train_data(obj)
            % Train kernel getter
            % outputs: 
            %       - labels: train kernel
            kernel = obj.train_kernel.get_kernel();
        end

        function [kernel] = get_test_data(obj)
            % Train labels getter
            % outputs: 
            %       - labels: train labels
            kernel = obj.test_kernel.get_kernel();
        end

        function [results] = get_test_results(obj, model, ~) 
            % Obtain the test results
            % inputs:
            %       - model: classifier model
            % output:
            %       - results: array of results
            data = obj.get_test_data();
            results = model.get_output(data);
        end
    end
end