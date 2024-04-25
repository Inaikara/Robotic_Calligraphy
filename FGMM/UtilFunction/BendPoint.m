function Data= BendPoint(Data,C,T,Q)
% 将Data点沿着抛物线进行弯曲
%   Data N*2
T=repmat(T,[size(Data,1),1]);
Data = (Data-T)*Q;
a=C(1);
b=C(2);
for i=1:size(Data,1)
    x0=Data(i,1);
    y0=Data(i,2);
    syms x
    eqn=x0==(1/2)*x*(1+4*(a^2)*(x^2))^(1/2)+(1/(4*a))*log(2*a*x+(1+4*a^2*x^2)^(1/2));
    x=vpasolve(eqn,x);
    x=double(x);
    Data(i,1)=x;
    Data(i,2)=a*x.*x+b+y0;
end
Data=Data*Q'+T;

end