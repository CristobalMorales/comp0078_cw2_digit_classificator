classdef OutcomeHandler

    properties
        test_results = []
        test_labels = []
        class = []
    end

    methods

        function [obj] = OutcomeHandler(class_)
            obj.class = class_;
        end

        function [obj] = add_results(obj, test_results_, test_labels_)
            obj.test_results = test_results_;
            obj.test_labels = test_labels_;
        end

        function [test_results] = get_test_results(obj)
            test_results = obj.test_results;
        end

        function [test_labels] = get_test_labels(obj)
            test_labels = obj.test_labels;
        end
    end
end