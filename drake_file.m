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


        % here discuss with group on what we want to do going forward

        % either add a pause every certain time frame and check around 
        % or just follow the left side of the maze until we get to the location we need to be
        while distance > 15
            forwardT(brick);
            distance = brick.UltrasonicDist(4);
        end
        brick.stopMotor('AB');
        



            % brick.SetColorMode(3, 4);
            % color_rgb = brick.ColorRGB(3);
            % disp(color_rgb)

       
            % while 1
            %     disp("STARTING");
            %     distance = brick.UltrasonicDist(4);
            %     disp(distance);
            %     if distance < 15
            %         disp('Distance req met');
            %         leftT(brick, left, right);
            %         pause(1);
            %         brick.StopMotor('AB');
            %     elseif distance > 15
            %         disp('Distance req met');
            %         rightT(brick, left, right);
            %         pause(1);
            %         brick.StopMotor('AB');
            %     elseif distance == 255
            %         disp('Stopping')
            %         brick.StopMotor('AB')
            %         pause(5);
            % 
            %         break
            %     end
            % end
        case 'q'
            disp("STOPPING");
            brick.StopMotor('AB');
    end
end

% 
% 
% 
% InitKeyboard();
% pause(1);
% while 1
%     pause(.25);
%     switch key
%         case 'w'
%             disp('Forward');
%             brick.MoveMotor('AB', 100);
%         case 's'
%             disp('Backwards');
%              brick.MoveMotor('AB', -50);
%         case 'a'
%             disp('Left');
%             brick.MoveMotor(right, 100);
%             brick.MoveMotor(left, 25);
%         case 'd'
%             disp('Right');
%             brick.MoveMotor(left, 100);
%             brick.MoveMotor(right, 25);
%         case 'o'
%             brick.MoveMotor('C', 50);
%         case 'l'
%             brick.MoveMotor('C', -50);
%         case 0
%             disp('No direction');
%             brick.StopMotor('ABC');
%         case 'q'
%             break
%     end
% end
% 
% 