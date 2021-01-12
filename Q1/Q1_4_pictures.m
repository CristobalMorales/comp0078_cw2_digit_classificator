for i = 1:10
    notDetected = worstDetections(num2str(i));% testSet((find(sum(badDet(:,:,i)))),:);
    % Falta por agregar el que encuentre la moda de los errores para
    % graficar los mas dificiles de clasificar
    [num, ~] = size(notDetected);
    figure;
    for j = 1:num
        picture = reshape(notDetected(j,:)', 16, 16)';
        subplot(1,num,j); imshow(picture);
    end
end

confusion = string(zeros(10,10));
for i = 1:10
    for j = 1:10
    confusionMean = string(mean(confusionMatrices(i,j,:)));
    confusionStd = string(std(confusionMatrices(i,j,:)));
    confusion(i,j) = confusionMean + " +- " + confusionStd;
    end
end