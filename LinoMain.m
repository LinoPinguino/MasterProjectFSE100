% Global variables for locations and states
global startLocation, pickUpLocation, dropOffLocation, stopSignLocation, hasGranny, taskComplete

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

% Main function to control movement and location detection
function main()
    while ~taskComplete
        pause(0.25); % Prevents excessive looping

        % Read color sensor values
        color_rgb = brick.ColorRGB(3);
        R = color_rgb(1);
        G = color_rgb(2);
        B = color_rgb(3);

        % Determine color by running function in ColorCode.lua
        color = determineColor(R, G, B);

        % Action based on detected color
        %strcmp compares two strings and returns true if they are the same
        if strcmp(color, startLocation)
            disp("At Start Location");
            backwardsT(brick, left, right);
            forwardT(brick,left,right);

        elseif strcmp(color, pickUpLocation)
            disp("At Pick-Up Location");
            if ~hasGranny
                hasGranny = true;
                disp("Granny picked up.");
                rightT(brick, left, right); 
                forwardT(brick,left,right);
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
    end
    disp("Task Complete!");
end

