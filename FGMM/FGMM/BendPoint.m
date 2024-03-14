function data= BendPoint(data,C,T,Q)
% 将data点沿着抛物线进行弯曲
%   data N*2
T=repmat(T,[size(data,1),1]);
data = (data-T)*Q;
for i=1:size(data,1)
    x0=data(i,1);
    y0=data(i,2);
    syms x
    eqn=x0==(1/2)*x*(1+4*(C^2)*(x^2))^(1/2)+(1/(4*C))*log(2*C*x+(1+4*C^2*x^2)^(1/2));
    x=vpasolve(eqn,x);
    x=double(x);
    data(i,1)=x;
    data(i,2)=C*x.*x+y0;
end
data=data*Q'+T;

end