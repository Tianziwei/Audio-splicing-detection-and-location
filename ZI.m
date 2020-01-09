function zcr=ZI(frame)
% 计算每一帧的过零率
% frame=[1 0 0 0 0 -1 1 1 1 2 -2 2];
zcr=0;
for j=2: length(frame);          % 在一帧内寻找过零点
      if abs(sign(frame(j))-sign(frame(j-1)))== 2       % 判断是否为过零点
           zcr=zcr+1;   % 是过零点，记录1次
      elseif abs(sign(frame(j))-sign(frame(j-1)))== 1
          zcr=zcr+0.5;
      end
end

