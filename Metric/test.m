y1 = rand(10,2);
y2 = repmat(1:10,2,1)';
y2(:,2) = y2(:,1) + 1 ;
hh1 = subplot(1,2,1,'position',[0.13,0.2,0.34,0.75]);
h{1} = plot(y1);
hh2 = subplot(1,2,2,'position',[0.57,0.2,0.34,0.75]);
h{2} = plot(y2);
hh = legend([h{1};h{2}],'y1','y2','Orientation','horizontal','location',[0.13,0.05,0.74,0.05]);