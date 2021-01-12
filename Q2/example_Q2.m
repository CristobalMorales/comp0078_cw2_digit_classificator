
count = zeros(1000,100);
for mDim = 1:100
    display(mDim);
    for i = 1:100
        display("Iteration N: " + num2str(i));
        for nData = 1:1000
            randNum = rand(nData, mDim);
            dataSet = ((randNum*2 - 1) >= 0) + (((randNum*2 - 1) < 0)*(-1));
            dataLabels = dataSet(:,1);

            nTestData = 100;
            randNum = rand(nTestData, mDim);
            testDataSet = ((randNum*2 - 1) >= 0) + (((randNum*2 - 1) < 0)*(-1));
            testDataLabels = testDataSet(:,1);
            
            onlineTraining = OnlineTraining(0.0001, 1000);
            
            knn = KNN(dataSet(1,:), 1);
            knn = knn.binaryLabels(dataLabels);
            knn = onlineTraining.train(knn, dataSet');
            
            testSetResults = knn.getOutput(testDataSet');
            testSetNoDetections = (testDataLabels ~= testSetResults');
            error = sum(testSetNoDetections)/length(testSetNoDetections);
            if error < 0.1
                count(nData, mDim) = count(nData, mDim)  + 1;
                break;
            end
        end
    end
end

perceptron = Perceptron(dataSet(1,:));
perceptron = perceptron.binaryLabels(dataLabels);
perceptron = onlineTraining.train(perceptron, dataSet');

leastSquare = LeastSquare(dataSet(1,:));
leastSquare = leastSquare.binaryLabels(dataLabels);
leastSquare = onlineTraining.train(leastSquare, dataSet');

winnow = Winnow(trainSet(1,:));
winnow = winnow.binaryLabels(trainLabels);
winnow = onlineTraining.train(winnow, trainSet');

