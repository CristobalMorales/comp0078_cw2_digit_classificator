classdef MultiClassifierHandler < ClassifierHandler
    
    properties
    end
    
    methods

        function [obj] = MultiClassifierHandler(varargin)
            obj = obj@ClassifierHandler(varargin);
        end

        function [obj] = init_models(obj, model, outcome_hndlr)
            % Initialize models and handlers 
            for c = 1:length(obj.classes)
                class = obj.classes{c};
                obj = init_models@ClassifierHandler(obj, class, model, outcome_hndlr);
            end
        end

        function [obj] = train_model(obj)
            % Train models
            for c = 1:length(obj.classes)
                class = obj.classes{c};
                bin_labels = Helpers.bynarize_labels(obj.data_handler.get_train_labels(), class);
                obj.model(class) = obj.model(class).init_weigths(bin_labels);
                obj = train_model@ClassifierHandler(obj, bin_labels, class);
            end
        end

        function [obj] = test_model(obj)
            % Test models
            for c = 1:length(obj.classes)
                class = obj.classes{c};
                bin_labels = Helpers.bynarize_labels(obj.data_handler.get_test_labels(), class);
                obj = test_model@ClassifierHandler(obj, bin_labels, class);
            end
        end

        function [metric_manager] = get_results(obj, metric_manager)
            % Obtain the results
            % inputs:
            %       - metric_manager: metric manager to store results
            % outputs:
            %       - metric_manager
            metric_manager = metric_manager.compute_statistics(obj.outcome_handler);
            metric_manager = metric_manager.get_results(obj.metrics, obj.classes);
        end

    end
end