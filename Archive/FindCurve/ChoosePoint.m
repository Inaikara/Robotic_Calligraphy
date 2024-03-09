function[choose_point] = ChoosePoint(direction,connect_point)
choose_point = [0 0 0];
if direction == [0 0]
    choose_point = connect_point(1,:);
else
    if (direction(1)>=0) && (direction(2)>=0) %下右
        if (abs(direction(1)) > abs(direction(2)))
            if ismember(5,connect_point(:,3)) == 1
                [m,~] = find(connect_point(:,3) == 5);
                choose_point = connect_point(m,:);
            else
                if ismember(4,connect_point(:,3)) == 1
                    [m,~] = find(connect_point(:,3) == 4);
                    choose_point = connect_point(m,:);
                else
                    if ismember(6,connect_point(:,3)) == 1
                        [m,~] = find(connect_point(:,3) == 6);
                        choose_point = connect_point(m,:);
                    else
                        if ismember(3,connect_point(:,3)) == 1
                            [m,~] = find(connect_point(:,3) == 3);
                            choose_point = connect_point(m,:);
                        end
                    end
                end
            end
        end
        if (abs(direction(1)) < abs(direction(2)))
            if ismember(3,connect_point(:,3)) == 1
                [m,~] = find(connect_point(:,3) == 3);
                choose_point = connect_point(m,:);
            else
                if ismember(4,connect_point(:,3)) == 1
                    [m,~] = find(connect_point(:,3) == 4);
                    choose_point = connect_point(m,:);
                else
                    if ismember(2,connect_point(:,3)) == 1
                        [m,~] = find(connect_point(:,3) == 2);
                        choose_point = connect_point(m,:);
                    else
                        if ismember(5,connect_point(:,3)) == 1
                            [m,~] = find(connect_point(:,3) == 5);
                            choose_point = connect_point(m,:);
                        end
                    end
                end
            end
        end
        if (abs(direction(1)) == abs(direction(2)))
            if ismember(4,connect_point(:,3)) == 1
                [m,~] = find(connect_point(:,3) == 4);
                choose_point = connect_point(m,:);
            else
                if ismember(5,connect_point(:,3)) == 1
                    [m,~] = find(connect_point(:,3) == 5);
                    choose_point = connect_point(m,:);
                else
                    if ismember(3,connect_point(:,3)) == 1
                        [m,~] = find(connect_point(:,3) == 3);
                        choose_point = connect_point(m,:);
                    end
                end
            end
        end
    end
    
    if (direction(1)>=0) && (direction(2)<=0) %下右
        if (abs(direction(1)) > abs(direction(2)))
            if ismember(5,connect_point(:,3)) == 1
                [m,~] = find(connect_point(:,3) == 5);
                choose_point = connect_point(m,:);
            else
                if ismember(6,connect_point(:,3)) == 1
                    [m,~] = find(connect_point(:,3) == 6);
                    choose_point = connect_point(m,:);
                else
                    if ismember(4,connect_point(:,3)) == 1
                        [m,~] = find(connect_point(:,3) == 4);
                        choose_point = connect_point(m,:);
                    else
                        if ismember(7,connect_point(:,3)) == 1
                            [m,~] = find(connect_point(:,3) == 7);
                            choose_point = connect_point(m,:);
                        end
                    end
                end
            end
        end
        if (abs(direction(1)) < abs(direction(2)))
            if ismember(7,connect_point(:,3)) == 1
                [m,~] = find(connect_point(:,3) == 7);
                choose_point = connect_point(m,:);
            else
                if ismember(6,connect_point(:,3)) == 1
                    [m,~] = find(connect_point(:,3) == 6);
                    choose_point = connect_point(m,:);
                else
                    if ismember(8,connect_point(:,3)) == 1
                        [m,~] = find(connect_point(:,3) == 8);
                        choose_point = connect_point(m,:);
                    else
                        if ismember(5,connect_point(:,3)) == 1
                            [m,~] = find(connect_point(:,3) == 5);
                            choose_point = connect_point(m,:);
                        end
                    end
                end
            end
        end
        if (abs(direction(1)) == abs(direction(2)))
            if ismember(6,connect_point(:,3)) == 1
                [m,~] = find(connect_point(:,3) == 6);
                choose_point = connect_point(m,:);
            else
                if ismember(5,connect_point(:,3)) == 1
                    [m,~] = find(connect_point(:,3) == 5);
                    choose_point = connect_point(m,:);
                else
                    if ismember(7,connect_point(:,3)) == 1
                        [m,~] = find(connect_point(:,3) == 7);
                        choose_point = connect_point(m,:);
                    end
                end
            end
        end
    end
    
    if (direction(1)<=0) && (direction(2)>=0) %下右
        if (abs(direction(1)) > abs(direction(2)))
            if ismember(1,connect_point(:,3)) == 1
                [m,~] = find(connect_point(:,3) == 1);
                choose_point = connect_point(m,:);
            else
                if ismember(2,connect_point(:,3)) == 1
                    [m,~] = find(connect_point(:,3) == 2);
                    choose_point = connect_point(m,:);
                else
                    if ismember(8,connect_point(:,3)) == 1
                        [m,~] = find(connect_point(:,3) == 8);
                        choose_point = connect_point(m,:);
                    else
                        if ismember(3,connect_point(:,3)) == 1
                            [m,~] = find(connect_point(:,3) == 3);
                            choose_point = connect_point(m,:);
                        end
                    end
                end
            end
        end
        if (abs(direction(1)) < abs(direction(2)))
            if ismember(3,connect_point(:,3)) == 1
                [m,~] = find(connect_point(:,3) == 3);
                choose_point = connect_point(m,:);
            else
                if ismember(2,connect_point(:,3)) == 1
                    [m,~] = find(connect_point(:,3) == 2);
                    choose_point = connect_point(m,:);
                else
                    if ismember(4,connect_point(:,3)) == 1
                        [m,~] = find(connect_point(:,3) == 4);
                        choose_point = connect_point(m,:);
                    else
                        if ismember(1,connect_point(:,3)) == 1
                            [m,~] = find(connect_point(:,3) == 1);
                            choose_point = connect_point(m,:);
                        end
                    end
                end
            end
        end
        if (abs(direction(1)) == abs(direction(2)))
            if ismember(2,connect_point(:,3)) == 1
                [m,~] = find(connect_point(:,3) == 2);
                choose_point = connect_point(m,:);
            else
                if ismember(1,connect_point(:,3)) == 1
                    [m,~] = find(connect_point(:,3) == 1);
                    choose_point = connect_point(m,:);
                else
                    if ismember(3,connect_point(:,3)) == 1
                        [m,~] = find(connect_point(:,3) == 3);
                        choose_point = connect_point(m,:);
                    end
                end
            end
        end
    end
    
    if (direction(1)<=0) && (direction(2)<=0) %下右
        if (abs(direction(1)) > abs(direction(2)))
            if ismember(1,connect_point(:,3)) == 1
                [m,~] = find(connect_point(:,3) == 1);
                choose_point = connect_point(m,:);
            else
                if ismember(8,connect_point(:,3)) == 1
                    [m,~] = find(connect_point(:,3) == 8);
                    choose_point = connect_point(m,:);
                else
                    if ismember(2,connect_point(:,3)) == 1
                        [m,~] = find(connect_point(:,3) == 2);
                        choose_point = connect_point(m,:);
                    else
                        if ismember(7,connect_point(:,3)) == 1
                            [m,~] = find(connect_point(:,3) == 7);
                            choose_point = connect_point(m,:);
                        end
                    end
                end
            end
        end
        if (abs(direction(1)) < abs(direction(2)))
            if ismember(7,connect_point(:,3)) == 1
                [m,~] = find(connect_point(:,3) == 7);
                choose_point = connect_point(m,:);
            else
                if ismember(8,connect_point(:,3)) == 1
                    [m,~] = find(connect_point(:,3) == 8);
                    choose_point = connect_point(m,:);
                else
                    if ismember(6,connect_point(:,3)) == 1
                        [m,~] = find(connect_point(:,3) == 6);
                        choose_point = connect_point(m,:);
                    else
                        if ismember(1,connect_point(:,3)) == 1
                            [m,~] = find(connect_point(:,3) == 1);
                            choose_point = connect_point(m,:);
                        end
                    end
                end
            end
        end
        if (abs(direction(1)) == abs(direction(2)))
            if ismember(8,connect_point(:,3)) == 1
                [m,~] = find(connect_point(:,3) == 8);
                choose_point = connect_point(m,:);
            else
                if ismember(7,connect_point(:,3)) == 1
                    [m,~] = find(connect_point(:,3) == 7);
                    choose_point = connect_point(m,:);
                else
                    if ismember(1,connect_point(:,3)) == 1
                        [m,~] = find(connect_point(:,3) == 1);
                        choose_point = connect_point(m,:);
                    end
                end
            end
        end
    end
end
    
    
      