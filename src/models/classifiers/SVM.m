classdef SVM < BinaryClassifier

    properties
        alphas = []
        %% Deprecated
        class = ''
    end

    methods

        function [obj] = SVM()
        end

        function [alphas] = get_alphas(obj)
            alphas = obj.alphas;
        end

        function [obj] = init_weigths(obj, labels_)
            obj.weights = zeros(1, length(labels_));
        end

        function [obj] = train(obj, kernel_, labels_)
            output = sign(obj.get_weights());
            alpha = (output~=labels_).*labels_;

            obj.weights = obj.weights + alpha*kernel_;
            obj.alphas = [obj.alphas; alpha];
        end

        function [output] = get_output(obj, ~)
            output = sign(obj.get_weights());
        end

        function [alpha] = correct(obj, output_)
            alpha = (output_~=obj.get_labels()).*obj.get_labels();
        end

        function [error] = compute_error(obj, labels_)
            mistakes = sum(sign(obj.weights)~=labels_);
            error = mistakes/length(labels_);
        end
    end
end