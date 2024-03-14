function[connect_point,point_num] = FindConnect(img,this_point)
point_num = 0;
connect_point = [0 0 0];
switch this_point(3)
    case 1
        if img(this_point(1)-1,this_point(2)+1) == 1
            connect_point(1,:) = [this_point(1)-1 this_point(2)+1 2];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1) this_point(2)+1 3];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2)+1 4];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2) 5];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2)-1 6];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1) this_point(2)-1 7];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)-1) == 1
            connect_point(1,:) = [this_point(1)-1 this_point(2)-1 8];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)) == 1
            connect_point(1,:) = [this_point(1)-1 this_point(2) 1];
            point_num = point_num+1;
        end
        
    case 2
        if img(this_point(1)-1,this_point(2)) == 1
            connect_point(1,:) = [this_point(1)-1 this_point(2) 1];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)+1) == 1
            connect_point(1,:) = [this_point(1) this_point(2)+1 3];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2)+1 4];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2) 5];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2)-1 6];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1) this_point(2)-1 7];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2)-1 8];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)+1) == 1
            connect_point(1,:) = [this_point(1)-1 this_point(2)+1 2];
            point_num = point_num+1;
        end
        
    case 3
        if img(this_point(1)-1,this_point(2)) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2) 1];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)+1) == 1
            connect_point(1,:) = [this_point(1)-1 this_point(2)+1 2];
            point_num = point_num+1;
        end

        if img(this_point(1)+1,this_point(2)+1) == 1
            connect_point(1,:) = [this_point(1)+1 this_point(2)+1 4];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2) 5];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2)-1 6];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1) this_point(2)-1 7];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2)-1 8];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)+1) == 1
            connect_point(1,:) = [this_point(1) this_point(2)+1 3];
            point_num = point_num+1;
        end
        
    case 4
        if img(this_point(1)-1,this_point(2)) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2) 1];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2)+1 2];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)+1) == 1
            connect_point(1,:) = [this_point(1) this_point(2)+1 3];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)) == 1
            connect_point(1,:) = [this_point(1)+1 this_point(2) 5];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2)-1 6];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1) this_point(2)-1 7];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2)-1 8];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)+1) == 1
            connect_point(1,:) = [this_point(1)+1 this_point(2)+1 4];
            point_num = point_num+1;
        end
        
    case 5
        if img(this_point(1)-1,this_point(2)) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2) 1];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2)+1 2];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1) this_point(2)+1 3];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)+1) == 1
            connect_point(1,:) = [this_point(1)+1 this_point(2)+1 4];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)-1) == 1
            connect_point(1,:) = [this_point(1)+1 this_point(2)-1 6];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1) this_point(2)-1 7];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2)-1 8];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)) == 1
            connect_point(1,:) = [this_point(1)+1 this_point(2) 5];
            point_num = point_num+1;
        end
        
    case 6
        if img(this_point(1)-1,this_point(2)) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2) 1];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2)+1 2];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1) this_point(2)+1 3];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2)+1 4];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)) == 1
            connect_point(1,:) = [this_point(1)+1 this_point(2) 5];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)-1) == 1
            connect_point(1,:) = [this_point(1) this_point(2)-1 7];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2)-1 8];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)-1) == 1
            connect_point(1,:) = [this_point(1)+1 this_point(2)-1 6];
            point_num = point_num+1;
        end
        
    case 7
        if img(this_point(1)-1,this_point(2)) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2) 1];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2)+1 2];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1) this_point(2)+1 3];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2)+1 4];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2) 5];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)-1) == 1
            connect_point(1,:) = [this_point(1)+1 this_point(2)-1 6];
            point_num = point_num+1;
        end

        if img(this_point(1)-1,this_point(2)-1) == 1
            connect_point(1,:) = [this_point(1)-1 this_point(2)-1 8];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)-1) == 1
            connect_point(1,:) = [this_point(1) this_point(2)-1 7];
            point_num = point_num+1;
        end
        
    case 8
        if img(this_point(1)-1,this_point(2)) == 1
            connect_point(1,:) = [this_point(1)-1 this_point(2) 1];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1)-1 this_point(2)+1 2];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1) this_point(2)+1 3];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)+1) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2)+1 4];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2) 5];
            point_num = point_num+1;
        end
        if img(this_point(1)+1,this_point(2)-1) == 1
            %connect_point(1,:) = [this_point(1)+1 this_point(2)-1 6];
            point_num = point_num+1;
        end
        if img(this_point(1),this_point(2)-1) == 1
            connect_point(1,:) = [this_point(1) this_point(2)-1 7];
            point_num = point_num+1;
        end
        if img(this_point(1)-1,this_point(2)-1) == 1
            connect_point(1,:) = [this_point(1)-1 this_point(2)-1 8];
            point_num = point_num+1;
        end
end
