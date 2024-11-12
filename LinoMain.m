% Global variables for locations and states
%global startLocation, pickUpLocation, dropOffLocation, stopSignLocation, hasGranny, taskComplete

% Define location colors
startLocation = 'Blue';
pickUpLocation = 'Yellow';
dropOffLocation = 'Green';
stopSignLocation = 'Red';

% Initialize state variables
hasGranny = false;
taskComplete = false;

% Set color sensor mode (assuming 'brick' is the object controlling the robot)
brick.SetColorMode(3, 4);

% Main function to control robot behavior
function main()
    while ~taskComplete
        pause(0.15); % Prevents excessive looping

        % Read color sensor values and assign to RGB variables
        color_rgb = brick.ColorRGB(3);
        R = color_rgb(1);
        G = color_rgb(2);
        B = color_rgb(3);

        % Determine color by running determineColor function
        color = determineColor(R, G, B);

        % First do actions based on detected color
        % strcmp compares two strings and returns true if they are the same
        if strcmp(color, startLocation)
            disp("At Start Location");
            backwardsT(brick, left, right);
            forwardT(brick,left,right);

        elseif strcmp(color, pickUpLocation)
            disp("At Pick-Up Location");
            if ~hasGranny
                disp("Granny picked up.");
                rightT(brick, left, right); 
                forwardT(brick, hasGranny = trueleft,right);
            else
                disp("Granny already picked up.");
            end

        elseif strcmp(color, dropOffLocation)
            disp("At Drop-Off Location");
            if hasGranny 
            
                taskComplete = true;
            else
                disp("Granny not yet picked up.");
            end

        elseif strcmp(color, stopSignLocation)
            disp("At Stop Sign Location");
            stopT(brick, left, right);
            forwardT(brick,left,right);

        else
            forwardT(brick,left,right);
        end

        % Enter if statement for movement

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
        else
        touch_logic(brick, spin_time, left, right, -left_speed, right_speed);




    end
    disp("Task Complete!");
end

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

%------------Function for giving control ------------%








%            vars
% -------------------------- % 
spin_time = .23;
right_distance = 50;
adjust_time = .1;
correctional_distance = 10;
safety_distance = 15;

right_speed = 44;
left_speed = 45;


target_location = pickUpLocation;


main(); % Call the main function to start robot behavior

