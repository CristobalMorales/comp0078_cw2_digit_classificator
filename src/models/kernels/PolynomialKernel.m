classdef PolynomialKernel < Kernel
    properties
    end
    methods
        function [obj] = compute(obj, data_, sec_data_)
            obj.kernel = (data_'*sec_data_).^obj.r;
        end
    end
end