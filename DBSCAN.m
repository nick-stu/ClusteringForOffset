function[mdl]=DBSCAN(data)
% һ�ֻ��ڸ��ܶ���ͨ����Ļ����ܶȵľ����㷨
% 
    [num,~]=size(data);
    [E,~]=classStatus(data);
    E=E;
    MinPts=100;
    
    label=zeros(1,num);
    classNum=0;
    unvisited=1:num;% ������ж���Ϊδ����
    while ~isempty(unvisited)
        p_num=randperm(size(unvisited,2),1);
        p=unvisited(p_num); % ���ѡ��һ��δ���ʵ�Ϊ���ʶ���
        unvisited(p_num)=[]; % ���pΪ�ѷ���
        
        pts=neighbor(data,num,p,E);
        if size(pts,2)>=MinPts
            classNum=classNum+1;
            label(p)=classNum;
            while ~isempty(pts)
                pt_num=pts(1);
                pts(1)=[];
                if any(unvisited==pt_num) % ���pt_numδ����
                    unvisited(find(unvisited==pt_num))=[]; % ���Ϊ����
                    pts_in=neighbor(data,num,pt_num,E);
                    if size(pts_in,2)>=MinPts
                        pts=[pts pts_in]; % ���µ���ӵ�pts��
                    end
                end
                if label(pt_num)==0
                    label(pt_num)=classNum;
                end
            end%    end while
        
        else 
            fprintf('%d.',p);
        end
    end% end while
    mdl.label=label;
    mdl.classNum=classNum;
    
    figure;
    scatter(1:num,label,'k'); 
    ylim([0,classNum+1]);
end