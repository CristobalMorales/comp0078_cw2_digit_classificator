clear all;
clc;
combo_set_table = readtable('zipcombo.dat');
combo_set_complete = table2array(combo_set_table);
clear combo_set_table;
combo_set_data = combo_set_complete(:, 2:end);
combo_set_labels = combo_set_complete(:, 1);
clear combo_set_complete;

metrics = {'spec_sen'};
classes = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'};
max_iter = 100;
r = 2;
train_percentage = 0.8;

kernel = PolynomialKernel(r);
data_handler = DataSetManager(combo_set_labels, combo_set_data, kernel);
metric_manager = ClassifierMetricManager();
classifier_handler = MultiClassifierHandler(max_iter, classes, data_handler, metrics);
classifier_handler = classifier_handler.init_models();
classifier_handler = classifier_handler.parse_dataset(train_percentage);
classifier_handler = classifier_handler.train_model();
classifier_handler = classifier_handler.test_model();
classifier_handler = classifier_handler.get_results(metric_manager);