function zcr=ZI(frame)
% ����ÿһ֡�Ĺ�����
% frame=[1 0 0 0 0 -1 1 1 1 2 -2 2];
zcr=0;
for j=2: length(frame);          % ��һ֡��Ѱ�ҹ����
      if abs(sign(frame(j))-sign(frame(j-1)))== 2       % �ж��Ƿ�Ϊ�����
           zcr=zcr+1;   % �ǹ���㣬��¼1��
      elseif abs(sign(frame(j))-sign(frame(j-1)))== 1
          zcr=zcr+0.5;
      end
end

