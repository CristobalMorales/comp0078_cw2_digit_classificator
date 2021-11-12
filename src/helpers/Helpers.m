classdef Helpers

    methods (Static)
        function [labels] = bynarize_labels(labels_, class_)
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
            obj_b = eval(class(obj_a));  %create default object of the same class as a. one valid use of eval
            for p =  properties(obj_a).'  %copy all public properties
                try   %may fail if property is read-only
                    obj_b.(p{1}) = obj_a.(p{1});
                catch
                    warning('failed to copy property: %s', p);
                end
            end
        end
    end
end