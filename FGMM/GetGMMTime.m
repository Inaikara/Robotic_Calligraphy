function dataNew = GetGMMTime(data,directdata,~,~,~)
    initialtime=0;
    dataNew=[];
    componentOrder=unique(directdata(:,3),'stable','rows');
    for componentType=componentOrder'
        %% 映射样本点到主成分轴上
        dataComponent=data(data(:,3)==componentType,:);
        [~,dataTime,~]=pca(dataComponent(:,[1,2]));
        dataComponent(:,3)=dataTime(:,1);  
        dataComponent=sortrows(dataComponent,3);      
        %% 判断方向        
        dataDirect=sum(dataComponent(fix(end/2)+1:end,[1,2]))-sum(dataComponent(1:fix(end/2),[1,2]));
        realDirect=sum(directdata(fix(end/2)+1:end,[1,2]))-sum(directdata(1:fix(end/2),[1,2]));
        isDirectionSame= dot(dataDirect,realDirect);
        if isDirectionSame<0
            dataComponent(:,3)=-dataComponent(:,3);
            dataComponent=sortrows(dataComponent,3);
        end
        %% 归一化
        dataComponent(:,3)=dataComponent(:,3)-dataComponent(1,3)+initialtime;
        dataNew=[dataNew;dataComponent];
        initialtime=dataNew(end,3);
    end
end