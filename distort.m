function Q = distort(R,k1,k2)
% ��ֵ�ж�
% �жϹ��������ϵ������R�У�С����ֵTp��Ԫ��Ԥʾ������λ�ô��ڴ۸�
% �����ϵ��һ�ײ������R_diff�У�������ֵTp_diff��Ԫ��Ԥʾ������λ�ô��ڴ۸�

Tp=k1*mean(R); % С����ֵTpԤʾ�Ŵ۸�
R_diff=zeros(length(R)-1,1);
for i=1:(length(R)-1)
    R_diff(i)=R(i+1)-R(i);
end
Tp_diff=k2*mean(abs(R_diff));% ������ֵTp'Ԥʾ�Ŵ۸�
Q=[];
for i=1:(length(R)-1)
    if R(i)<Tp&&abs(R_diff(i))>Tp_diff
        Q=[Q,i];
    end
end


    