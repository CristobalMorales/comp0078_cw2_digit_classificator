classdef GaussianKernel < Kernel
    properties
    end
    methods

        function [obj] = compute(obj, data_, sec_data_)
            obj = obj.init_kernel(data_);
            beta = 1/(2*obj.r^2);
            for i = 1:ndata
                col_kernel = exp(-beta*sqrt(sum((data_(:, i:end)' - sec_data_(:, i)').^2, 2)).^2);
                obj.kernel(i, i:end) = col_kernel';
                obj.kernel(i:end, i) = col_kernel;
            end
        end
    end
end