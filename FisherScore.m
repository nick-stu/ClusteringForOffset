function [ FisherScore ] = FisherScore( input,WeiShu,YangBenShu,LeiShu )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
    %��������
    Originaldata=input;
    EveryYangBenShu=YangBenShu/LeiShu;%ÿһ����������Ŀ
    
    %����ÿһάÿһ���ƽ��ֵ
    everyClassAverage = zeros(WeiShu,LeiShu);
    sum = 0;
    for i =1:WeiShu
        for j = 1:YangBenShu
            sum = sum + Originaldata(j,i);
            if mod(j,EveryYangBenShu)==0
                everyClassAverage(i,floor((j-1)/EveryYangBenShu+1))=sum/EveryYangBenShu;
                sum=0;
            end
        end
    end

    %����ÿһά����ƽ��ֵ
    allAverage = zeros(WeiShu,1);
    for i =1:WeiShu
        sum=0;
        for j=1:YangBenShu
            sum = sum + Originaldata(j,i);
        end
        allAverage(i,1)=sum/YangBenShu;
    end

    %�������A
    A=zeros(WeiShu,1);
    for i=1:WeiShu
        for j=1:LeiShu
            A(i,1)=A(i,1)+(everyClassAverage(i,j)-allAverage(i,1))*(everyClassAverage(i,j)-allAverage(i,1));
        end
    end

    %�����ĸB
    B=zeros(WeiShu,1);
    for i=1:WeiShu
        for j=1:YangBenShu
            B(i,1)=B(i,1)+(Originaldata(j,i)-everyClassAverage(i,floor((j-1)/EveryYangBenShu)+1)) * (Originaldata(j,i)-everyClassAverage(i,floor((j-1)/EveryYangBenShu)+1));
        end
    end

    %������F
    FisherScore = zeros(WeiShu,1);
    for i=1:WeiShu
        FisherScore(i,1)=A(i,1)/B(i,1);
    end

end

