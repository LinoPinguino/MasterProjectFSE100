global key

right = 'B';
left = 'A';

brick.playTone(20, 800, 500);
brick.StopAllMotors();


function forwardT(brick)
    disp("Forward");
    brick.MoveMotor('A', 50);
    brick.MoveMotor('B', 51);
end

function leftT(brick, left, right)
    disp("left");
    brick.MoveMotor(left, -50);
    brick.MoveMotor(right, 50);
end

function stopT(brick, left, right)
    disp("stop");
    brick.MoveMotor(left, 0);
    brick.MoveMotor(right, 0);
end


function rightT(brick, left, right)
    disp("right");
    brick.MoveMotor(left, 50);
    brick.MoveMotor(right, -50);
end

function backwardsT(brick) %#ok<*DEFNU>
    disp("backwards");
    brick.MoveMotor('AB', -50);
end

function control_transfer(brick, key)
    brick.playTone(20, 800, 500);
    disp(key);
    switch key
        case 'uparrow'
            forwardT(brick);
        case 'downarrow'
            backwardsT(brick);
        case 'rightarrow'
            rightT(brick, left, right);
        case 'leftarrow'
            leftT(brick, left, right);
    end
end



function touch_logic(brick, spin_time, left, right)
    disp('Wall met');
    
    forwardT(brick);
    pause(.5);
    brick.StopMotor('AB');

    disp('Backing Up');
    backwardsT(brick);
    pause(.5);
    brick.StopMotor('AB');

    disp('Turning Left');
    leftT(brick, left, right);
    pause(spin_time);
    brick.StopMotor('AB');

end

function right_turn_logic(brick, left, right, spin_time)
        brick.StopMotor('AB');
        rightT(brick, left, right);
        pause(spin_time);
        brick.StopMotor('AB');
        forwardT(brick);
        pause(1);
end

function grandma_pik(brick)
    brick.MoveMotor('C', 30);
    pause(.2);
    brick.StopMotor('C');
    
end

function grandma_drop(brick)
    brick.MoveMotor('C', -20);
    pause(.5);
    brick.StopMotor('C');
end

%            vars
% -------------------------- % 
spin_time = .6;
right_distance = 50;

right_speed = 0;
left_speed = 0;

InitKeyboard();
while 1
    pause(.25);
    disp(key)
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
                if distance > right_distance && distance ~= 255
                    right_turn_logic(right_distance, distance, brick, left, right, spin_time);
                end
               
                % could have isolated block in the middle with no external
                % walls connected


            elseif touched == 1
                touch_logic(brick, spin_time, left, right);

            end

        case 's'
            brick.StopMotor('AB');

        case 'g'
            grandma_pik(brick);

        case 'd'
            grandma_drop(brick);

        case 'c'


      %  case 'uparrow'
       %     forwardT(brick);
%
 %       case 'downarrow'
  %          backwardsT(brick);
%
 %       case 'rightarrow'
  %          rightT(brick, left, right);
%
 %       case 'leftarrow'
  %          leftT(brick, left, right);
%
        case 'q'
            break;
    end
end

brick.StopAllMotors();
