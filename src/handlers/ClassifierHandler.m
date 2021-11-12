classdef ClassifierHandler
    properties
        model = []
        onlineTraining = []
        data_handler = []
        outcome_handler = []

        classes = {}
        metrics = {}
    end
    methods

        function [obj] = ClassifierHandler(varargin)
            obj.onlineTraining = OnlineTraining(1, varargin{1}{1});
            obj.classes = varargin{1}{2};
            obj.data_handler = varargin{1}{3};
            obj.model = containers.Map;
            obj.outcome_handler = containers.Map;
            obj.metrics = varargin{1}{4};
        end

        function [obj] = init_models(obj, class_)
            obj.model(class_) = SVM();
            obj.outcome_handler(class_) = OutcomeHandler(class_);
        end

        function [obj] = parse_dataset(obj, n_train_percentage)
            obj.data_handler = obj.data_handler.split_dataset(n_train_percentage);
            obj.data_handler = obj.data_handler.compute_kernels();
        end

        function [obj] = train_model(obj, bin_labels, class_)
            obj.model(class_) = obj.onlineTraining.train(obj.model(class_), obj.data_handler.get_train_kernel(), bin_labels);
        end

        function [obj] = test_model(obj, bin_labels, class_)
            results = sum(obj.model(class_).get_alphas()*obj.data_handler.get_test_kernel());
            obj.outcome_handler(class_) = obj.outcome_handler(class_).add_results(results, bin_labels);
        end
    end
end