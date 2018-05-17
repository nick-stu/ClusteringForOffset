function[ mdl ] = k_means( data,k )
    [num,~]=size(data);
    initial=randperm(num,k);% ���ȡ����������Ϊ��ʼ��ֵ����
    avg=data(initial,:);
    labels=repmat(-1,[1,num]);
    % ���� ------------------------------------------------
    for p=1:1000
        % ����
        for i=1:num
           D=pdist2(data(i,:),avg);
           [~,index]=min(D);
           labels(i)=index;
        end
        % ����
        tmp=avg;
        for i=1:k
            classIndex=find(labels==i);
            classData=data(classIndex,:);
            avg(i,:)=mean(classData);
        end
        if isequal(tmp,avg)
            break
        end
    end
    
    classNum=0;
    for i=1:k
       index=find(labels==i);
       if index>0
           classNum=classNum+1;
           labels(index)=classNum;
       end
    end
	mdl.classNum=classNum;
    mdl.label=labels;
    mdl.data=data;
end