function NewData = Data2NewData(Data,C,T,Q)
%GETPROJECTIONLENGTH 输入行数据和CTQ矩阵，得到变换后新的数据
Data=Data';% 转变为列数据

% 坐标变换
T=repmat(T,[size(Data,1),1]);
Data = (Q*(Data-T)')';
NewData=zeros(size(Data));

a=C(1);
b=C(2);

for i=1:size(Data,1)
    [z1,z2]=FindProjection(Data(i,:),C);
    NewData(i,1)=(1/2)*z1*(1+4*(a^2)*(z1*z1))^(0.5);
    NewData(i,1)=NewData(i,1)+(1/(4*abs(a)))*log(2*abs(a)*z1+(1+4*a^2*z1^2)^(1/2));
    NewData(i,2)=((Data(i,1)-z1)^2+(Data(i,2)-z2)^2)^(1/2);
    if a*Data(i,1)^2+b>Data(i,2)
        NewData(i,2)=-NewData(i,2);
    end
end

NewData=NewData';%转变为行数据

end