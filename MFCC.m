function H=MFCC(S)
%对每一帧计算MFCC特征，不采用预加重，利于提取频谱特征
bank=melbankm(24,512,16000); %Mel滤波器的阶数为24，fft变换的长度为512，采样频率为16000Hz
%归一化mel滤波器组系数
bank=full(bank);
bank=bank/max(bank(:));
for k=1:12			
n=0:23;
dctcoef(k,:)=cos((2*n+1)*k*pi/(2*24));
end
w=1+6*sin(pi*[1:12]./12);%归一化倒谱提升窗口

%计算每帧的传统MFCC参数
for i=1:length(S(:,1))
    s=S(i,:);
	t=abs(fft(s)); %fft快速傅立叶变换
    t=t.^2';
	c1=dctcoef*log(bank*t(1:257)+eps);
c2=c1.*w';
m(i,:)=c2';
c2=m;
end

% %计算MFCC参数的一阶差分
% dtm=zeros(size(m));
% for i=3:size(m,1)-2
%     dtm(i,:) = -2*m(i-2,:) - m(i-1,:) + m(i+1,:) + 2*m(i+2,:);
% end
% dtm = dtm/3;
% %合并mfcc参数和一阶差分参数
% c = [m dtm];
% %去除首尾两帧，因为这两帧一阶差分参数为0
% c2 = c(3:size(m, 1)-2,:);

% 采用GLDS-kernel函数对MFCC特征进行拓展
% 最终得到的是一个二维矩阵H，每列为每帧的拓展后特征列向量h,行数为静音段的帧数
D0=length(c2(1,:));   % 传统MFCC的维度
D1=(D0+1)*(D0+2)/2;  % 特征H的维度
H=zeros(D1,length(S(:,1))); % H初始化
for i=1:length(c2(:,1))
    c2i=[1,c2(i,:)]; 
    h_end=0;
    for j=1:D0+1
        h_start=h_end+1; %计算时，每行开始的地方在H中对应的位置
        h_end=h_start+D0-j+1;
        k=j;
        for location=h_start:h_end
            H(location,i)=c2i(j)*c2i(k);
            k=k+1;
        end
    end
end
        
        
        


