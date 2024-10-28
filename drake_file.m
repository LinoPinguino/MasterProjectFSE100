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

function leftT(brick, left, right, lspeed, rspeed)
    
    disp("left");
    brick.MoveMotor(left, lspeed);
    brick.MoveMotor(right, rspeed);
end

function stopT(brick, left, right)
    disp("stop");
    brick.MoveMotor(left, 0);
    brick.MoveMotor(right, 0);
end


function rightT(brick, left, right, lspeed, rspeed)
    disp("right");
    brick.MoveMotor(left, lspeed);
    brick.MoveMotor(right, rspeed);
end

function backwardsT(brick) %#ok<*DEFNU>
    disp("backwards");
    brick.MoveMotor('AB', -50);
end

function touch_logic(brick, spin_time, left, right, lspeed, rspeed)
    disp('Wall met');
    
    forwardT(brick);
    pause(.5);
    brick.StopMotor('AB');

    disp('Backing Up');
    backwardsT(brick);
    pause(.5);
    brick.StopMotor('AB');

    disp('Turning Left');
    leftT(brick, left, right, lspeed, rspeed);
    pause(spin_time);
    brick.StopMotor('AB');

end

function right_turn_logic(brick, left, right, spin_time, lspeed, rspeed)
        brick.StopMotor('AB');
        rightT(brick, left, right, lspeed, -rspeed);
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
spin_time = .45;
right_distance = 50;
adjust_time = .1;
correctional_distance = 15;

right_speed = 50;
left_speed = 50;


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

                % check color sensor

                % all the logic for the different colors

                distance = brick.UltrasonicDist(4);

                % constalntly scan the distance and and if the distance is
                % certain mark turn the robot that way
                if distance > right_distance && distance ~= 255
                    forwardT(brick);
                    pause(1.5);
                    right_turn_logic(brick, left, right, spin_time, left_speed, right_speed);
                elseif distance < correctional_distance || distance == 255
                    disp('against wall slight adjustment');
                    leftT(brick, left, right, left_speed - 10, right_speed);
                    pause(.5);
                    brick.StopMotor('AB');
                elseif distance > correctional_distance && distance < right_distance
                    disp('far from wall slight adjustment');
                    rightT(brick, left, right, left_speed, right_speed - 10);
                    pause(.5);
                    brick.StopMotor('AB');
                end
               
                % could have isolated block in the middle with no external
                % walls connected


            elseif touched == 1
                touch_logic(brick, spin_time, left, right, -left_speed, right_speed);
            end


        case 's'
            brick.StopMotor('AB');
            stopT(brick, left, right);

        case 'g'
            grandma_pik(brick);

        case 'd'
            grandma_drop(brick);

        case 'uparrow'
            forwardT(brick);

        case 'downarrow'
            backwardsT(brick);

        case 'rightarrow'
            rightT(brick, left, right, left_speed, -right_speed);

        case 'leftarrow'
            leftT(brick, left, right, -left_speed, right_speed);

        case 'q'
            brick.StopAllMotors();
            break;
    end
end
