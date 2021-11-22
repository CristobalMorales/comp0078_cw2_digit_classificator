classdef ClassifierMetricManager < MetricManager
    
    properties
    end

    methods
        function [obj] = ClassifierMetricManager()
            % Initialize the basic metrics for classifiers
            obj.true_positives = containers.Map.empty;
            obj.false_positives = containers.Map.empty;
            obj.false_negatives = containers.Map.empty;
            obj.true_negatives = containers.Map.empty;
        end

        function [obj] = compute_statistics(obj, outcome_hndls)
            % Compute the statistics for the classifiers 
            % inputs:
            %       - outcome_hndls: dict that contains the handlers of the
            %        outcome
            classes = outcome_hndls.keys();
            for c = 1:length(classes)
                class = classes{c};
                test_results = outcome_hndls(class).get_test_results();
                test_labels = outcome_hndls(class).get_test_labels();
                for k = 1:length(classes)
                    if k ~= c
                        cmp_class = classes{k};
                        test_results_cmp = outcome_hndls(cmp_class).get_test_results();
                        detections = (sign(test_results)==1);
                        matches = (sign(test_results_cmp)==1).*(sign(test_results)==1);
                        no_detections = test_results.*matches < test_results_cmp.*matches;
                        detections = detections - no_detections;
                    end
                end
                detections = detections > 0;
                obj.true_positives(class) = detections.*(test_labels == 1);
                obj.false_positives(class) = detections.*(test_labels == -1);
                obj.false_negatives(class) = (detections == 0).*(test_labels == 1);
                obj.true_negatives(class) = (detections == 0).*(test_labels == -1);
            end
        end

        function [obj] = get_results(obj, metrics_, classes_)
            % Obtain the metrics set in the metrics set
            % inputs: 
            %       - metrics_: array of metric to compute
            %       - classes_: Classes to obtain
            for i = 1:length(metrics_)
                for c = 1:length(classes_)
                    class = classes_{c};
                    fcn_name = strcat('get_', metrics_{i});
                    obj = feval(fcn_name, obj, class);
                end
            end
        end

        function [obj] = get_spec_sen(obj, class_)
            % Show sensitivity and specificity of the classes
            % inputs: 
            %       - class_: class (string)
            sensivity = sum(obj.true_positives(class_)) / ...
                (sum(obj.true_positives(class_)) + ...
                sum(obj.false_negatives(class_)));
            specificity = sum(obj.true_negatives(class_)) / ...
                (sum(obj.true_negatives(class_)) + ...
                sum(obj.false_positives(class_)));
            disp(strcat('Class: ', class_))
            disp(strcat('Sensivity: ', num2str(sensivity)))
            disp(strcat('Specificity: ', num2str(specificity)))
            %obj.higher_results('test_error') = test_error;
        end
    end
end