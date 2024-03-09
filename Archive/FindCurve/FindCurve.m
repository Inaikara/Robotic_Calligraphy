function[rdata] = FindCurve(img_2bw,duan)
[imgw,imgh] = size(img_2bw);
%imshow(img_2bw)
img_thin = bwmorph(~img_2bw,'thin',Inf);
%imshow(img_thin)

img_thin1 = img_thin;
img_thin2 = img_thin;

%% 寻找曲线
curve_name = 0;
for start_j = 1:imgh
    for start_i = 1:imgw
% for start_i = 1:imgw
%     for start_j = 1:imgh
        if img_thin1(start_i,start_j) == 1
            %% 先把起始点设定好
            curve_name = curve_name + 1;
            name_1 = 1;
            direction_1 = [0 0];
            start_point = [start_i start_j];
            [connect_point,point_num,sta_dir] = FindStaConnect(img_thin2,start_point);%得到所有连接点
            [choose_point] = ChoosePoint(direction_1,connect_point);%选择正确的点
            [direction_1] = Direction(choose_point,direction_1);%更新方向表
            direction_2 = [-direction_1(1) -direction_1(2)];%用于反方向寻找曲线
            if point_num == 0
                img_thin2(start_point(1),start_point(2)) = 0;
                break
            end
            if point_num>1
                black_flag = 0; %置黑flag，0为不置黑，1为置黑
            else
                black_flag = 1;
                img_thin2(start_point(1),start_point(2)) = 0;
            end
            %eval(['curve',num2str(curve_name),'(name_1,:)','=','start_point',';']);
            start_point = [start_i start_j sta_dir black_flag];
%             eval(['curve',num2str(curve_name),'(name_1,:)','=','start_point',';']);
%             name_1 = name_1+1;
            
            %% 找第二个点
            last_point = start_point;
            this_point = choose_point;
            flag_1 = 1;
            
            while flag_1 == 1
                [connect_point,point_num] = FindStaConnect(img_thin2,this_point);
                [choose_point] = ChoosePoint(direction_1,connect_point);
                [direction_1] = Direction(choose_point,direction_1);
                if choose_point == [0 0 0] %没找到规定方向连接点，可能没有连接点也可能有连接点
                    %完全没有连接点，置黑
                    if ((point_num == 0)&&(last_point(4) ==1)) || ((point_num == 1)&&(last_point(4) ==0))
                        img_thin1(this_point(1),this_point(2)) = 0;
                        img_thin2(this_point(1),this_point(2)) = 0;
                        this_point(4) = 1;
                        eval(['curve',num2str(curve_name),'(name_1,:)','=','this_point',';']);
                        name_1 = name_1+1;
                        break
                    %有连接点，不置黑
                    else
                        this_point(4) = 0;
                        img_thin1(this_point(1),this_point(2)) = 0;
                        eval(['curve',num2str(curve_name),'(name_1,:)','=','this_point',';']);
                        name_1 = name_1+1;
                        break
                    end
                else %有规定方向连接点的情况
                    %只有一个连接点，置黑
                    if ((last_point(4) == 1)&&(point_num==1)) || ((last_point(4) == 0)&&(point_num==2))
                        img_thin2(this_point(1),this_point(2)) = 0;
                        this_point(4) = 1;
                    else
                        this_point(4) = 0;
                    end
                    img_thin1(this_point(1),this_point(2)) = 0;
                    eval(['curve',num2str(curve_name),'(name_1,:)','=','this_point',';']);
                    name_1 = name_1+1;
                    last_point = this_point;
                    this_point = choose_point;
                end
            end
            
            %% 反方向找第二个点
            %if start_point(4) == 0
            %eval(['curve',num2str(curve_name),'=','[start_point;curve',num2str(curve_name),']',';']);
            %eval(['curve',num2str(curve_name),'(1,:)=[]',';']);
            eval(['last_point = curve',num2str(curve_name),'(1,:)',';']);
            this_point = start_point;
            flag_2 = 1;

            while flag_2 == 1
                [connect_point,point_num] = FindStaConnect(img_thin2,this_point);
                [choose_point] = ChoosePoint(direction_2,connect_point);
                [direction_2] = Direction(choose_point,direction_2);
                if choose_point == [0 0 0] %没找到规定方向连接点，可能没有连接点也可能有连接点
                    %完全没有连接点，置黑
                    if ((point_num == 0)&&(last_point(4) ==1)) || ((point_num == 1)&&(last_point(4) ==0))
                        img_thin2(this_point(1),this_point(2)) = 0;
                        this_point(4) = 1;
                        img_thin1(this_point(1),this_point(2)) = 0;
                        eval(['curve',num2str(curve_name),'=','[this_point;curve',num2str(curve_name),']',';']);
                        break
                    %有连接点，不置黑
                    else
                        this_point(4) = 0;
                        img_thin1(this_point(1),this_point(2)) = 0;
                        eval(['curve',num2str(curve_name),'=','[this_point;curve',num2str(curve_name),']',';']);
                        break
                    end
                else %有规定方向连接点的情况
                    %只有一个连接点，置黑
                    if ((last_point(4) == 1)&&(point_num==1)) || ((last_point(4) == 0)&&(point_num==2))
                        img_thin2(this_point(1),this_point(2)) = 0;
                        this_point(4) = 1;
                    else
                        this_point(4) = 0;
                    end
                    img_thin1(this_point(1),this_point(2)) = 0;
                    eval(['curve',num2str(curve_name),'=','[this_point;curve',num2str(curve_name),']',';']);
                    last_point = this_point;
                    this_point = choose_point;
                end
            end
            
            %% 把不置黑的中间夹杂的置黑的再置白 此方法不行，还是通过加点直接拼接吧
