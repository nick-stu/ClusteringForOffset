function [ mdl ] = clustering_offset_nearest( data ,isPlot)
% mdl.data: �����ѵ������
% mdl.label: �����ѵ�������ķ���
% mdl.classNum: ������γɵ��������
% ��Ѽ���������������
% ��ֵ�ж�Ϊ�����ǰ���ƽ������

    mdl.data = data;
    num = size(data, 1);
    label = zeros(1, num);
    pre_index = zeros(1, num); % �����ǩ�����ݵĶ�Ӧ��ϵ,����������Ϊ�ڼ�����ѡ��
    dis = zeros(1, num);
    p_label = 1:num; % data��־����
    [avgTotal,std]=classStatus(data);
    threshold = avgTotal-std; % ������ƽ������
    mergeThreshold = threshold*1.05;
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
%     DMat=[];
    for i=2:num
        min_d = Inf;
        cursor = find(class_label==classFlag);
        for j=1:size(data, 1)% Ѱ�������������м��ĵ�
%           d = nearestPoint(data(j, :), mdl.data(cursor,:));
            d = distanceChange(data(j, :), mdl.data(cursor,:));
            if d < min_d
                min_d = d;
                min_i = j;
            end
        end
%         D=densityBasedonNeighbor(mdl.data(cursor,:),data(min_i, :),5);
%         DMat=[DMat D];
        
        [avg,~]=classStatus([mdl.data(cursor,:);data(min_i, :)]);
        
        dis(i) = avg;
        if avg <= threshold % ���ﲻ�����õ�����Сʱ����������
            class_label(p_label(min_i))=classFlag;
            label(i)=label(i-1);
        else
            classFlag=classFlag+1;
            class_label(p_label(min_i))=classFlag;
            label(i)=classFlag;
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
            if size(index, 2) < size(data1, 1) % �����Ǹ����࣬������
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
%         fprintf('%.4f\n',densityMin);
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
     %% ����ƽ����
% %     fprintf('%d %d\n',size(mdl.data, 1),classNum);% ��ӡ��������������
%     sampleNum=floor( size(mdl.data, 1)/classNum );% ����ƽ����������������ȡ����
%     for i=1:classNum
%         index=find(label==i);
%         inNum=sampleNum-length( index );% ��Ҫ��ӵ�������
% %         fprintf('class %d has %d points. sampleNum is %d.\n',i,length( index ),sampleNum);
%         % ��Ҫ�����Ƶ�С��ĵ��ʲ��ʺ�����࣬�����������֮ǰ�ڴ�����ʲôλ�õ�
%         if inNum<=0 % ��������
%             continue;
%         end
%         smallData=data(index,:); % С������
%         bigClassTag=[]; indexTag=[];
%         bigClassData=[];
%         % ��������
%         for k=1:classNum
%             index=find(label==k);
%             if sampleNum<length( index )
%                 bigClassData=[bigClassData ;data(index,:)];
%                 bigClassTag=[bigClassTag repmat( k,[1,length(index)] )];% ���,����Ϊ�ĸ���
%                 indexTag=[indexTag index];
%             end
%         end    
%         % I����λ��
%         [~,I] = sort ( sum(pdist2(bigClassData,smallData),2) ); % �����ָ����ȡƽ������
%         % ˢ�±��
%         bigClassTag=bigClassTag(I);
%         indexTag=indexTag(I);
%         % �Ӵ�����ȡ�����ʺϵ�inNum����
%         j=1; k=0;
%         while j<=inNum
%             k=k+1;
%             index=find( label== bigClassTag(k) );
%             if length(index)<=sampleNum
%                 continue;
%             end
%             label( indexTag(k) )=i;
%             j=j+1;
%         end
%     end
% %     ���һ��ƽ�����
% %     fprintf('-------------------------------------------------------\n');
%     for i=1:classNum
%         index=find(label==i);
% %         fprintf('class %d has %d points. sampleNum is %d.\n',i,length( index ),sampleNum);
%     end
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
    
    %% remove outcast
%     for i=1:classNum
%         index=find(mdl.label==i);
%         data=mdl.data(index,:);
%         center=mean(data);
%         dis=sum((data-center).^2,2);
%         [B,I]=sort(dis,'descend');
%         rmIndex=index(I(1:3));
%         mdl.data( rmIndex ,:)=[];
%         mdl.label(rmIndex)=[];
%     end
%%
%     fprintf('--%d--',classNum);
end