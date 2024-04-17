function [trajectory,trajsigma,trajthick] = GetGMRTraj(data,numComponent,step)
    % 输入列数据
    strokeGMM = GenerateGMM(data(:,[1,2,4]), numComponent);
    trajTime= linspace(data(1,4), data(end,4), step);
    [trajectory,trajsigma] = GMR(strokeGMM.ComponentProportion, strokeGMM.mu', strokeGMM.Sigma, trajTime,3,1:2);     
    trajthick=zeros(2,2,step);
    trajthick(:,:,1)=1E-5.*diag(ones(2,1));
    for i=2:step
        idx=data(:,4)>=trajTime(i-1)&data(:,4)<=trajTime(i);
        if isempty(max(abs(data(idx,5))))
            trajthick(:,:,i)=trajthick(:,:,i-1);
        else
            % [~,R]=eig(trajsigma(:,:,i));
            % trajthick(:,:,i)=R'*max(abs(data(idx,5)))*eye(2)*R;

            trajthick(:,:,i)=max(abs(data(idx,5)))*eye(2);
        end
    end
    

end

