classdef Helpers

    methods (Static)
        function [labels] = bynarize_labels(labels_, class_)
            % Bynarize the labels
            % inputs:
            %       - labels_: labels to bynarize
            %       - class_: Class in string format 
            % outputs:
            %       - labels: labels bynarized
            if ischar(class_)
                class = str2double(class_);
            end
            labels = zeros(1, length(labels_));
            for i = 1:length(labels_)
                if labels_(i) == class
                    labels(1, i) = 1;
                    continue;
                end
                labels(1, i) = -1;
            end
        end

        function obj_b = copy_obj(obj_a)
            % Copy an object
            % inputs:
            %       - obj_a: Object to copy
            % outputs:
            %       - obj_b: Object resulte
            obj_b = eval(class(obj_a));  
            for p =  properties(obj_a).'
                try
                    obj_b.(p{1}) = obj_a.(p{1});
                catch
                    warning('failed to copy property: %s', p);
                end
            end
        end
    end
end