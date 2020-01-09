function Q = distort(R,k1,k2)
% 阈值判断
% 判断规则：在相关系数向量R中，小于阈值Tp的元素预示着所在位置存在篡改
% 在相关系数一阶差分向量R_diff中，大于阈值Tp_diff的元素预示着所在位置存在篡改

Tp=k1*mean(R); % 小于阈值Tp预示着篡改
R_diff=zeros(length(R)-1,1);
for i=1:(length(R)-1)
    R_diff(i)=R(i+1)-R(i);
end
Tp_diff=k2*mean(abs(R_diff));% 大于阈值Tp'预示着篡改
Q=[];
for i=1:(length(R)-1)
    if R(i)<Tp&&abs(R_diff(i))>Tp_diff
        Q=[Q,i];
    end
end


    