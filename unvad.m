function [S,k]=unvad(x,a,b,fs)
% 判断静音段,返回静音帧在原始信号中的帧位置
%将短时频谱能量E平均值的a倍作为能量阈值TE
%取过零率Z平均值的b倍作为过零率阈值TZ
Esum=0; Zsum=0;
for i=1:length(x(:,1))
    Esum=Esum+EI(x(i,:));
    Zsum=Zsum+ZI(x(i,:));
end
TE=a*Esum/length(x);
TZ=b*Zsum/length(x);

%判断静音帧,按帧序连接成静音段
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
%画出前两秒检测出的静音帧，检测值为1的是有声帧，检测值为0的是静音帧
figure(2)
% N = length(x);
% n = 1:N/N;
% plot(0:1/length(x):1, x);


N=1:length(x(:,1));
% N=floor(N/256);
stem(N,x(N,1));
title('静音检测');
xlabel('帧序号');
ylabel('检测值');
    



