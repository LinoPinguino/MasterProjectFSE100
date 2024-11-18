global key

right = 'B';
left = 'A';

brick.StopAllMotors();



function forwardT(brick, leftSpeed, rightSpeed)
    disp("Forward");
    brick.MoveMotor('A', leftSpeed);
    brick.MoveMotor('B', rightSpeed);
end

function leftT(brick, right, rspeed)
    disp("left");
    brick.MoveMotor(right, rspeed);
end

function stopT(brick, left, right)
    disp("stop");
    brick.MoveMotor(left, 0);
    brick.MoveMotor(right, 0);
end


function rightT(brick, left, lspeed)
    disp("right");
    brick.MoveMotor(left, lspeed);
end

function backwardsT(brick) %#ok<*DEFNU>
    disp("backwards");
    brick.MoveMotor('AB', -50);
end

function touch_logic(brick, right, rspeed, fSpeed, flSpeed)
    disp('Wall met');
    
    forwardT(brick, fSpeed, flSpeed);
    pause(.43);
    brick.StopMotor('AB');

    disp('Backing Up');
    backwardsT(brick);
    pause(.85);
    brick.StopMotor('AB');

    disp('Turning Left');
    leftT(brick, right, rspeed);
    pause(.947);
    brick.StopMotor('AB');

end

function right_turn_logic(brick, left, lspeed, fSpeed, flSpeed)
        brick.StopMotor('AB');
        pause(.4);
        rightT(brick, left, lspeed);
        pause(1.22);
        brick.StopMotor('AB');
        forwardT(brick, fSpeed, flSpeed);
        pause(.8);
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
spin_time = .23;
right_distance = 50;
adjust_time = .1;
correctional_distance = 10;
safety_distance = 15;

right_speed = 44;
left_speed = 45;

has_granny = false;


startLocation = "Yellow";
pickUpLocation = "Blue";
dropOffLocation = "Green";
stopSignLocation = "Red";

target_location = pickUpLocation;

brick.SetColorMode(3,4)


InitKeyboard();
while 1
    pause(.15);
    disp(key)
    switch key

        case 'w'
            color_rgb = brick.ColorRGB(3);
            R = color_rgb(1);
            G = color_rgb(2);
            B = color_rgb(3);
            color = determineColor(R, G, B);

            disp(color);

            disp('checking touch value');
            touched = brick.TouchPressed(2);
            if touched == 0
                color = determineColor(R, G, B);
                if strcmp(color, "unknown") == 1

                    disp('Going Forward');
                    forwardT(brick, left_speed, right_speed);
    
                    % check color sensor
    
                    % all the logic for the different colors
    
                    distance = brick.UltrasonicDist(4);
    
                    % constalntly scan the distance and and if the distance is
                    % certain mark turn the robot that way
                    disp(distance);
                    if distance > right_distance
                        disp(distance);
                        disp("turning right becuase of distance");
                        forwardT(brick, left_speed, right_speed);
                        color;
                        if strcmp(color, "Red") == 1
                            brick.StopMotor('AB');
                            pause(1);
                            brick.playTone(20, 800, 500);
                            forwardT(brick, left_speed, right_speed);
                            pause(.1);

                        end
                        pause(1.1);
                        right_turn_logic(brick, left, 40, left_speed, right_speed);
                    end

                elseif strcmp(color, "Red")
                    % stop for one second
                    stopT(brick, left, right);
                    pause(1);
                    forwardT(brick, left_speed, right_speed);
                    pause(.2);
                    forwardT(brick, left_speed, right_speed);

                elseif strcmp(color, "Blue")
                    if ~has_granny 
                        has_granny = true;         
                    end

                    if target_location == pickUpLocation
                        % stop beep two times
                        stopT(brick, left, right);
                        brick.playTone(20, 800, 500);
                        pause(1);
                        brick.playTone(20, 800, 500);
                        disp('transfer control');
                        forwardT(brick, left_speed, right_speed);
                        pause(.6);
                        target_location = dropOffLocation;
                    end
                
                elseif strcmp(color, "Green")
                    % if target_location == dropOffLocation
                        disp('reading greed')
                        % stop and beep three times
                        stopT(brick, left, right)
                        brick.playTone(20, 800, 500);
                        pause(1);
                        brick.playTone(20, 800, 500);
                        pause(1);
                        brick.playTone(20, 800, 500);
                        pause(1);
                        disp('whatever yellow does');
                        forwardT(brick, left_speed, right_speed);
                        pause(.6);
                    % end

                end


                % could have isolated block in the middle with no external
                % walls connected


            elseif touched == 1
                touch_logic(brick, right, 40, left_speed, right_speed);
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
            rightT(brick, left, 40);
            pause(1);
            brick.StopMotor('AB')
            pause(1)

        case 'leftarrow'
            leftT(brick, right, 40);
            pause(.947);
            brick.StopMotor('AB');
            pause(1);

        case 'q'
            brick.StopAllMotors();
            break;
    end
end

brick.SetColorMode(3,4)
color_rgb = brick.ColorRGB(3);

R = color_rgb(1);
G = color_rgb(2);
B = color_rgb(3);

hasGranny = false;
%We keep as boolean


function color = determineColor(R, G, B)   
    % brightness = (R + G + B) / 3;
    % base_threshold = 100;
    % disp(brick.ColorRGB(3))
    % 
    % 
    % if brightness < 150
    %     threshold = 95;
    % else
    %     threshold = base_threshold;
    % end
    threshold = 90;

    if R >= threshold && G < threshold && B < threshold
        color = "Red";  
    elseif G >= threshold && R < threshold && B < threshold
        color = "Green";
    elseif B >= threshold && R < threshold && G < threshold
        color = "Blue";
    elseif R >= threshold && G >= threshold && B < threshold
        color = "Yellow";
    else
        color = "unknown";
    end
end

function alignUsingUltrasonic(brick, left, right, leftSpeed, rightSpeed)
   
    distance = brick.UltrasonicDist(4);
    
   
    minThreshold = 15; 
    maxThreshold = 27; 

    
    if distance <= minThreshold
        % Turn slightly left 
        disp('Adjusting right');
        brick.MoveMotor(left, leftSpeed - 10); 
        brick.MoveMotor(right, rightSpeed + 10); 
        pause(0.3); 
        brick.StopMotor('AB');
        
    elseif distance >= maxThreshold
        % Turn slightly right 
        disp('Adjusting left');
        brick.MoveMotor(left, leftSpeed + 10); 
        brick.MoveMotor(right, rightSpeed - 10); 
        pause(0.3); 
        brick.StopMotor('AB');
    else
        disp('Center');
        brick.MoveMotor(left, leftSpeed);
        brick.MoveMotor(right, rightSpeed);
    end
end
