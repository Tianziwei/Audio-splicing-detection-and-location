function [x1,x2] = vad(x,a,b)
%幅度归一化到[-1,1]
x = double(x);
x = x / max(abs(x));
 
%常数设置
FrameLen = 32e-3*fs; %帧长为512点
FrameInc = 16e-3*fs; %帧移为256点
 
amp1 = 10;%初始短时能量高门限
amp2 = 2;%初始短时能量低门限
zcr1 = 10;%初始短时过零率高门限
zcr2 = 5;%初始短时过零率低门限
 
maxsilence = 8;  % 8*10ms  = 80ms
%语音段中允许的最大静音长度，如果语音段中的静音帧数未超过此值，则认为语音还没结束；如果超过了
%该值，则对语音段长度count进行判断，若count<minlen，则认为前面的语音段为噪音，舍弃，跳到静音
%状态0；若count>minlen，则认为语音段结束；

minlen  = 15;    % 15*10ms = 150ms
%语音段的最短长度，若语音段长度小于此值，则认为其为一段噪音

status  = 0;     %初始状态为静音状态
count   = 0;     %初始语音段长度为0
silence = 0;     %初始静音段长度为0
 
%计算过零率
tmp1  = enframe(x(1:end-1), FrameLen, FrameInc);%分帧，所得矩阵为fix（（x(1:end-1)-FrameLen+FrameInc）/FrameInc）*FrameLen
tmp2  = enframe(x(2:end)  , FrameLen, FrameInc);%分帧，所得矩阵为fix（（x(2:end)-FrameLen+FrameInc）/FrameInc）*FrameLen
signs = (tmp1.*tmp2)<0;%tmp1.*tmp2所得矩阵小于等于零的赋值为1，大于零的赋值为0
diffs = (tmp1 -tmp2)>0.02;%tmp1-tmp2所得矩阵小于0.02的赋值为0，大于等于0.02的赋值为1
zcr   = sum(signs.*diffs, 2);
 
%计算短时能量
amp = sum((abs(enframe( x, FrameLen, inc))).^2, 2);
 
%调整能量门限
% amp1 = min(amp1, max(amp)/4);
% amp2 = min(amp2, max(amp)/8);
TE=a*amp;
 
%开始端点检测
x1 = 0;
x2 = 0;
for n=1:length(zcr) %length（zcr）得到的是整个信号的帧数
   goto = 0;
   switch status
   case {0,1}                   % 0 = 静音, 1 = 可能开始
      if amp(n) < amp1          % 确信进入语音段
         x1 = max(n-count-1,1);
         status  = 2;
         silence = 0;
         count   = count + 1;
      elseif amp(n) > amp2 | ... % 可能处于语音段
             zcr(n) > zcr2
         status = 1;
         count  = count + 1;
      else                       % 静音状态
         status  = 0;
         count   = 0;
      end
   case 2,                       % 2 = 语音段
      if amp(n) > amp2 | ...     % 保持在语音段
         zcr(n) > zcr2
         count = count + 1;
      else                       % 语音将结束
         silence = silence+1;
         if silence < maxsilence % 静音还不够长，尚未结束
            count  = count + 1;
         elseif count < minlen   % 语音长度太短，认为是噪声
            status  = 0;
            silence = 0;
            count   = 0;
         else                    % 语音结束
            status  = 3;
         end
      end
   case 3,
      break;
   end
end  
count = count-silence/2;
x2 = x1 + count -1;
subplot(311)    %subplot(3,1,1)表示将图排成3行1列，最后的一个1表示下面要画第1幅图
plot(x)
axis([1 length(x) -1 1])    %函数中的四个参数分别表示xmin,xmax,ymin,ymax，即轴的范围
ylabel('Speech');
line([x1*FrameInc x1*FrameInc], [-1 1], 'Color', 'red');
%这里作用为用直线画出语音段的起点和终点，看起来更直观。第一个[]中的两个参数为线起止点的横坐标，
%第二个[]中的两个参数为线起止点的纵坐标。最后两个参数设置了线的颜色。
line([x2*FrameInc x2*FrameInc], [-1 1], 'Color', 'red');
subplot(312)   
plot(amp);
axis([1 length(amp) 0 max(amp)])
ylabel('Energy');
line([x1 x1], [min(amp),max(amp)], 'Color', 'red');
line([x2 x2], [min(amp),max(amp)], 'Color', 'red');
subplot(313)
plot(zcr);
axis([1 length(zcr) 0 max(zcr)])
ylabel('ZCR');
line([x1 x1], [min(zcr),max(zcr)], 'Color', 'red');
line([x2 x2], [min(zcr),max(zcr)], 'Color', 'red');