classdef SVM < BinaryClassifier

    properties
        alphas = []
    end

    methods

        function [obj] = SVM()
        end

        function [obj] = init_weigths(obj, labels_)
            % Initialize the weights with an full of zeros array
            % inputs:
            %       - labels_: labels for training set
            obj.weights = zeros(1, length(labels_));
        end

        function [obj] = train(obj, kernel_, labels_)
            % Initialize the weights with an full of zeros array
            % inputs:
            %       - kernel_: kernel for training
            %       - labels_: labels for training set
            output = sign(obj.get_weights());
            alpha = (output~=labels_).*labels_;

            obj.weights = obj.weights + alpha*kernel_;
            obj.alphas = [obj.alphas; alpha];
        end
        
        function [error] = compute_error(obj, labels_)
            % Compute the error comparing with the labels
            % inputs: 
            %       - labels_: array of labels
            mistakes = sum(sign(obj.weights)~=labels_);
            error = mistakes/length(labels_);
        end

        %% Getters
        function [output] = get_output(obj, data)
            % Obtain the output
            % outputs:
            %       - output: output of the svm
            output = sum(obj.get_alphas()*data);
        end
                
        function [alphas] = get_alphas(obj)
            % Obtain the alphas that are the training history of the
            % classifier
            % outputs:
            %       - alphas: the training gradients
            alphas = obj.alphas;
        end
    end
end