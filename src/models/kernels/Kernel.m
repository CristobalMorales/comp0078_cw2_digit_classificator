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
            [~, ndata] = size(data_);
            obj.kernel = ones(ndata, ndata);
        end

        function [obj] = compute(obj, data_, sec_data_)
            obj.kernel = (data_'*data_).^obj.r;
        end

        function [kernel] = get_kernel(obj)
            kernel = obj.kernel;
        end
    end
end