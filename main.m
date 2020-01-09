%% test  fs=16kHZ
clear all
close all
[montage1,fs]=audioread('montage2.wav');
% sound(montage1,fs)
montage1=montage1(:,1);
figure(1)
plot(montage1);
% ����0��15���ʱ����
% figure(2)
% N=(12*fs):(16*fs);
% % ��һ��
% 
% 
% 
% plot(N/fs,montage1(N));
% plot(N, montage1(N))
% axis([13 28 -1 1]);
title('ԭʼ��Ƶ�ź�');
xlabel('ʱ�����к�'); ylabel('����');
% load train;
% fs=Fs;
% figure(1)
% N=(0*fs):(3*fs);
% plot(N/fs,y(N));
% axis([10 15 -1 1]);
% N=1:length(y);
% plot(N/fs,y(N));
% title('ԭʼ��Ƶ�ź�');
% xlabel('ʱ�䣨s��'); ylabel('����');
%% ��Ƶ��֡��Ӵ�
framelen=32e-3*fs; %֡���ʹ���Ϊ32ms,512����
frameinc=16e-3*fs; %֡��Ϊ16ms
window=hamming(framelen);  %ѡȡ������
x=enframe(montage1,window,frameinc);
% figure(3);
% plot(x(1000, :));
% x=enframe(y,window,frameinc);
%% ��⾲����
[S,k]=unvad(x,0.8,1,fs);
% figure(2)
% plot(S)

%% ��ȡ�����θ�֡��MFCC-GLDS����
H=MFCC(S);

%% �������ϵ������
terror=64e-3; % �������̵����λ���
w=floor(terror/16e-3); % ���Ļ�������
R=correlation(H,w);
figure(4)
plot(R);
title('���ϵ������');
% axis([0 80 -0.2 1]);
%% ��ֵ�ж�
Q=distort(R,0.6,3.6);
if isempty(Q)
    disp('�����ڴ۸�');
else 
    S_distort=[];
    disp('���ڴ۸�');
    for i=1:length(Q)
        S_distort= [S_distort Q(i)*w];
    end
    t_distort=k(S_distort)*256;tt=0.8*ones(1,length(t_distort));
    figure(5)
    plot(montage1);
    hold on 
    stem(t_distort,tt);
    title('ƴ�Ӽ�ⶨλ');
end




