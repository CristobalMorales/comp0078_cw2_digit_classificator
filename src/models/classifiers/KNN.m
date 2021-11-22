classdef KNN < BinaryClassifier
    properties
        k = 1
    end
    methods
        
        function [obj] = KNN(varargin)
            if ~isempty(varargin)
                obj.k = varargin{1};
            end
        end

        function [obj] = init_weigths(obj, labels_)
            obj.weights = rand(1, length(labels_));
        end
        
        function [obj] = train(obj, data)
            obj.weights = data;
        end
        
        function [output] = get_output(obj, test_set_, labels_, test_labels)
            output = [];
            for i = 1:length(test_set_(1,:))
                distances = sqrt(sum((obj.weights' - test_set_(:, i)').^2, 2));
                sortDistances = sort(distances);
                minDistance = sortDistances(obj.k);
                knearest = find(distances <= minDistance);
                output = [output sum(labels_(knearest(:))) >= 0];
            end
            zeroToNegative = (output == 0)*(-1);
            output = output + zeroToNegative;
        end
        
        function [output] = get_results(obj, test_set_, labels_)
            output = [];
            for i = 1:length(test_set_(1,:))
                distances = sqrt(sum((obj.weights' - test_set_(:, i)').^2, 2));
                sortDistances = sort(distances);
                minDistance = sortDistances(obj.k);
                knearest = find(distances <= minDistance);
                distances = distances(knearest);
                a = distances'.*labels_(knearest);
                pos = a(find(labels_(knearest) > 0));
                neg = a(find(labels_(knearest) < 0));
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