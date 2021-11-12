classdef OnlineTraining
    properties
        minErrorConverge = 1;
        maxIterationNum = 10;
        errors = []
    end
    methods
        function [obj] = OnlineTraining(minErrorConverge, maxIterationNum)
            obj.minErrorConverge = minErrorConverge;
            obj.maxIterationNum = maxIterationNum;
        end
        function [obj] = init(obj)
            
        end
        
        function [classificator] = train(obj, classificator, data, labels)
            if isequal(class(classificator),'LeastSquare') || isequal(class(classificator),'KNN')
                [classificator] = train_least(obj, classificator, data, labels);
            else
                [classificator] = train_svm(obj, classificator, data, labels);
            end
        end
        
        function [classificator] = train_svm(obj, classificator, data, labels)
            errorConverge = 0.0001;
            iter_n = 0;
            while iter_n < obj.maxIterationNum %errorConverge < obj.minErrorConverge
                if iter_n == obj.maxIterationNum
                    break
                end
                prev_error = classificator.compute_error(labels);
                classificator = classificator.train(data, labels);
                curr_error = classificator.compute_error(labels);
                obj.minErrorConverge = abs(curr_error - prev_error);
                iter_n = iter_n +1;
            end
        end
        
        function [classificator] = train_least(obj, classificator, data)
            [classificator] = classificator.updateParameters(data);
        end
    end
end