classdef PolynomialKernel < Kernel
    properties
    end
    methods

        function [obj] = compute(obj, data_, sec_data_)
            % Compute polynomial kernel
            % inputs: 
            %       - data_: first set of data
            %       - sec_data_: second set of data
            obj.kernel = (data_'*sec_data_).^obj.r;
        end
    end
end