function []=densitySituation(data)
hard=data(1:30,:);
gentle=data(31:60,:);
num=30;
total=pdist2(hard,hard);
avg1 = sum(total(:))/(num*(num-1));
fprintf('hard��%f  \t',avg1);
total=pdist2(gentle,gentle);
avg2 = sum(total(:))/(num*(num-1));
fprintf('gentle��%f \t',avg2);
fprintf('GENTLE-HARD: %f \t',abs(avg2-avg1));
total=pdist2(gentle,hard);
avg = sum(total(:))/(num*num);
fprintf('gentle to hard��%f \t',avg);

num=60;
total=pdist2(data,data);
avg = sum(total(:))/(num*(num-1));
fprintf('avg��%f \t',avg);
threshold=sum(total(:))/(num*(num-1)) - std(total(total~=0));
fprintf('threshold��%f  \n',threshold);
end