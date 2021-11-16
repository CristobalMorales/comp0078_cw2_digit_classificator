classdef OnlineTraining
    properties
        min_error_converge = 1;
        max_iteration_num = 10;
        errors = []
    end
    methods
        function [obj] = OnlineTraining(min_error_converge_, max_iteration_num_)
            % Initialize the online training with the parameters
            % inputs:
            %       - min_error_converge_: the min error allowed
            %       - max_iteration_num_: max number of iterations
            obj.min_error_converge = min_error_converge_;
            obj.max_iteration_num = max_iteration_num_;
        end

        function [obj] = init(obj)    
        end
        
        function [classificator] = train(obj, classificator, data, labels)
            % Train models
            % inputs:
            %       - classificator: The model to be trained
            %       - data: data to train the model
            %       - labels: Labels of the training data
            if isequal(class(classificator),'LeastSquare') || isequal(class(classificator),'KNN')
                [classificator] = train_least(obj, classificator, data, labels);
            else
                [classificator] = train_svm(obj, classificator, data, labels);
            end
        end
        
        function [classificator] = train_svm(obj, classificator, data, labels)
            % Train svm
            % inputs:
            %       - classificator: The model to be trained
            %       - data: data to train the model
            %       - labels: Labels of the training data
            iter_n = 0;
            while iter_n < obj.max_iteration_num
                if iter_n == obj.max_iteration_num
                    break
                end
                prev_error = classificator.compute_error(labels);
                classificator = classificator.train(data, labels);
                curr_error = classificator.compute_error(labels);
                obj.min_error_converge = abs(curr_error - prev_error);
                iter_n = iter_n +1;
            end
        end
        
        function [classificator] = train_least(obj, classificator, data)
            % Train least square
            % inputs:
            %       - classificator: The model to be trained
            %       - data: data to train the model
            %       - labels: Labels of the training data
            [classificator] = classificator.updateParameters(data);
        end
    end
end