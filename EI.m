function E=EI(frame)
% ����ÿһ֡�Ķ�ʱƵ������
Y=fft(frame);  % ��ÿһ֡���и���Ҷ�任
nfft=length(Y); 
E=sum(abs(Y.^2))/nfft;  %��ʱƵ������

