
% Global variables for locations and states
global key;
%global startLocation, pickUpLocation, dropOffLocation, stopSignLocation, hasGranny, taskComplete

% Define location colors
startLocation = 'Blue';
pickUpLocation = 'Yellow';
dropOffLocation = 'Green';
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

right_speed = 44;
left_speed = 45;

cycle = 0;


target_location = pickUpLocation;


% Set color sensor mode (assuming 'brick' is the object controlling the robot)
brick.SetColorMode(3, 4);

% Main function to control robot behavior
    while ~taskComplete
        pause(0.15); % Prevents excessive looping

        if mod(cycle, 2) == 0
            right_speed = 46;
        else
            right_speed = 44;
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
            stopT(brick, left, right);
            pause(3);
            forwardT(brick, left_speed, right_speed);

        elseif strcmp(color, pickUpLocation)
            disp("At Pick-Up Location");
            pause(3);
            if ~hasGranny
                disp("Granny picked up.");
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
            stopT(brick, left, right);
            pause(3);
            if hasGranny 
            
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

            % constalntly scan the distance and and if the distance is
            % certain mark turn the robot that way
            if distance > right_distance && distance ~= 255
                disp('righting runt');
                forwardT(brick, left_speed, right_speed);
                pause(.5);
                right_turn_logic(brick, left, left_speed, right_speed, right_speed);
            elseif distance < correctional_distance || distance == 255
                right_speed = 50;
                disp("increasing speed");
            elseif distance > correctional_distance && distance < safety_distance
                right_speed = 40;
                disp("correcting speed");
            end
               
            % could have isolated block in the middle with no external
            % walls connected
        else
            disp("Touched");
            touch_logic(brick, right, 40, left_speed, right_speed);
        end


        %alignUsingUltrasonic(brick, left, right, left_speed, right_speed);
        
        cycle = cycle + 1;
    end
    disp("Task Complete!");


%--------------Functions----------------%

% Function to determine color based on RGB values
function color = determineColor(R, G, B)   
    % Threshold value for color detection, was originally 100, set to 95 because offical green wasn't being detected 
    % Possibly modify this value to improve color detection
    threshold = 95;      

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

right = 'B';
left = 'A';

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

function right_turn_logic(brick, left, lspeed, fSpeed, flSpeed)
        brick.StopMotor('AB');
        pause(.4);
        rightT(brick, left, lspeed);
        pause(.9);
        brick.StopMotor('AB');
        forwardT(brick, fSpeed, flSpeed);
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

function giveControl()
    disp('gave control');
end


% ------------ Correctional Movement -------------- %




function alignUsingUltrasonic(brick, left, right, leftSpeed, rightSpeed)
   
    distance = brick.UltrasonicDist(4);
    
   
    minThreshold = 20; 
    maxThreshold = 35; 

    
    if distance <= minThreshold
        % Turn slightly left 
        disp('Adjusting right');
        brick.MoveMotor(left, leftSpeed - 1); 
        brick.MoveMotor(right, rightSpeed + 1); 
        pause(0.3); 
        
    elseif distance >= maxThreshold
        % Turn slightly right 
        disp('Adjusting left');
        brick.MoveMotor(left, leftSpeed + 1); 
        brick.MoveMotor(right, rightSpeed - 1); 
        pause(0.3); 
    else
        disp('Center');
        brick.MoveMotor(left, leftSpeed);
        brick.MoveMotor(right, rightSpeed);
    end
end
