function NewData = GetProjectionLength(Data,C,T,Q)
%GETPROJECTIONLENGTH 输入列数据和CTQ矩阵，得到变换后新的数据

Data = (Data-T)*Q;
NewData=zeros(size(Data));

for i=1:size(Data,1)
    [z1,z2]=FindProjection(Data(i,:),C);
    NewData(i,1)=(1/2)*z1*(1+4*(C^2)*(z1^2))^(1/2)+(1/(4*abs(C)))*log(2*abs(C)*z1+(1+4*C^2*z1^2)^(1/2));
    NewData(i,2)=((Data(i,1)-z1)^2+(Data(i,2)-z2)^2)^(1/2);
end


end