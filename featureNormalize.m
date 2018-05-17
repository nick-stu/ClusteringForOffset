function [X_norm] = featureNormalize(X)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   the mean value of each feature is 0 and the standard deviation
%   is 1. This is often a good preprocessing step to do when
%   working with learning algorithms.

% ע�⣺ �����X��һ��m * n�ľ��� �� m �������� ÿ���������� n �������� ÿһ�б�ʾһ��������
% X_norm�����յõ��������� ���ȼ���������ѵ������ÿ�������ľ�ֵ�� Ȼ���ȥ��ֵ�� Ȼ����Ա�׼� 
% ps����һ�β�����������ķ���
mu = mean(X);
X_norm = bsxfun(@minus, X, mu);

sigma = std(X_norm);
X_norm = bsxfun(@rdivide, X_norm, sigma);
% X_norm(X_norm>=3)=0;
% X_norm(X_norm<=-3)=0;
end