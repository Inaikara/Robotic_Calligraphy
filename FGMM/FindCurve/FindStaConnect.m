function[connect_point,point_num,sta_dir] = FindStaConnect(img,this_point)
point_num = 1;
% sta_dir = 0;%这个没用了
connect_point = [0 0 0];
if img(this_point(1)-1,this_point(2)) == 1
    connect_point(point_num,:) = [this_point(1)-1 this_point(2) 1];
    point_num = point_num+1;
    sta_dir = 5;
end
if img(this_point(1)-1,this_point(2)+1) == 1
    connect_point(point_num,:) = [this_point(1)-1 this_point(2)+1 2];
    point_num = point_num+1;
    sta_dir = 6;
end
if img(this_point(1),this_point(2)-1) == 1
    connect_point(point_num,:) = [this_point(1) this_point(2)-1 7];
    point_num = point_num+1;
    sta_dir = 3;
end
if img(this_point(1)-1,this_point(2)-1) == 1
    connect_point(point_num,:) = [this_point(1)-1 this_point(2)-1 8];
    point_num = point_num+1;
    sta_dir = 4;
end
if img(this_point(1)+1,this_point(2)-1) == 1
    connect_point(point_num,:) = [this_point(1)+1 this_point(2)-1 6];
    point_num = point_num+1;
    sta_dir = 2;
end
if img(this_point(1)+1,this_point(2)) == 1
    connect_point(point_num,:) = [this_point(1)+1 this_point(2) 5];
    point_num = point_num+1;
    sta_dir = 1;
end
if img(this_point(1)+1,this_point(2)+1) == 1
    connect_point(point_num,:) = [this_point(1)+1 this_point(2)+1 4];
    point_num = point_num+1;
    sta_dir = 8;
end
if img(this_point(1),this_point(2)+1) == 1
    connect_point(point_num,:) = [this_point(1) this_point(2)+1 3];
    point_num = point_num+1;
    sta_dir = 7;
end
point_num = point_num -1;

