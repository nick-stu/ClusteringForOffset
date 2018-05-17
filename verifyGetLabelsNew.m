function[verifyTrainLabel,verifyTag,verifyTrainData]=verifyGetLabelsNew(trainData)
    rows = size(trainData, 1);
    singleNum = rows / 9; % ԭѵ������ÿ����λ��������
    tag=[]; % ��λ--���Ӧ��ǩ
    trainLabelTmp=[];
    verifyTrainData=[];
    verifyTrainLabel=[];
    numLabel=[]; % ��������
    classNumLabel=[]; % ��λ����
    innerOrder=[]; % ��λ�ھ������
    for i = 1:9
        %%
        mdl=clustering_offset_nearest( trainData( (i-1)*singleNum+1 : i*singleNum,:),false );
        for j=1:mdl.classNum
            numLabel=[numLabel length(find(mdl.label==j))];
        end
        
        tag=[tag repmat(i,[1,mdl.classNum])];
        innerOrder=[innerOrder 1:mdl.classNum];
        trainLabelTmp=[trainLabelTmp;mdl.label];
        classNumLabel=[classNumLabel mdl.classNum];
    end

    %% findMIN
    minclass=min(classNumLabel); % ��λ����С������
    if minclass==1
        error('�������,���ʺ���֤');
    end
    %% ���������������ҳ�����sampleNum�����������м�λ�еĶ����ٴ���minclass���������������sampleNum
    sampleNumMat=[];
    for i=1:9
        index=find(tag==i);
        tmp=numLabel(index);
        tmp=sort(tmp,'descend'); % ����Ϊdescend����Ϊ������Ҫѡ��������С
        sampleNumMat=[sampleNumMat tmp(1:minclass)];
    end
    sampleNum=min(sampleNumMat);
    fprintf('minclass:%d sampleNum: %d\n',minclass,sampleNum);
    %% ��ÿ����λ�н���ѡ���������
    %% ѡ���кα�׼����������
    lectMat=zeros(9,max(classNumLabel)); % ��Ӧ��λ����ѡ�е��࣬���Ϊ��λ�������
    flagMat=ones(1,9)*(-1)*minclass;
    for i=1:length(numLabel)
        if numLabel(i)>=sampleNum 
            if flagMat( tag(i) )<0
                flagMat( tag(i) )=flagMat( tag(i) )+1;
                lectMat( tag(i),innerOrder(i) )=1;
            end
        end
    end
    %% �ȷ�ѡ����ѵ��������ѵ����ǩ
    verifyTag=[];
    cursor=0;
    for i = 1:9
        tmpLabel=trainLabelTmp(i,:);
        trainDataTmp=trainData( (i-1)*singleNum+1 : i*singleNum,:);
        outindex=find(lectMat(i,:)==1); % �ü�λ��ѡ�е���
        for j=1:minclass
            %% ���ñ�ǩ
            label=zeros(sampleNum ,minclass*9);
            label(:,cursor+j)=1;
            innerClassNum=outindex(j); % ����ļ�λ�����
            index=find(tmpLabel==innerClassNum); % ����ı�ǩ
            %% ���ȡsampleNum����
            delMat=randperm(length(index),length(index)-sampleNum);
            index(delMat)=[];
            verifyTrainData=[verifyTrainData ; trainDataTmp(index,:)];
            verifyTrainLabel=[verifyTrainLabel;label];
        end
        cursor=cursor+minclass;
        verifyTag=[verifyTag repmat(i,[1,minclass])];
    end
    %----------------------------------------------------------------------------- ��֤һ���Ƿ������ȷ
    %% partialTrainData
%     partialTrainData=[];
%     for i=1:9
%         partialTrainData=[partialTrainData;
%             verifyTrainData( (i-1)*(sampleNum*minclass)+1 : (i-1)*(sampleNum*minclass)+sampleNum ,:)];
%     end
    %% randomCluster
%     fprintf('randomCluster \n');
%     for i=1:9
%        randomTmp=verifyTrainData( (i-1)*(sampleNum*minclass)+1 : i*(sampleNum*minclass) ,:); 
%        randomSq=randperm((sampleNum*minclass),(sampleNum*minclass));
%        randomTmp=randomTmp(randomSq,:);
%        verifyTrainData( (i-1)*(sampleNum*minclass)+1 : i*(sampleNum*minclass) ,:)=randomTmp;
%     end
end