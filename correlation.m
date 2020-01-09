function r= correlation(H,w)
% 计算相关系数向量
%用D X 2w的窗口在音频特征H上从前向后沿水平方向滑动
% 每次滑动距离为w
Ns=length(H(1,:));
D=length(H(:,1));  % 窗的高度
Nr=floor(Ns/w-1);  % 相关系数向量长度Nr
r=zeros(1,Nr); %相关系数向量初始化

%窗口在H上从前向后沿水平方向滑动
for i=1:Nr
    w_start=(i-1)*w+1;
    w_end=w_start+2*w-1;
    H1=H(:,(w_start:w_start+w-1)); %窗内前w个列向量构成的子矩阵
    H2=H(:,(w_start+w:w_end)); %窗内后w个列向量构成的子矩阵
    Hi1=zeros(D,1);Hi2=zeros(D,1); % 初始化均值向量Hi1和Hi2
    for j=1:D
        Hi1(j)=mean(H1(j,:));
        Hi2(j)=mean(H2(j,:));
    end
    ave1=mean(Hi1);    ave2=mean(Hi2); %计算两个子矩阵的均值
    rup=sum((Hi1-ave1).*(Hi2-ave2));
    r(i)=rup/(std(Hi1)*std(Hi2)*(D-1)); %计算相关系数
end

       
       
        
    
    
