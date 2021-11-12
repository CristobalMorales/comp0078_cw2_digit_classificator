classdef MultiClassifierHandler < ClassifierHandler
    
    properties
    end
    
    methods

        function [obj] = MultiClassifierHandler(varargin)
            obj = obj@ClassifierHandler(varargin);
        end

        function [obj] = init_models(obj)
            for c = 1:length(obj.classes)
                class = obj.classes{c};
                obj = init_models@ClassifierHandler(obj, class);
            end
        end

        function [obj] = train_model(obj)
            for c = 1:length(obj.classes)
                class = obj.classes{c};
                bin_labels = Helpers.bynarize_labels(obj.data_handler.get_train_labels(), class);
                obj.model(class) = obj.model(class).init_weigths(bin_labels);
                obj = train_model@ClassifierHandler(obj, bin_labels, class);
            end
        end

        function [obj] = test_model(obj)
            for c = 1:length(obj.classes)
                class = obj.classes{c};
                bin_labels = Helpers.bynarize_labels(obj.data_handler.get_test_labels(), class);
                obj = test_model@ClassifierHandler(obj, bin_labels, class);
            end
        end

        function [obj, metric_manager] = get_results(obj, metric_manager)
            metric_manager = metric_manager.compute_statistics(obj.outcome_handler);
            %             for c = 1:length(obj.classes)
            %                 class = obj.classes{c};
            %                 test_results = obj.outcome_handler(class).get_test_results();
            %                 metric_manager = metric_manager.compute_statistics(obj.outcome_handler);
            %             end
            metric_manager = metric_manager.get_results(obj.metrics, obj.classes);
        end

    end
end