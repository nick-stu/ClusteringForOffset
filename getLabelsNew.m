function[trainLabel,tag]=getLabelsNew(trainData)
%% ע���������õľ��ຯ�����Ƽǵø�
%% �˹�����
%     rows = size(trainData, 1);
%     singleNum = rows / 9;
%     tag=[]; trainLabel=[];
%     cursor=0;
%     for i = 1:9
%         mdl.label=[ones(1,20)*1  ones(1,20)*2 ones(1,20)*3 ones(1,20)*4 ones(1,20)*5];
%         %% �ƻ��˹���
% %         index=randperm(length(mdl.label),5);
% %         mdl.label(index)=1;
% %         index=randperm(length(mdl.label),5);
% %         mdl.label(index)=2;
% %         index=randperm(length(mdl.label),5);
% %         mdl.label(index)=3;
% %         index=randperm(length(mdl.label),5);
% %         mdl.label(index)=4;
% %         index=randperm(length(mdl.label),5);
% %         mdl.label(index)=5;
% %         % �鿴�ƻ���
% %         D = length(mdl.label) - length( find(mdl.label-[ones(1,20)*1  ones(1,20)*2 ones(1,20)*3 ones(1,20)*4 ones(1,20)*5] == 0) );
% %         fprintf("---%d\n",D);
%         %%
%         label=zeros(singleNum,rows);
%         for j=1:singleNum
%             label(j,mdl.label(j)+cursor)=1; 
%         end
%         cursor=cursor+5;
%         tag=[tag repmat(i,[1,5])];
%         trainLabel=[trainLabel;label];
%     end
%     trainLabel(:, find( sum(trainLabel,1)==0) )=[];
%     fprintf('classNum:%d\t',size(tag,2));
%%
    rows = size(trainData, 1);
    singleNum = rows / 9;
    tag=[]; trainLabel=[];
    cursor=0;
    for i = 1:9
%         mdl=clustering_dis_offset( trainData( (i-1)*singleNum+1 : i*singleNum,:),false );
%         mdl=clustering( trainData( (i-1)*singleNum+1 : i*singleNum,:) ,false);
%         mdl=k_means(trainData( (i-1)*singleNum+1 : i*singleNum,:),5);
        mdl=clustering_offset_nearest( trainData( (i-1)*singleNum+1 : i*singleNum,:),false );
        label=zeros(singleNum,rows);
        for j=1:singleNum
            label(j,mdl.label(j)+cursor)=1; 
        end
        cursor=cursor+mdl.classNum;
        tag=[tag repmat(i,[1,mdl.classNum])];
        trainLabel=[trainLabel;label];
    end
    trainLabel(:, find( sum(trainLabel,1)==0) )=[];
    fprintf('classNum:%d\t',size(tag,2));
end