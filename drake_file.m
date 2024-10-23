global key

right = 'B';
left = 'A';

brick.playTone(20, 800, 500);


function forwardT(brick)
    brick.MoveMotor('A', 50);
    brick.MoveMotor('B', 51);
end

function leftT(brick, left, right)
    brick.MoveMotor(left, -25);
    brick.MoveMotor(right, 50);
end

function stopT(brick, left, right)
    brick.MoveMotor(left, 0);
    brick.MoveMotor(right, 0);
end


function rightT(brick, left, right)
    brick.MoveMotor(left, 50);
    brick.MoveMotor(right, -50);
end

function backwardsT(brick) %#ok<*DEFNU>
    brick.MoveMotor('AB', -50);
end



function touch_logic(brick, spin_time, left, right)
    disp('Wall met');
    
    forwardT(brick);
    pause(.5);
    brick.StopMotor('AB');

    disp('Backing Up');
    backWardsT(brick);
    pause(.5);
    brick.StopMotor('AB');

    disp('Turning Left');
    leftT(brick, left, right);
    pause(spin_time);
    brick.StopMotor('AB');

end

function right_turn_logic(right_distance, distance, brick, left, right, spin_time)
    if distance > right_distance
        brick.StopMotor('AB');
        rightT(brick, left, right);
        pause(spin_time);
    end
end

%            vars
% -------------------------- % 
spin_time = .6;
right_distance = 30;

right_speed = 0;
left_speed = 0;



InitKeyboard();
while 1
    pause(.25);
    switch key
        case 'w'
            disp('checking touch value');
            touched = brick.TouchPressed(2);
            if touched == 0
                disp('Going Forward');
                forwardT(brick);


                distance = brick.UltrasonicDist(4);

                % constalntly scan the distance and and if the distance is
                % certain mark turn the robot that way 
                right_turn_logic(right_distance, distance, brick, left, right, spin_time);
               
                % could have isolated block in the middle with no external
                % walls connected


            elseif touched == 1
                touch_logic(brick, spin_time, left, right);


            end
        case 's'
            brick.StopMotor('AB');    
    end
end



%                       notes 
% ------------------------------------------------------ %

% robot goes forward instantly
% while constantly scanning the RIGHT side for distance
% if the distance on the right side is greater than _
%   turn right 
% 
% else go foward until a wall then turn left




% for the going forward part of the code implemtent:
%   a straigtening technique
%   constantly checking for color ( lino )



% there could be a part where the maze has isolated block
% make a timing function which sets GRUB to spin around and do the maze reverse