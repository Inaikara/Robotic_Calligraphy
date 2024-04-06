function trajectory = GetXYTrajectory(data,componentOrder,step)
    strokeList=unique(data(:,4));
    trajectory=[];
    for strokeType=strokeList'
        %% 选择笔画数据
        dataStroke=data(data(:,4)==strokeType,:);

        %% 对每个笔画进行GMR
        NumOfComponent=length(find(componentOrder(:,1)==strokeType));
        strokeGMM = GenerateGMM(dataStroke(:,[1,2,3]), NumOfComponent*2);
        trajTime= linspace(dataStroke(1,3), dataStroke(end,3), step);
        trajXY = GMR(strokeGMM.ComponentProportion, strokeGMM.mu', strokeGMM.Sigma, trajTime,3,1:2);     

        %% 保存
        trajectory=[trajectory;trajTime;trajXY];
    end    
end