%             eval(['cruve = ','curve',num2str(curve_name),';']);
%             [m,~] = find(cruve(:,4)==0);
%             [n,~] = size(m);
%             if n >= 2
%                 for i = 1:n-1
%                     if (m(i+1)-m(i)>1) && (m(i+1)-m(i)<3)
%                         for j = m(i):m(i+1)
%                             img_thin2(cruve(j,1),cruve(j,2)) = 1;
%                         end
%                     end
%                 end
%             end
   
        end
    end
end

%% 点排序
for i = 1:curve_name
    eval(['paixu','=','curve',num2str(i),';']);
    [bihua] = Seq(paixu);
    eval(['curve',num2str(i),'=','bihua',';']);
end

            
    

%% 将同一笔画相连
idel = 0;%循环中要删除的i
n = 0;
connect = [];
for i = 1:curve_name
    %if i~=idel
        eval(['stroke','=','curve',num2str(i),';']);
        for j = 1:curve_name
            if j ~= i
                eval(['stro_1','=','curve',num2str(i),';']);
                eval(['stro_2','=','curve',num2str(j),';']);
                a = stro_1(end,1) ;
                b = stro_2(1,1) ;
                c = stro_1(end,2) ;
                d = stro_2(1,2) ;
                if a==b && c==d
                    stroke(end,:) = [];
                    n = n+1;
                    connect(n,:) = [i j];
                    %eval(['stroke','=','[','stroke',';','curve',num2str(j),']',';']);
                    idel = j;
                else
                    if abs(a-b)<duan && abs(c-d)<duan
                        n = n+1;
                        connect(n,:) = [i j];
                        %eval(['stroke','=','[','stroke',';','curve',num2str(j),']',';']);
                        idel = j;
                    end
                end
            end
        end
        %eval(['stroke',num2str(name_2),'=','stroke',';']);
        %name_2 = name_2 + 1;
    %end
end

