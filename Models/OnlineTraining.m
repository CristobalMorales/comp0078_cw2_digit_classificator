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
        
        function [classificator] = train(obj, classificator, data)
            if isequal(class(classificator),'LeastSquare') || isequal(class(classificator),'KNN')
                [classificator] = trainLeast(obj, classificator, data);
            else
                [classificator] = trainClasificator(obj, classificator, data);
            end
        end
        
        function [classificator] = trainClasificator(obj, classificator, data) %data is kernel
            errorConverge = 100;
            iter_n = 0;
            while errorConverge > obj.minErrorConverge
                if iter_n == obj.maxIterationNum
                    break
                end
                last_w = classificator.getWeights();
                [output] = classificator.getOutput(data);
                [corrector] = classificator.getCorrector(output);
                classificator = classificator.updateParameters(last_w, data, corrector);
                errorConverge = norm(classificator.getWeights() - last_w);
                iter_n = iter_n +1;
            end
        end
        
        function [classificator] = trainLeast(obj, classificator, data)
            [classificator] = classificator.updateParameters(data);
        end
    end
end