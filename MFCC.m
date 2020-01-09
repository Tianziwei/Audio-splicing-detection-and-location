function H=MFCC(S)
%��ÿһ֡����MFCC������������Ԥ���أ�������ȡƵ������
bank=melbankm(24,512,16000); %Mel�˲����Ľ���Ϊ24��fft�任�ĳ���Ϊ512������Ƶ��Ϊ16000Hz
%��һ��mel�˲�����ϵ��
bank=full(bank);
bank=bank/max(bank(:));
for k=1:12			
n=0:23;
dctcoef(k,:)=cos((2*n+1)*k*pi/(2*24));
end
w=1+6*sin(pi*[1:12]./12);%��һ��������������

%����ÿ֡�Ĵ�ͳMFCC����
for i=1:length(S(:,1))
    s=S(i,:);
	t=abs(fft(s)); %fft���ٸ���Ҷ�任
    t=t.^2';
	c1=dctcoef*log(bank*t(1:257)+eps);
c2=c1.*w';
m(i,:)=c2';
c2=m;
end

% %����MFCC������һ�ײ��
% dtm=zeros(size(m));
% for i=3:size(m,1)-2
%     dtm(i,:) = -2*m(i-2,:) - m(i-1,:) + m(i+1,:) + 2*m(i+2,:);
% end
% dtm = dtm/3;
% %�ϲ�mfcc������һ�ײ�ֲ���
% c = [m dtm];
% %ȥ����β��֡����Ϊ����֡һ�ײ�ֲ���Ϊ0
% c2 = c(3:size(m, 1)-2,:);

% ����GLDS-kernel������MFCC����������չ
% ���յõ�����һ����ά����H��ÿ��Ϊÿ֡����չ������������h,����Ϊ�����ε�֡��
D0=length(c2(1,:));   % ��ͳMFCC��ά��
D1=(D0+1)*(D0+2)/2;  % ����H��ά��
H=zeros(D1,length(S(:,1))); % H��ʼ��
for i=1:length(c2(:,1))
    c2i=[1,c2(i,:)]; 
    h_end=0;
    for j=1:D0+1
        h_start=h_end+1; %����ʱ��ÿ�п�ʼ�ĵط���H�ж�Ӧ��λ��
        h_end=h_start+D0-j+1;
        k=j;
        for location=h_start:h_end
            H(location,i)=c2i(j)*c2i(k);
            k=k+1;
        end
    end
end
        
        
        


