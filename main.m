%% test  fs=16kHZ
clear all
close all
[montage1,fs]=audioread('montage2.wav');
% sound(montage1,fs)
montage1=montage1(:,1);
figure(1)
plot(montage1);
% 画出0到15秒的时域波形
% figure(2)
% N=(12*fs):(16*fs);
% % 归一化
% 
% 
% 
% plot(N/fs,montage1(N));
% plot(N, montage1(N))
% axis([13 28 -1 1]);
title('原始音频信号');
xlabel('时间序列号'); ylabel('幅度');
% load train;
% fs=Fs;
% figure(1)
% N=(0*fs):(3*fs);
% plot(N/fs,y(N));
% axis([10 15 -1 1]);
% N=1:length(y);
% plot(N/fs,y(N));
% title('原始音频信号');
% xlabel('时间（s）'); ylabel('幅度');
%% 音频分帧与加窗
framelen=32e-3*fs; %帧长和窗长为32ms,512个点
frameinc=16e-3*fs; %帧移为16ms
window=hamming(framelen);  %选取汉明窗
x=enframe(montage1,window,frameinc);
% figure(3);
% plot(x(1000, :));
% x=enframe(y,window,frameinc);
%% 检测静音段
[S,k]=unvad(x,0.8,1,fs);
% figure(2)
% plot(S)

%% 提取静音段各帧的MFCC-GLDS特征
H=MFCC(S);

%% 计算相关系数向量
terror=64e-3; % 所能容忍的最大定位误差
w=floor(terror/16e-3); % 窗的滑动距离
R=correlation(H,w);
figure(4)
plot(R);
title('相关系数向量');
% axis([0 80 -0.2 1]);
%% 阈值判断
Q=distort(R,0.6,3.6);
if isempty(Q)
    disp('不存在篡改');
else 
    S_distort=[];
    disp('存在篡改');
    for i=1:length(Q)
        S_distort= [S_distort Q(i)*w];
    end
    t_distort=k(S_distort)*256;tt=0.8*ones(1,length(t_distort));
    figure(5)
    plot(montage1);
    hold on 
    stem(t_distort,tt);
    title('拼接检测定位');
end




