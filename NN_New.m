function [accuracy, net ] = NN_New( trainData, testData, testLabel )
% ʹ��������

% ����ѵ����ǩ
[trainLabel,tag] = getLabelsNew(trainData);

trainData = featureNormalize(trainData);
testData = featureNormalize(testData);
%%  Sample Disorder
% rows = size(trainData,1);
% index = randperm(rows,rows);
% trainData = trainData(index,:);
% trainLabel = trainLabel(index,:);
%% ѵ������
net = NNTrainNew(trainData, trainLabel,size(tag,2));
% fprintf("please\n");
% pause;
% ����
Y = sim( net , testData' );

% ͳ��ʶ����ȷ��
validNum = 0;
correctNum = 0;
s = size(Y, 2);
for i = 1 : s
    [m , index] = max(Y( : , i));
    if m > 0
        index=tag(index);
        validNum = validNum + 1;
        if((size(testLabel, 2) == 9 && testLabel(i, index) == 1))% || index  == testLabel(i))
            correctNum = correctNum + 1 ; 
        end
    else
        disp('--------------Invalid--------------');
        pause;
    end
end
accuracy=correctNum / validNum;
fprintf('%.4f\n',accuracy);
% fprintf('%d/%d\n', correctNum , validNum);