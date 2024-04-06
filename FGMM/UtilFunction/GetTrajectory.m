function trajectory = GetTrajectory(data,componentOrder,step)
    strokeList=unique(data(:,4));
    trajectory=[];
    for strokeType=strokeList'
        NumOfComponent=length(find(componentOrder(:,1)==strokeType));
        dataStroke=data(data(:,4)==strokeType,:);
        strokeGMM = GenerateGMM(dataStroke(:,[1,2,3]), NumOfComponent*2);
        trajTime= linspace(dataStroke(1,3), dataStroke(end,3), step);
        trajXY = GMR(strokeGMM.ComponentProportion, strokeGMM.mu', strokeGMM.Sigma, trajTime,3,1:2);
        trajZ=zeros(1,step);
%         trajRange=fix(step/50);
%         for i=1+trajRange:step-trajRange
%             trajZ(i)=length(find(dataStroke(:,3)>trajTime(i-trajRange)&dataStroke(:,3)<trajTime(i+trajRange)))/10;
%         end
        
        dataTime=round(dataStroke(:,3));
        for i=1:step
            trajZ(i)=length(find(dataTime==round(trajTime(i))))/2;
        end
        
        trajectory=[trajectory;trajZ;trajXY];
    end    
end

