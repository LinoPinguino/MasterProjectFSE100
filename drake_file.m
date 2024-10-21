global key

right = 'B';
left = 'A';

brick.playTone(20, 800, 500);


function forwardT(brick)
    brick.MoveMotor('A', 50);
    brick.MoveMotor('B', 51);
end

function leftT(brick, left, right)
    brick.MoveMotor(left, -25);
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
    pause(.25);
    switch key
        case 'w'
            disp('checking touch value');
            touched = brick.TouchPressed(2);
            if touched == 0
                disp('here')
                forwardT(brick);
                distance = brick.UltrasonicDist(4);

                % lino color testing function

                % constalntly scan the distance and and if the distance is
                % certain mark turn the robot that way 
                
                % could have isolated block in the middle with no external
                % walls connected


            elseif touched == 1
                disp('Touched');
                forwardT(brick)
                pause(.5)
                brick.StopMotor('AB');
                pause(1)
                backwardsT(brick);
                pause(.5)
                brick.StopMotor('AB')
               
                if distance > 60
                    disp('distance met going right');
                    rightT(brick, right, left);
                    pause(.5)
                    brick.StopMotor('AB')

                else
                    disp('distance not met turning left');
                    leftT(brick, right, left);
                    pause(.6);
                    brick.StopMotor('AB')

                end


            end
        case 's'
            brick.StopMotor('AB');    
    end
end
