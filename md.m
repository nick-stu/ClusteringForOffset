function[result]=md(data)
% �ú�����������������ƽ����
M=mean(data);
data=data-M;
data=abs(data);
result=mean(data(:));
end