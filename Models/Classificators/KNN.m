classdef KNN < Classificator
    properties
        digit = 1
        k = 1
    end
    methods
        
        function [obj] = KNN(data, k, digit)
            [obj] = initializeWeights(obj, data);
            obj.k = k;
            obj.digit = digit;
        end
        
        function [obj] = initializeWeights(obj, data)
            obj.weights = rand(1, length(data));
        end
        
        function [obj] = updateParameters(obj, data)
            obj.weights = data;
        end
        
        function [output] = getOutput(obj, testData)
            output = [];
            for i = 1:length(testData(1,:))
                distances = sqrt(sum((obj.weights' - testData(:, i)').^2, 2));
                sortDistances = sort(distances);
                minDistance = sortDistances(obj.k);
                knearest = find(distances <= minDistance);
                output = [output sum(obj.labels(knearest(:))) >= 0];
            end
            zeroToNegative = (output == 0)*(-1);
            output = output + zeroToNegative;
        end
        
        function [output] = getResults(obj, testData)
            output = [];
            for i = 1:length(testData(1,:))
                distances = sqrt(sum((obj.weights' - testData(:, i)').^2, 2));
                sortDistances = sort(distances);
                minDistance = sortDistances(obj.k);
                knearest = find(distances <= minDistance);
                distances = distances(knearest);
                a = distances'.*obj.labels(knearest);
                pos = a(find(obj.labels(knearest) > 0));
                neg = a(find(obj.labels(knearest) < 0));
                if length(pos) > length(neg)
                    signal = 1;
                    val = length(pos);
                else
                    if length(pos) < length(neg)
                        signal = -1;
                        val = length(neg);
                    else
                        val = min(abs(mean(pos)), abs(mean(neg)));
                        if val == abs(mean(pos))
                            signal = 1;
                            val = length(pos);
                        else
                            signal = -1;
                            val = length(neg);
                        end
                    end
                end
                output = [output val*signal];
            end
        end
        
    end
end