function f = convt2(h,g)
% f = convt(h,g);
% Transpose convolution: f = H? g
[Nhh,Nhw] = size(h);
[Ngh,Ngw] = size(g);
f = conv2(h(Nhh:-1:1,Nhw:-1:1), g);
f = f(Nhh:Ngh,Nhw:Ngw);
end
