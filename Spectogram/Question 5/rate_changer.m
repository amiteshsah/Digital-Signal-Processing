x=1:1:20;
x_up=upsample(x,4);
h=[0 0 0 0 1 0 0 0 0]
x_f=conv(x_up,h);
y=downsample(x_f,3)
subplot(2,1,1),stem(x) ,grid on
subplot(2,1,2),stem(y) ,grid on
