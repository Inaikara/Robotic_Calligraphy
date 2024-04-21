function [trajectory,trajSigma,trajthick] = GetTrajectory(data,componentOrder,step)
    strokeList=unique(data(:,4));
    trajectory=[];
    trajSigma=[];
    trajthick=[];
    for strokeType=strokeList'
        NumOfComponent=length(find(componentOrder(:,1)==strokeType));
        dataStroke=data(data(:,4)==strokeType,:);
        strokeGMM = GenerateGMM(dataStroke(:,[1,2,3]), NumOfComponent*2);
        trajTime= linspace(dataStroke(1,3), dataStroke(end,3), step);
        [trajXY,sigma] = GMR(strokeGMM.ComponentProportion, strokeGMM.mu', strokeGMM.Sigma, trajTime,3,1:2);
        dataTime=round(dataStroke(:,3));
%         trajRange=fix(step/50);
%         for i=1+trajRange:step-trajRange
%             trajZ(i)=length(find(dataStroke(:,3)>trajTime(i-trajRange)&dataStroke(:,3)<trajTime(i+trajRange)))/10;
%         end
        
        trajZ=zeros(1,step);
        for i=1:step
            trajZ(i)=length(find(dataTime==round(trajTime(i))))/2;
        end

        %% thick处理
        thick=trajZ;
        thickL=thick.*thick/3;
        % thickS=1*thickL;
        thick=zeros(2,2,step);
        for i=1:step
            [R,D]=eig(sigma(:,:,i));
            if D(1,1)>D(2,2)
                thick(1,1,i)=thickL(i);
                thick(2,2,i)=D(2,2);
            else
                thick(1,1,i)=D(1,1);
                thick(2,2,i)=thickL(i);
            end
            thick(:,:,i)=R*thick(:,:,i)*R';
        end

        
        trajectory=[trajectory;trajZ;trajXY];
        trajSigma=[trajSigma;sigma];
        trajthick=[trajthick;thick];
    end    
end

