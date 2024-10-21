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

InitKeyboard();
while 1
    pause(1);
    switch key
        case 'space'
            if brick.TouchPressed(1) == 0
                forwardT(brick);
                %% lino color testing function


            elseif brick.TouchPressed(1) == 1


                if brick.UltrasonicDist(4) > 5
                    rightT(brick, right, left);
                else
                    leftT(brick, right, left);
                end


            end
    end
end