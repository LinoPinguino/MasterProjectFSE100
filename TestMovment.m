right = 'B';
left = 'A';

brick.playTone(20, 800, 500);
brick.StopAllMotors();


function forwardT(brick, left, right)
    disp("Forward");
    brick.MoveMotor(left, 50);
    brick.MoveMotor(right, 50);
    pause(.5);
    brick.StopMotor(brick, left, right);
end

function leftT(brick, left, right)
    disp("left turn");
    brick.MoveMotor(left, -50);
    brick.MoveMotor(right, 50);
    pause(.5);
    brick.StopMotor(brick, left, right);
end

function stopT(brick, left, right)
    disp("stop");
    brick.MoveMotor(left, 0);
    brick.MoveMotor(right, 0);
    pause(2);
    brick.StopMotor(brick, left, right);
end


function rightT(brick, left, right)
    disp("right turn");
    brick.MoveMotor(left, 50);
    brick.MoveMotor(right, -50);
    pause(.5);
    brick.StopMotor(brick, left, right);
end

function backwardsT(brick, left, right) 
    disp("backwards");
    brick.MoveMotor(left, -50);
    brick.MoveMotor(right, -50);
    pause(.5);
    brick.StopMotor(brick, left, right);
end
