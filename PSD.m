function [ output ] = PSD( input,fs )
%UNTITLED inputΪ�źţ�lenΪ�źų���fsΪ����Ƶ��
len = size(input, 2);
ff = fft(input',len)';
ff = abs(ff(:, 1:len / 2 + 1));
X=ff.*ff./(fs*len);
Y=10*log10(X);
% output=premnmx(Y);
output=Y;
% output=mapminmax(Y);%��һ����-1-1
end