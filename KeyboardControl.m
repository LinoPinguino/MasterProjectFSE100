% global key

right = 'B';
left = 'A';

brick.playTone(20, 800, 500);
disp('HERE')


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

function backwardsT(brick)
    brick.MoveMotor('AB', -50);
end

disp("HERE");



brick.StopMotor('AB')
InitKeyboard();
while 1
    pause(1);
    switch key
        case 's'
            brick.SetColorMode(3, 4);
            color_rgb = brick.ColorRGB(3);
            disp(color_rgb)

       
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
brick.StopMotor('AB');