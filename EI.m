function E=EI(frame)
% 计算每一帧的短时频谱能量
Y=fft(frame);  % 对每一帧进行傅里叶变换
nfft=length(Y); 
E=sum(abs(Y.^2))/nfft;  %短时频谱能量

