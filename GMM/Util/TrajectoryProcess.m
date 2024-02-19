function [trajectory,data] = TrajectoryProcess(trajectory,data)
    [xmin,xmax,ymin,ymax]=deal(zeros(size(trajectory,1)/3,1));
    for n=1:size(trajectory,1)/3
        xmin(n)=min(trajectory(n*3-1,:));
        xmax(n)=max(trajectory(n*3-1,:));
        ymin(n)=min(trajectory(n*3,:));
        ymax(n)=max(trajectory(n*3,:));
    end

    xmin=min(xmin);
    xmax=max(xmax);
    ymin=min(ymin);
    ymax=max(ymax);

    tran_x=(xmin+xmax)/2;
    tran_y=(ymin+ymax)/2;

    %Æ½ÒÆ
    for n=1:size(trajectory,1)/3
        trajectory(n*3-1,:)=trajectory(n*3-1,:)-tran_x;
        trajectory(n*3,:)=trajectory(n*3,:)-tran_y;
    end

    data(:,1)=data(:,1)-tran_x;
    data(:,2)=data(:,2)-tran_y;

end

