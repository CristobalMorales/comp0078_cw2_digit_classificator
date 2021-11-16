classdef Kernel
    properties
        kernel = ones(1,1)
        r = 1
    end
    methods

        function [obj] = Kernel(varargin)
            if length(varargin) == 1
                obj.r = varargin{1};
            end
        end
        
        function [obj] = init_kernel(obj, data_)
            % Initialize the kernel with ones
            % inputs: 
            %       - data_: first set of data
            [~, ndata] = size(data_);
            obj.kernel = ones(ndata, ndata);
        end

        function [obj] = compute(obj, data_, sec_data_)
            % Compute polynomial kernel
            % inputs: 
            %       - data_: first set of data
            %       - sec_data_: second set of data
            obj.kernel = (data_'*sec_data_).^obj.r;
        end

        function [kernel] = get_kernel(obj)
            % Getter for kernel property
            % output: 
            %       - kernel: matrix
            kernel = obj.kernel;
        end
    end
end