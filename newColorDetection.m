global startLocation pickUpLocation dropOffLocation stopSignLocation

startLocation = "SampleColor";
pickUpLocation = "SampleColor";
dropOffLocation = "SampleColor";
stopSignLocation = "Red";

brick.SetColorMode(3,4)
color_rgb = brick.ColorRGB(3);

R = color_rgb(1);
G = color_rgb(2);
B = color_rgb(3);

hasGranny = false;
%We keep as boolean


function color = determineColor(R, G, B, brick)
    brightness = (R + G + B) / 3;
    base_threshold = 100;
    disp(brick.ColorRGB(3))

    
    if brightness < 100
        threshold = 50;
    else
        threshold = base_threshold;
    end

    if R >= threshold && G < threshold && B < threshold
        color = "Red";  
        disp(color)
    elseif G >= threshold && R < threshold && B < threshold
        color = 'Green';
        disp(color)
    elseif B >= threshold && R < threshold && G < threshold
        color = 'Blue';
        disp(color)

    elseif R >= threshold && G >= threshold && B < threshold
        color = 'Yellow';
        disp(color)
    else
        color = 'unknown';
    end
end



while 1
    pause(.5)
    color_rgb = brick.ColorRGB(3);
    R = color_rgb(1);
    G = color_rgb(2);
    B = color_rgb(3);
    color = determineColor(R, G, B, brick);

    switch color
        case startLocation
            %perform certain actions, probably nothing/ignore color;
            %Continue movement or use it to initiate pathfinding code
            disp("Starting Point")
    
        case pickUpLocation
            %give full control back to computer/break while code, we will need
            %to do something after we pick up the granny to prevent this from
            %shutting the robot down again and again once the robot in on the
            %maze again with granny on
             disp("Pick Up Point")
     
        case dropOffLocation
            %Give full control back to computer ONLY after having Granny ON
            disp("Drop Off Point")
   
            
        case stopSignLocation
            %Pase movement for some seconds, continue going, prevent this code
            %from triggering consecutivley to prevent the robot from staying at
            %the stop sign forever.
            %return to pathfinding
    
        case 'unknown'
            disp("Unknown Color")
            



    end

   
    
end
