
dataCounter = [];
for i = 1:10
    [nData, ~] = size(worstDetections(num2str(i)));
    validated = zeros(1, nData);
    data = worstDetections(num2str(i));
    for d = 1:nData
        count = 0;
        if validated(1,d) == 0
            dataCounter = [dataCounter; data(d,:) 0];
            for d_1 = d:nData
                if validated(1, d_1) == 0 && sum(data(d_1,:) == data(d,:))/256 == 1
                    dataCounter(end,end) = dataCounter(end,end) + 1;
                    validated(1, d_1) = 1;
                end
            end
        end
    end
end

for i =1:length(zipcombo(:,1))
    if sum(zipcombo(i,2:257) == dataCounter(179,1:256)) > 255
        display(zipcombo(i,1));
    end
end

figure
picture = reshape(dataCounter(36,1:256)', 16, 16)';
subplot(1,5,1);
imshow(picture);
title("Label: 2")
picture = reshape(dataCounter(132,1:256)', 16, 16)';
subplot(1,5,2);
imshow(picture);
title("Label: 4")
picture = reshape(dataCounter(264,1:256)', 16, 16)';
subplot(1,5,3);
imshow(picture);
title("Label: 7")
picture = reshape(dataCounter(23,1:256)', 16, 16)';
subplot(1,5,4);
imshow(picture);
title("Label: 1")
picture = reshape(dataCounter(179,1:256)', 16, 16)';
subplot(1,5,5);
imshow(picture);
title("Label: 5")