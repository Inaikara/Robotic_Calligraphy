function[direction] = Direction(choose_point,direction_1)
direction = [0 0];
switch choose_point(3)
    case 1
        direction = [direction_1(1)-1 direction_1(2)];
    case 2
        direction = [direction_1(1)-1 direction_1(2)+1];
    case 3
        direction = [direction_1(1) direction_1(2)+1];
    case 4
        direction = [direction_1(1)+1 direction_1(2)+1];
    case 5
        direction = [direction_1(1)+1 direction_1(2)];
    case 6
        direction = [direction_1(1)+1 direction_1(2)-1];
    case 7
        direction = [direction_1(1) direction_1(2)-1];
    case 8
        direction = [direction_1(1)-1 direction_1(2)-1];
    case 0
        direction = [direction_1(1) direction_1(2)];
end
        

