function[B]= CalcAccuracy(trainData,testData,testLabel,trainLabel,tag)
%% ѵ������
verifyNet = NNTrainNew(trainData, trainLabel,size(tag,2));
%% ����
Y = sim( verifyNet , testData' );

%% ͳ��ʶ����ȷ��
validNum = 0;
correctNum = 0;
s = size(Y, 2);
for i = 1 : s
    [m , index] = max(Y( : , i));
    if m > 0
        index=tag(index);
        validNum = validNum + 1;
        if((size(testLabel, 2) == 9 && testLabel(i, index) == 1))
            correctNum = correctNum + 1 ; 
        end
    else
        disp('--------------invalid--------------');
    end
end
B=correctNum / validNum;
% fprintf('NN_New: %.4f', B);
% fprintf('  %d/%d\n', correctNum , validNum);
end