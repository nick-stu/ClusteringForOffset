function [ mdl ] = clusteringDebug( data ,isPlot)
% mdl.data: �����ѵ������
% mdl.label: �����ѵ�������ķ���
% mdl.classNum: ������γɵ��������
% ��Ѽ���������������
% ��ֵ�ж�Ϊ�����ǰ���ƽ������
    a=rand; b=rand; c=rand;
    MDSData=mdsPlotDebug(data,3);hold on;
% 	PCAData=pcaPlotDebug(data,3);
    mdl.data = data;
    num = size(data, 1);
    label = zeros(1, num);
    pre_index = zeros(1, num); % �����ǩ�����ݵĶ�Ӧ��ϵ,����������Ϊ�ڼ�����ѡ��
    dis = zeros(1, num);
    p_label = 1:num; % data��־����
    [avgTotal,std]=classStatus(data);
    threshold = avgTotal-std; % ������ƽ������
    mergeThreshold = threshold*1;
%     fprintf('threshold: %s ',threshold);
    %% �ҳ�����������С��������
    D = pdist2(data, data);
    D(D == 0) = Inf;
    [d, i] = min(D);
    [~, index] = min(d);
    
    index = i(index);
    % ���������е�����һ�����뵽 finded ������
    finded = data(index, :);
    data(index, :) = []; % ��data����ȥ��������
    pre_index(index) = 1; % ����������Ϊ�ڼ���ѡ��
    p_label(index) = []; % ��������Ĩ��

    class_label=zeros(1, num);% ��ʾ�ڼ�����������һ��
    class_label(index)=1;
    %% ����, �� ��ǰ�� �еĵ���ʣ�������������룬�ҳ���С���룬�������Ҳ���뵽 ���� �㼯��
    classFlag=1;
    dis(1)=0;
    label(1)=1;
    scatter3(MDSData(p_label(index),1),MDSData(p_label(index),2),MDSData(p_label(index),3),150,[a b c],'filled');hold on;
%     scatter3(PCAData(p_label(index),1),PCAData(p_label(index),2),PCAData(p_label(index),3),150,[a b c],'filled');hold on;
    DMat=[];
    for i=2:num
        min_d = Inf;
        cursor = find(class_label==classFlag);
        for j=1:size(data, 1)% Ѱ�������������м��ĵ�
%           d = nearestPoint(data(j, :), mdl.data(cursor,:));
            d = distanceChange(data(j, :), mdl.data(cursor,:));% ע��d��avg���ܴ��ڵ�����
            if d < min_d
                min_d = d;
                min_i = j;
            end
        end
        %%
        D=densityBasedonNeighbor(mdl.data(cursor,:),data(min_i, :),6);
        DMat=[DMat D];
%%
        [avg,~]=classStatus([mdl.data(cursor,:);data(min_i, :)]);
     
        dis(i) = avg;
        if avg <= threshold || (size(cursor,2)<=5)
            class_label(p_label(min_i))=classFlag;
            label(i)=label(i-1);
            scatter3(MDSData(p_label(min_i),1),MDSData(p_label(min_i),2),MDSData(p_label(min_i),3),150,[a b c],'filled');
%             scatter3(PCAData(p_label(min_i),1),PCAData(p_label(min_i),2),PCAData(p_label(min_i),3),150,[a b c],'filled');
        else
            a=rand; b=rand; c=rand;
            classFlag=classFlag+1;
            class_label(p_label(min_i))=classFlag;
            label(i)=classFlag;
            scatter3(MDSData(p_label(min_i),1),MDSData(p_label(min_i),2),MDSData(p_label(min_i),3),150,[a b c],'filled');
%             scatter3(PCAData(p_label(min_i),1),PCAData(p_label(min_i),2),PCAData(p_label(min_i),3),150,[a b c],'filled');
        end
        finded = [finded; data(min_i, :)];
        data(min_i, :) = [];
        pre_index(p_label(min_i)) = i;
        p_label(min_i) = [];
    end
    %% 
    classNum=max(class_label);
    if isPlot==true
        figure;
        plot(dis);
        title('δ���кϲ�������ǰ�����������ƽ������������������');
        hold on;
        plot([0, num + 1], [threshold, threshold]);
        xlim([0, num + 1]);
        % plot label
        for i=1:num
            text(i, dis(i), num2str(label(i)));
        end
    end
    data = finded;
    %% �ϲ�������
    for i=1:classNum
        index = find(label == i);
        if size(index, 2) == 0
            continue
        end
        
        data1 = data(index, :); % ���ڸ�������
        min_d = Inf;
        min_j = 0;
        for j=1:classNum
            if i == j
                continue
            end
            index = find(label == j); % ��һ�����
            if size(index, 2) < size(data1, 1) % ���Ǹ����࣬���������
                continue
            end
            data2 = data(index, :); % ���������
            d = nearestPoint(data1,data2);
            if d < min_d
                min_d = d;
                min_j = j;
            end
        end
        
        if min_j == 0
            continue;
        end
        
        tmp=[data1;data(find(label == min_j), :)];
        [densityMin,~]=classStatus(tmp);
        if densityMin < mergeThreshold || size(data1,1)<=5
            label(label == i) = min_j;
        end
    end    
    %% �ָ����ںϲ��ർ�µ� label ������
    maxClassNum = max(label);
    classNum = 0;
    for i=1:maxClassNum
        index = find(label == i);
        if size(index, 2) > 0
            classNum = classNum + 1;
            label(index) = classNum;
        end
    end

    %% ��ͼ���·����׼ȷ��
    dis(1) = dis(2);
    if isPlot==true
        figure;
        plot(dis);
        title("�ϲ���֮���ƽ���������������������");
        hold on;
        plot([0, num + 1], [threshold, threshold]);
        xlim([0, num + 1]);
        % plot label
        for i=1:num
            text(i, dis(i), num2str(label(i)));
        end
    end
    %% �ָ���ǩ�� data �Ķ�Ӧ��ϵ
    label = label(pre_index);
    mdl.label = label;
    mdl.classNum = classNum;
%     fprintf('%d\n',classNum);
end