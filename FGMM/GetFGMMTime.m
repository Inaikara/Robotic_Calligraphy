function dataNew = GetFGMMTime(data,directdata,C,T,Q)
    initialtime=0;
    dataNew=[];
    componentOrder=unique(directdata(:,3),'stable','rows');
    for componentType=componentOrder'
        %% 映射样本点到主成分轴上
        dataComponent=data(data(:,3)==componentType,:);
        directComponent=directdata(directdata(:,3)==componentType,:);
        if abs(C(componentType,1))>=1e5
            dataTime = Data2NewData(dataComponent(:,[1,2])',C(componentType,:),T(componentType,:),Q(:,:,componentType))';
        else
            [~,dataTime,~]=pca(dataComponent(:,[1,2]));
        end
        dataComponent(:,[4,5])=dataTime;   
        dataComponent=sortrows(dataComponent,4);      
        %% 判断方向        
        dataDirect=sum(dataComponent(fix(end/2)+1:end,[1,2]))-sum(dataComponent(1:fix(end/2),[1,2]));
        realDirect=sum(directComponent(fix(end/2)+1:end,[1,2]))-sum(directComponent(1:fix(end/2),[1,2]));
        isDirectionSame= dot(dataDirect,realDirect);
        if isDirectionSame<0
            dataComponent(:,4)=-dataComponent(:,4);
            dataComponent=sortrows(dataComponent,4);
        end        
        %% 归一化
        dataComponent(:,4)=dataComponent(:,4)-dataComponent(1,4)+initialtime;
        dataNew=[dataNew;dataComponent];
        initialtime=dataNew(end,4);
    end
end