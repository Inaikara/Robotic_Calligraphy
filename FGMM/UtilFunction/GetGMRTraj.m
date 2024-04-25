function [trajectory,trajsigma,trajthick] = GetGMRTraj(data,numComponent,step)
    % 输入列数据
    thick=zeros(1,step);
    space=5;

    %% GMR回归
    strokeGMM = GenerateGMM(data, numComponent);
    trajTime= linspace(data(1,3), data(end,3), step);
    [trajectory,trajsigma] = GMR(strokeGMM.ComponentProportion, strokeGMM.mu', strokeGMM.Sigma, trajTime,3,1:2);     

    %% Deviation Analysis
    for i=(1+space):step
        idx=data(:,3)>=trajTime(i-space)&data(:,3)<=trajTime(i);
        data_tmp=data(idx,4);% 在该时域内的点集
        data_p=data_tmp(data_tmp>0);
        data_n=data_tmp(data_tmp<0);
        if isempty(data_tmp)% 如果都是空
            thick(i)=thick(i-1);
        elseif isempty(data_p)% 如果正数为空
            thick(i)=max(abs(data_n));
        elseif isempty(data_n)% 如果负数为空
            thick(i)=max(data_p);
        else
            thick(i)=max(data_p)+max(abs(data_n));
        end
    end
    thick(1:space)=thick(1+space);

    %% thick处理
    % 将thick转为方差
    thickL=thick.*thick/36;
    % thickS=0.1*thickL;
    trajthick=zeros(2,2,step);
    for i=1:step
        [R,D]=eig(trajsigma(:,:,i));
        if D(1,1)>D(2,2)
            trajthick(1,1,i)=thickL(i);
            trajthick(2,2,i)=D(2,2);
        else
            trajthick(1,1,i)=D(1,1);
            trajthick(2,2,i)=thickL(i);
        end
        trajthick(:,:,i)=R*trajthick(:,:,i)*R';
    end

    % trajthick=zeros(2,2,step);
    % trajthick(1,1,:)=thickL;
    % trajthick(2,2,:)=thickS;




end

