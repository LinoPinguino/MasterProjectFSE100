global key

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
        pause(1);
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

%            vars
% -------------------------- % 
spin_time = .23;
right_distance = 50;
adjust_time = .1;
correctional_distance = 10;
safety_distance = 15;

right_speed = 57;
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
                    pause(.7);
                    right_turn_logic(brick, left, 40, left_speed, right_speed);
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







%Seperator

global startLocation pickUpLocation dropOffLocation stopSignLocation

startLocation = "SampleColor";
pickUpLocation = "SampleColor";
dropOffLocation = "SampleColor";
stopSignLocation = "Red";

brick.SetColorMode(3,4)
color_rgb = brick.ColorRGB(3);

R = color_rgb(1)
G = color_rgb(2)
B = color_rgb(3)

hasGranny = false;
%We keep as boolean


function color = determineColor(R, G, B)    
    threshold = 100;

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



function moveRobot(color)
    switch color
        case startLocation
            %perform certain actions, probably nothing/ignore color;
            %Continue movement or use it to initiate pathfinding code
            disp("Starting Point")
            navigateToPickUp();

        case pickUpLocation
            %give full control back to computer/break while code, we will need
            %to do something after we pick up the granny to prevent this from
            %shutting the robot down again and again once the robot in on the
            %maze again with granny on
            disp("Pick Up Point")

            if ~hasGranny
                %for pre granny pickup
                hasGranny = true;
                giveControl();  
                navigateToDropOff();
            else 
                disp("Granny already picked Up")
                %Return to pathfinding

            end
    
        case dropOffLocation
            %Give full control back to computer ONLY after having Granny ON
            disp("Drop Off Point")

            if hasGranny
                giveControl();
            else 
                disp("Granny not picked up")
                %Return to pathfinding

            return;
            
        case stopSignLocation
            %Pase movement for some seconds, continue going, prevent this code
            %from triggering consecutivley to prevent the robot from staying at
            %the stop sign forever.
            pauseMovement()
            moveForward()
            %return to pathfinding

        case 'unknown'
            disp("Unknown Color")




while color == 'unknown'
    pause(.5);
    color_rgb = brick.ColorRGB(3);
    R = color_rgb(1);
    G = color_rgb(2);
    B = color_rgb(3);
    color = determineColor(R, G, B);
    navigate();
end



 
        
