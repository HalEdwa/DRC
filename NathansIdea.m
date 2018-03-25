%% Initialization
delete(instrfindall);
clear all;
fclose('all');
%Serial On Off
serialf = 1;

if serialf ==1
    s = serial('/dev/cu.usbmodem1421','BaudRate',9600);
    fopen(s);
end
pause(1);
%for Cam 1 for video 0 
CamVideo = 1;

if CamVideo ==1
    cam= webcam(1);
    %preview(cam)
    %cam.Brightness = 10;
    %cam.Saturation=100;
    %cam.Contrast= 95;
    %cam.BacklightCompensation=1;
else
    cam = VideoReader('QUT1.avi');
end

for po=1:1
    
    if CamVideo ==1
         rgbFrame = snapshot(cam);
         %rgbFrame = imresize(rgbFrame, 0.5);
       
       else 
         rgbFrame = readFrame(cam);
         %rgbFrame = imresize(rgbFrame, 0.25);
    end
    
end

    figure(1);
while true 
    tic
    if CamVideo ==1
         rgbFrame = snapshot(cam);
         rgbFrame = imresize(rgbFrame, 0.5);
       
       else 
         rgbFrame = readFrame(cam);
         rgbFrame = imresize(rgbFrame, 0.25);
    end
    
    imHSV = rgb2hsv(rgbFrame);
    rgbFrame = hsv2rgb(imHSV);
    imBlue = (rgbFrame(:,:,3)-(rgbFrame(:,:,1)+rgbFrame(:,:,2))/2);
    sizeFrame = size(imBlue);
    Tb = mean(mean(imBlue(:,sizeFrame(2)/2:sizeFrame(2))))+0.06;% + std(std(imBlue));
    imBlue= imBlue- Tb;
    imBlue=imbinarize(imBlue);
    
    imHSV(:,:,1)= mod(imHSV(:,:,1)+(1/3),1);
    imYellow = hsv2rgb(imHSV);
    
    imYellow = imYellow(:,:,3)-(imYellow(:,:,1)+imYellow(:,:,2))/2;
    
    Ty = mean(mean(imYellow(:,sizeFrame(2)/2:sizeFrame(2))))+0.04; %+ std(std(imYellow));
    imYellow= (imYellow- Ty);
    imYellow=imbinarize(imYellow);
    

    
    %boxPosition =mean(mean(imMagenta))
    %imMagenta=colorSegment(imHSV, [0.89,0,0], [1,1,1]);
    
   
    
    
    %Steering Left Side 
    count = 1;
    imSteerB =fliplr(imYellow(1:270,1:sizeFrame(2)/2));%(imBlue(1:170,1:sizeFrame(2)/2));
    [sel, c] = max( imSteerB ~=0, [], 2 );
    gradientb = 1.2; %c(end)/numel(c);
    interceptb = 100;
    for ir=1:size(c)
        if c(ir)>ir*gradientb+interceptb | c(ir)==1
            c(ir) = ir*gradientb+interceptb;
            count= count +1;
        end
    end
    count
    %STeering Right Side 
    imSteerY =(imBlue(1:270,sizeFrame(2)/2:sizeFrame(2)));%(imYellow(1:170,sizeFrame(2)/2:sizeFrame(2)));
    [sel, f] = max( imSteerY ~=0, [], 2 );
    gradienty = 1.2;%c(end)/numel(c);
    intercepty = 100;
    count = 1; 
    for ir=1:size(f)
        if f(ir)>ir*gradienty+intercepty | f(ir)==1
            f(ir) = ir*gradienty+intercepty;
            count= count +1;
        end
    end
    
    
    
    sum = (f-c);
    steerAngle=-(mean(sum(end-160:end)))/4+90%(mean(f))*-1.2+258
    if (steerAngle < 50)
          steerAngle = 50;
    end
    if (steerAngle > 120)
          steerAngle = 120;
    end
    
    %Visualisations
%     subplot(2, 2, 1);
%     imshow(fliplr(imYellow(1:270,1:sizeFrame(2)/2)));
%     subplot(2, 2, 2);
%     imshow((imBlue(1:270,sizeFrame(2)/2:sizeFrame(2))));
%     subplot(2, 2, 3);
%     imshow(rgbFrame);
    
%   steerAngle;
    if serialf ==1
        fwrite(s,steerAngle,'uint8');
    end
    pause(1);
    toc
end


function mask = colorSegment(I, minHSV, maxHSV)
   
    
   
    mask1 = I(:,:,1)>=minHSV(1) & I(:,:,1)<=maxHSV(1); 
    
    
    mask2 = I(:,:,2)>=minHSV(2) & I(:,:,2)<=maxHSV(2); 
    
    
    mask3 = I(:,:,3)>=minHSV(3) & I(:,:,3)<=maxHSV(3); 
    
    
    mask = mask1.*mask2.*mask3;
    

    return
end

