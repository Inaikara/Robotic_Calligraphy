function dataNew = AddTime(data,stroke,componentOrder,C,Q,T)
    dataNew=[];
    componentTime=0;
    strokeList=unique(componentOrder(:,1));
    for strokeType=strokeList'
        componentIdx=componentOrder(:,1)==strokeType;
        for componentType=componentOrder(componentIdx,2)'
            %% 映射样本点到主成分轴上
            dataComponent=data(data(:,3)==componentType,:);
            dataTime = Data2NewData(dataComponent(:,[1,2])',C(componentType,:),T(componentType,:),Q(:,:,componentType))';
            % dataComponent(:,3)=dataTime(:,1);
            dataComponent(:,3)=round(dataTime(:,1));       
            dataComponent=sortrows(dataComponent,3);

            %% 判断方向
            dataDirect=dataComponent(fix(4*end/5),[1,2])-dataComponent(fix(1*end/5)+1,[1,2]);
            strokeComponent=stroke(stroke(:,3)==componentType,:);
            strokeDirect=strokeComponent(fix(4*end/5),[1,2])-strokeComponent(fix(1*end/5)+1,[1,2]);
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

