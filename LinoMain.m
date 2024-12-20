
% Global variables for locations and states
global key;
global startLocation;
global pickUpLocation;
global dropOffLocation;
global stopSignLocation;

% Define location colors
startLocation = 'Green';
pickUpLocation = 'Blue';
dropOffLocation = 'Yellow';
stopSignLocation = 'Red';

% Initialize state variables
hasGranny = false;
taskComplete = false;
InitKeyboard();

%            vars
% -------------------------- % 
spin_time = .23;
right_distance = 50;
adjust_time = .1;
correctional_distance = 10;
safety_distance = 30;

right_speed = 34;
left_speed = 35;

right = 'B';
left = 'A';

cycle = 0;


target_location = pickUpLocation;


% Set color sensor mode (assuming 'brick' is the object controlling the robot)
brick.SetColorMode(3, 4);

% Main function to control robot behavior
    while ~taskComplete
        pause(0.1); % Prevents excessive looping

        if mod(cycle, 2) == 0
            right_speed = 36;

        else
            right_speed = 33;
        end

        % Read color sensor values and assign to RGB variables
        color_rgb = brick.ColorRGB(3);
        R = color_rgb(1);
        G = color_rgb(2);
        B = color_rgb(3);

        % Determine color by running determineColor function
        color = determineColor(R, G, B);
        disp(color);

        % First do actions based on detected color
        % strcmp compares two strings and returns true if they are the same
        if strcmp(color, startLocation)
            disp("At Start Location");

        elseif strcmp(color, pickUpLocation)
            disp("At Pick-Up Location");
            if ~hasGranny
                pause(.2);
                stopT(brick, left, right);
                while 1
                    pause(.25)
                    switch key
                        case 'w'
                            brick.MoveMotor('AB', 20);
                        case 'd'
                            brick.MoveMotor(left, 30);
                        case 's'
                            brick.MoveMotor('AB', -20);
                        case 'a'
                            brick.MoveMotor(right, 30);
                        case 'uparrow'
                            brick.MoveMotor('C', 10);
                        case 'downarrow'
                            brick.MoveMotor('C', -10);
                        case 'q'
                            break;
                        case 0
                            stopT(brick, left, right);
                    end
                end
                hasGranny = true;
                continue;

            else
                disp("Granny already picked up.");
            end

        elseif strcmp(color, dropOffLocation)
            disp("At Drop-Off Location");
            pause(.5);
            stopT(brick, left, right);
            if hasGranny 
                brick.MoveMotor('C', -20);
                taskComplete = true;
            else
                disp("Granny not yet picked up.");
            end

        elseif strcmp(color, stopSignLocation)
            disp("At Stop Sign Location");
            stopT(brick, left, right);
            pause(1);
            forwardT(brick, left_speed, right_speed);
        end


        touched = brick.TouchPressed(2);
        if touched == 0
            disp('Going Forward');
            forwardT(brick, left_speed, right_speed);

            % check color sensor

            % all the logic for the different colors

            distance = brick.UltrasonicDist(4);

            alignUsingUltrasonic(brick, left, right, left_speed, right_speed);

            disp(distance);

            % constalntly scan the distance and and if the distance is
            % certain mark turn the robot that way
            if distance > right_distance && distance ~= 255
                disp('righting runt');
                forwardT(brick, left_speed, right_speed);
                pause(.7);
                right_turn_logic(brick, left, right, left_speed, right_speed, right_speed, R, G, B, stopSignLocation);
                continue;
            % elseif distance < correctional_distance || distance == 255
            %     right_speed = 50;
            %     disp("increasing speed");
            % elseif distance > correctional_distance && distance < safety_distance
            %     right_speed = 40;
            %     disp("correcting speed");
            end
               
            % could have isolated block in the middle with no external
            % walls connected
        else
            disp("Touched");
            touch_logic(brick, right, 40, left_speed, right_speed);
            continue;
        end


        
        cycle = cycle + 1;
    end
    disp("Task Complete!");


%--------------Functions----------------%

% Function to determine color based on RGB values
function color = determineColor(R, G, B)   
    % Threshold value for color detection, was originally 100, set to 95 because offical green wasn't being detected 
    % Possibly modify this value to improve color detection

    brightness = (R + G + B) / 3;
    if brightness < 100
        threshold = 90;
    else
        threshold = 91;
    end


    if R >= threshold && G < threshold && B < threshold
        color = 'Red';  
    elseif G >= threshold && R < threshold && B < threshold
        color = 'Green';
    elseif B >= threshold && R < threshold && G < threshold
        color = 'Blue';
    elseif R >= threshold && G >= threshold && B < threshold
        color = 'Yellow';
    else
        color = 'unknown';
    end
end


% Drake code
% Functions for movement

brick.playTone(20, 800, 500);
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

function right_turn_logic(brick, left, right, lspeed, fSpeed, flSpeed, R, G, B, stopSignLocation)
        brick.StopMotor('AB');
        pause(.4);
        rightT(brick, left, lspeed);
        pause(1.5);
        brick.StopMotor('AB');
        forwardT(brick, fSpeed, flSpeed);
        time = 0;
        while time <= 8
            pause(.15)
            distance = brick.UltrasonicDist(4);
            color = determineColor(R, G, B);

            if strcmp(color, stopSignLocation)
                stopT(brick, left, right);
                pause(1);
                forwardT(brick, fSpeed, flSpeed);
            end

            if time > 6 && distance > 50
                break
            end

            time = time + 1;
        end
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

function giveControl()
    disp('gave control');
end


% ------------ Correctional Movement -------------- %




function alignUsingUltrasonic(brick, left, right, leftSpeed, rightSpeed)
   
    distance = brick.UltrasonicDist(4);
    
   
    minThreshold = 18;
    maxThreshold = 19;
    crazyThreshold = 29;

    intenseThresholdmin = 30;
    intesnseThresholdmax = 45;

    
    if distance <= minThreshold
        % Turn slightly left 
        disp('Adjusting right');
        brick.MoveMotor(left, leftSpeed - 3); 
        brick.MoveMotor(right, rightSpeed + 3); 
        % pause(.1);
        
    
    elseif distance >= maxThreshold && distance < crazyThreshold
        % Turn slightly right 
        disp('Adjusting left');
        brick.MoveMotor(left, leftSpeed + 2); 
        brick.MoveMotor(right, rightSpeed - 2);
        % pause(.1);

    elseif distance >= intenseThresholdmin && distance <= intesnseThresholdmax
        disp('Intense adjustment');
        brick.MoveMotor(left, leftSpeed + 6); 
        brick.MoveMotor(right, rightSpeed - 6);
  
    else
        disp('Center');
        brick.MoveMotor(left, leftSpeed);
        brick.MoveMotor(right, rightSpeed);
    end
end
