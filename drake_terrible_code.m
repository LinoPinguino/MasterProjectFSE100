% global key

right = 'B';
left = 'A';

brick.playTone(20, 800, 500);


function forwardT(brick)
    brick.MoveMotor('AB', 50);
end

function leftT(brick, left, right)
    brick.MoveMotor(left, -50);
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



function directInit(brick, left, right, direction)

    % getting forward direction
    direction(3) = brick.UltrasonicDist(4);

    % moving towards the right dir
    rightT(brick, left, right);
    pause(2);
    brick.StopMotor('AB');
    direction(2) = brick.UltrasonicDist(4);

    % moving towards the left dir
    leftT(brick, left, right);
    pause(2);
    brick.StopMotor('AB');
    direction(1) = brick.UltrasonicDist(4);

    % moving towards the back dir
    leftT(brick, left, right);
    pause(2);
    brick.StopMotor('AB');
    direction(4) = brick.UltrasonicDist(4); %#ok<*NASGU>

    % move the robor backtowards 'forward'
    rightT(brick, left, right);
    pause(4);
    brick.StopMotor('AB');


end

left_d = 0;
right_d = 0;
forward_d = 0;
back_d = 0;
direction = [left_d, right_d, forward_d, back_d];


InitKeyboard();
while 1
    pause(1);
    switch key
        case 'space'

        directInit(brick, left, right, direction);

        % calc the direction with the most distance
        [D, I] = max(direction(:));

        % turn the robot in the direction of the max distance
        switch I
            case 1
                disp('Turning left');
                leftT(brick, left, right);
                pause(2);
                brick.StopMotor('AB');
            case 2
                disp('Turning right');
                rightT(brick, left, right);
                pause(2);
                brick.StopMotor('AB');
            case 3
                disp('already forward');
            case 4
                disp('Turning back');
                leftT(brick, left, right);
                pause(4);
                brick.StopMotor('AB');
        end

        while distance > 15
            forwardT(brick);
            distance = brick.UltrasonicDist(4);
        end
        brick.stopMotor('AB');

    end
end