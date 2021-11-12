clear all;
clc;
combo_set_table = readtable('zipcombo.dat');
combo_set_complete = table2array(combo_set_table);
clear combo_set_table;
combo_set_data = combo_set_complete(:, 2:end);
combo_set_labels = combo_set_complete(:, 1);
clear combo_set_complete;