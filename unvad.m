function [S,k]=unvad(x,a,b,fs)
% �жϾ�����,���ؾ���֡��ԭʼ�ź��е�֡λ��
%����ʱƵ������Eƽ��ֵ��a����Ϊ������ֵTE
%ȡ������Zƽ��ֵ��b����Ϊ��������ֵTZ
Esum=0; Zsum=0;
for i=1:length(x(:,1))
    Esum=Esum+EI(x(i,:));
    Zsum=Zsum+ZI(x(i,:));
end
TE=a*Esum/length(x);
TZ=b*Zsum/length(x);

%�жϾ���֡,��֡�����ӳɾ�����
i=1;slience=ones(length(x),32e-3*fs);k=[];
for j=1:length(x(:,1))
    if EI(x(j,:))<TE&&ZI(x(j,:))<TZ
        slience(i,:)=x(j,:);
        i=i+1;
        k=[k j];
        x(j,:)=0;
    else x(j,:)=1;
    end
end
S=slience((1:i-1),:);
%����ǰ��������ľ���֡�����ֵΪ1��������֡�����ֵΪ0���Ǿ���֡
figure(2)
% N = length(x);
% n = 1:N/N;
% plot(0:1/length(x):1, x);


N=1:length(x(:,1));
% N=floor(N/256);
stem(N,x(N,1));
title('�������');
xlabel('֡���');
ylabel('���ֵ');
    