name_2 = 0;
con_cur_num = 0;
con_flag = 1;
for i = 1:n
    find_s = ismember(connect(i,1),connect(:,2)); %find_s为1表示不是一个笔画的第一段
    if find_s == 0
        con_1 = connect(i,2);
        name_2 = name_2 + 1;
        eval(['stroke',num2str(name_2),'=','[curve',num2str(connect(i,1)),';curve',num2str(connect(i,2)),']',';']);
        con_cur_num = con_cur_num + 1;
        while con_flag ==1
            find_s = ismember(con_1,connect(:,1));
            if find_s == 1
                [con_m,~] = find(connect(:,1) == con_1);
                eval(['stroke',num2str(name_2),'=','[stroke',num2str(name_2),';curve',num2str(connect(con_m,2)),']',';']);
                con_cur_num = con_cur_num + 1;
                con_1 = connect(con_m,2);
            else
                break
            end
        end
    end
end

%% 剩下的再反过来排列一次
na = name_2;
del_num = 0;
cruve_del = [];
for i = 1:curve_name
    find_c = ismember(i,connect);
    if find_c == 0
        eval(['stro_1','=','curve',num2str(i),';']);
        flag_sig = 1;
        
        for j = 1:na
            eval(['stro_2','=','stroke',num2str(j),';']);
            a = stro_2(end,1);
            b = stro_2(end,2);
            c = stro_1(end,1);
            d = stro_1(end,2);
            if abs(a-c)<duan && abs(b-d)<duan
%             if a == c && b ==d
                [stro_1] = Seq1(stro_1);
                stro_1(1,:)=[];
                eval(['stroke',num2str(j),'=','[stroke',num2str(j),';stro_1]',';']);
                flag_sig = 0;
                del_num  = del_num+1;
                cruve_del(del_num) = i;
            end
        end
        
        for k = 1:curve_name
            find_c1 = ismember(i,connect);
            if find_c1 == 0 && k~=i
                eval(['stro_2','=','curve',num2str(k),';']);
                a = stro_2(end,1);
                b = stro_2(end,2);
                c = stro_1(end,1);
                d = stro_1(end,2);
                if abs(a-c)<duan && abs(b-d)<duan
%                 if a == c && b ==d
                    [stro_1] = Seq1(stro_1);
                    stro_1(1,:)=[];
                    eval(['curve',num2str(k),'=','[curve',num2str(k),';stro_1]',';']);
                    del_num  = del_num+1;
                    cruve_del(del_num) = i;
                end
            end
        end
                
%         if flag_sig == 1
%             name_2 = name_2 + 1;
%             eval(['stroke',num2str(name_2),'=','curve',num2str(i),';']);
%         end
    end
end

for i = 1:curve_name
    find_c = ismember(i,connect);
    find_d = ismember(i,cruve_del);
    if find_c == 0 && find_d == 0
        name_2 = name_2 + 1;
        eval(['stroke',num2str(name_2),'=','curve',num2str(i),';']);
    end
end



% %% 画图
% figure(2)
% %for i = 1:name_2
% for i = 1:curve_name
%     eval(['huatu','=','curve',num2str(i),';']);
%     %eval(['huatu','=','stroke',num2str(i),';']);
%     plot(huatu(:,1),huatu(:,2),'Color',[rand(),rand(),rand()],'LineWidth',4)
%     axis([0 imgw 0 imgh])
%     hold on
% end
% 
% 
% figure(3)
% for i = 1:name_2
% %for i = 1:curve_name
%     %eval(['huatu','=','curve',num2str(i),';']);
%     eval(['huatu','=','stroke',num2str(i),';']);
%     plot(huatu(:,1),huatu(:,2),'Color',[rand(),rand(),rand()],'LineWidth',4)
%     axis([0 imgw 0 imgh])
%     hold on
% end
% 
% fig = figure(1);
% frame = getframe(fig);
% img_bihua = frame2im(frame);
% imwrite(img_bihua,'a.png')


%% 整理数据

rdata=[];
for i = 1:name_2
    eval(['shuju','=','stroke',num2str(i),';']);
    shuju = shuju';
%     shuju(3:7,:) = 0;
    shuju = shuju(1:3,:);
    shuju(3,:) = i;
    rdata=[rdata;shuju'];
    eval(['data',num2str(i),'=shuju;']);
end

end
