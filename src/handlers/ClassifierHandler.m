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

        function [obj] = init_models(obj, class_, model, outcome_hndlr)
            % Initialize models
            % inputs:
            %       - class_: class in string format
            obj.model(class_) = Helpers.copy_obj(model); % SVM()
            obj.outcome_handler(class_) = Helpers.copy_obj(outcome_hndlr); % OutcomeHandler();
        end

        function [obj] = parse_dataset(obj, n_train_percentage)
            % Parsing dataset to obtain the train and test sets
            % inputs:
            %       - n_train_percentage: percentage of the training set
            obj.data_handler = obj.data_handler.split_dataset(n_train_percentage);
            obj.data_handler = obj.data_handler.compute_kernels();
        end

        function [obj] = train_model(obj, bin_labels, class_)
            % Train the model
            % inputs:
            %       - bin_labels: labels bynarized
            %       - class_: class in string format
            obj.model(class_) = obj.onlineTraining.train(obj.model(class_), obj.data_handler.get_train_data(), bin_labels);
        end

        function [obj] = test_model(obj, test_bin_labels, class_)
            % Test models
            % inputs:
            %       - bin_labels: labels bynarized
            %       - class_: class in string format
            %             obj.data_handler.get_test_results(obj.model(class_));
            %             data = obj.data_handler.get_test_data();
            results = obj.data_handler.get_test_results(obj.model(class_), test_bin_labels, class_);
            %             results = sum(obj.model(class_).get_alphas()*obj.data_handler.get_test_data());
            obj.outcome_handler(class_) = obj.outcome_handler(class_).add_results(results, test_bin_labels);
        end
    end
end