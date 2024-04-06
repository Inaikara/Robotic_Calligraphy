function dataNew = AddFTime(data,stroke,componentOrder,C,T,Q)
    dataNew=[];
    componentTime=0;
    strokeList=unique(componentOrder(:,1));
    for strokeType=strokeList'
        componentIdx=componentOrder(:,1)==strokeType;
        for componentType=componentOrder(componentIdx,2)'
            %% 映射样本点到主成分轴上
            dataComponent=data(data(:,3)==componentType,:);
            dataTime = Data2NewData(dataComponent(:,[1,2])',C(componentType,:),T(componentType,:),Q(:,:,componentType))';
            dataComponent(:,3)=dataTime(:,1);
            %dataComponent(:,3)=round(dataTime(:,1));       
            dataComponent=sortrows(dataComponent,3);

            %% 判断方向
            dataDirect=sum(dataComponent(fix(end/2)+1:end,[1,2]))-sum(dataComponent(1:fix(end/2),[1,2]));
            strokeComponent=stroke(stroke(:,3)==componentType,:);
            strokeDirect=sum(strokeComponent(fix(end/2)+1:end,[1,2]))-sum(strokeComponent(1:fix(end/2),[1,2]));
            isDirectionSame= dot(dataDirect,strokeDirect);
            if isDirectionSame<0
                dataComponent(:,3)=-dataComponent(:,3);
                dataComponent=sortrows(dataComponent,3);
            end
            
            %% 归一化
            dataComponent(:,3)=dataComponent(:,3)-dataComponent(1,3)+componentTime;
            dataNew=[dataNew;dataComponent];
            componentTime=dataNew(end,3);
        end      
    end
end

