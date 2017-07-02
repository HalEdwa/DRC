%% Initialization
delete(instrfindall);
clear all;
fclose('all');

%Motors1 for power to motors
motors = 0;
if motors==1
s = serial('/dev/ttyACM0','BaudRate',9600);
fopen(s);
pause(2);
end 

originalfig=0;
bluefig=0;
redfig=0;
yellowfig=0;
%Set the box threshold eg 17000
boxThreshold = 1000;
obstacleThreshold= 1000;
%for Cam 1 for video 0 
CamVideo = 0;

%{
delete(instrfindall)
fclose('all');
if motors == 1
    s = serial('COM5','BaudRate',9600);
    fopen(s);
end
%}
%UI 1 for on 0 for off 
UI = 1;
r= groot;
x= 10;
screensize= get(groot, 'ScreenSize');
xcentre= (screensize(1,3)/2);
ycentre= (screensize(1,4)/2);
centre= [xcentre ycentre];

%intial Thresholding
HMaxB = 1;
HMinB = 0;
SMaxB = 1;
SMinB = 0;
VMaxB = 1;
VMinB = 0;
HMaxP=1;
HminP=0;
SMaxP= 1;
SMinP= 0;
VMaxP=1;
VMinP=0;

HMaxY = 0.6;
HMinY = 0.2;
SMaxY = 1;
SMinY = 0.2;
VMaxY = 1;
VMinY = 0;

if CamVideo ==1
    cam= webcam(1);
    %preview(cam)
    %cam.Brightness = 10;
    %cam.Saturation=100;
    %cam.Contrast= 95;
    %cam.BacklightCompensation=1;
else
    cam = VideoReader('Test1.avi');
end
centre= [0 0];
numBlobs = 1000;

hblob = vision.BlobAnalysis('AreaOutputPort', true, ... % Set blob analysis handling
                                'CentroidOutputPort', true, ... 
                                'MinimumBlobArea', 600, ...
                               'BoundingBoxOutputPort', true);
if UI ==1
    sliders = figure(3);
    %Blue Sliders
    %Hue
    HBlueMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,254,419,23],...
                  'value',HMaxB, 'min',0, 'max',1);
    HBlueMax.Callback = @(es,ed) es.Value;            
    HBlueMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,254,23,23],...
                    'String','0');
    HBlueMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,254,23,23],...
                    'String','1');
    HBlueMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,235,100,23],...
                    'String','Max Blue');    
    HBlueMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,220,419,23],...
                  'value',HMinB, 'min',0, 'max',1);
    HBlueMin.Callback = @(es,ed) es.Value; 
    HBlueMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,210,23,23],...
                    'String','0');
    HBlueMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,210,23,23],...
                    'String','1');
    HBlueMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,200,100,23],...
                    'String','Min Blue');  
    %Saturation
    SBlueMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,154,419,23],...
                  'value',SMinB, 'min',0, 'max',1);
    SBlueMax.Callback = @(es,ed) es.Value;            
    SBlueMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,154,23,23],...
                    'String','0');
    SBlueMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,154,23,23],...
                    'String','1');
    SBlueMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,135,100,23],...
                    'String','Max Blue');    
    SBlueMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,120,419,23],...
                  'value',SMinB, 'min',0, 'max',1);
    SBlueMin.Callback = @(es,ed) es.Value; 
    SBlueMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,110,23,23],...
                    'String','0');
    SBlueMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,110,23,23],...
                    'String','1');
    SBlueMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,100,100,23],...
                    'String','Min Blue'); 
    %Value
    VBlueMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,54,419,23],...
                  'value',VMaxB, 'min',0, 'max',1);
    VBlueMax.Callback = @(es,ed) es.Value;            
    VBlueMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,54,23,23],...
                    'String','0');
    VBlueMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,54,23,23],...
                    'String','1');
    VBlueMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,35,100,23],...
                    'String','Max Blue');    
    VBlueMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,20,419,23],...
                  'value',VMinB, 'min',0, 'max',1);
    VBlueMin.Callback = @(es,ed) es.Value; 
    VBlueMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,10,23,23],...
                    'String','0');
    VBlueMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,10,23,23],...
                    'String','1');
    VBlueMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,0,100,23],...
                    'String','Min Blue'); 


    %Yellow Sliders
    %Hue
    HYellowMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,554,419,23],...
                  'value',HMaxY, 'min',0, 'max',1);
    HYellowMax.Callback = @(es,ed) es.Value;  

    HYellowMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,554,23,23],...
                    'String','0');
    HYellowMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,554,23,23],...
                    'String','1');
    HYellowMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,535,100,23],...
                    'String','Max Yellow');   
    HYellowMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,520,419,23],...
                  'value',HMinY, 'min',0, 'max',1);
    HYellowMin.Callback = @(es,ed) es.Value;  
    HYellowMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,510,23,23],...
                    'String','0');
    HYellowMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,510,23,23],...
                    'String','1');
    HYellowMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,500,100,23],...
                    'String','Min Yellow'); 
    %Saturation 
    SYellowMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,454,419,23],...
                  'value',SMaxY, 'min',0, 'max',1);
    SYellowMax.Callback = @(es,ed) es.Value;  

    SYellowMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,454,23,23],...
                    'String','0');
    SYellowMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,454,23,23],...
                    'String','1');
    SYellowMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,435,100,23],...
                    'String','Max Yellow');   
    SYellowMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,420,419,23],...
                  'value',SMinY, 'min',0, 'max',1);
    SYellowMin.Callback = @(es,ed) es.Value;  
    SYellowMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,410,23,23],...
                    'String','0');
    SYellowMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,410,23,23],...
                    'String','1');
    SYellowMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,400,100,23],...
                    'String','Min Yellow'); 
    %Value 
    VYellowMax = uicontrol('Parent',sliders,'Style','slider','Position',[81,354,419,23],...
                  'value',VMaxY, 'min',0, 'max',1);
    VYellowMax.Callback = @(es,ed) es.Value;  

    VYellowMax1 = uicontrol('Parent',sliders,'Style','text','Position',[50,354,23,23],...
                    'String','0');
    VYellowMax2 = uicontrol('Parent',sliders,'Style','text','Position',[500,354,23,23],...
                    'String','1');
    VYellowMax3 = uicontrol('Parent',sliders,'Style','text','Position',[240,335,100,23],...
                    'String','Max Yellow');   
    VYellowMin = uicontrol('Parent',sliders,'Style','slider','Position',[81,320,419,23],...
                  'value',VMinY, 'min',0, 'max',1);
    VYellowMin.Callback = @(es,ed) es.Value;  
    VYellowMin1 = uicontrol('Parent',sliders,'Style','text','Position',[50,310,23,23],...
                    'String','0');
    VYellowMin2 = uicontrol('Parent',sliders,'Style','text','Position',[500,310,23,23],...
                    'String','1');
    VYellowMin3 = uicontrol('Parent',sliders,'Style','text','Position',[240,300,100,23],...
                    'String','Min Yellow'); 

         %Purple Sliders
    %Hue
    HPurpleMax = uicontrol('Parent',sliders,'Style','slider','Position',[481,254,419,23],...
                  'value',HMaxP, 'min',0, 'max',1);
    HPurpleMax.Callback = @(es,ed) es.Value;            
    HPurpleMax1 = uicontrol('Parent',sliders,'Style','text','Position',[450,254,23,23],...
                    'String','0');
    HPurpleMax2 = uicontrol('Parent',sliders,'Style','text','Position',[900,254,23,23],...
                    'String','1');
    HPurpleMax3 = uicontrol('Parent',sliders,'Style','text','Position',[640,235,100,23],...
                    'String','Max Purple');    
    HPurpleMin = uicontrol('Parent',sliders,'Style','slider','Position',[481,220,419,23],...
                  'value',HMinB, 'min',0, 'max',1);
    HPurpleMin.Callback = @(es,ed) es.Value; 
    HPurpleMin1 = uicontrol('Parent',sliders,'Style','text','Position',[450,210,23,23],...
                    'String','0');
    HPurple2 = uicontrol('Parent',sliders,'Style','text','Position',[900,210,23,23],...
                    'String','1');
    HPurpleMin3 = uicontrol('Parent',sliders,'Style','text','Position',[640,200,100,23],...
                    'String','Min Purple');  
    %Saturation
    SPurpleMax = uicontrol('Parent',sliders,'Style','slider','Position',[481,154,419,23],...
                  'value',SMinP, 'min',0, 'max',1);
    SPurpleMax.Callback = @(es,ed) es.Value;            
    SPurpleMax1 = uicontrol('Parent',sliders,'Style','text','Position',[450,154,23,23],...
                    'String','0');
    SPurpleMax2 = uicontrol('Parent',sliders,'Style','text','Position',[900,154,23,23],...
                    'String','1');
    SPurpleMax3 = uicontrol('Parent',sliders,'Style','text','Position',[640,135,100,23],...
                    'String','Max Purple');    
    SPurpleMin = uicontrol('Parent',sliders,'Style','slider','Position',[481,120,419,23],...
                  'value',SMinP, 'min',0, 'max',1);
    SPurpleMin.Callback = @(es,ed) es.Value; 
    SPurpleMin1 = uicontrol('Parent',sliders,'Style','text','Position',[450,110,23,23],...
                    'String','0');
    SPurpleMin2 = uicontrol('Parent',sliders,'Style','text','Position',[900,110,23,23],...
                    'String','1');
    SPurpleMin3 = uicontrol('Parent',sliders,'Style','text','Position',[640,100,100,23],...
                    'String','Min Blue'); 
    %Value
    VPurpleMax = uicontrol('Parent',sliders,'Style','slider','Position',[481,54,419,23],...
                  'value',VMaxB, 'min',0, 'max',1);
    VPurpleMax.Callback = @(es,ed) es.Value;            
    VPurpleMax1 = uicontrol('Parent',sliders,'Style','text','Position',[450,54,23,23],...
                    'String','0');
    VPurpleMax2 = uicontrol('Parent',sliders,'Style','text','Position',[900,54,23,23],...
                    'String','1');
    VPurpleMax3 = uicontrol('Parent',sliders,'Style','text','Position',[640,35,100,23],...
                    'String','Max Purple');    
    VPurpleMin = uicontrol('Parent',sliders,'Style','slider','Position',[481,20,419,23],...
                  'value',VMinP, 'min',0, 'max',1);
    VPurpleMin.Callback = @(es,ed) es.Value; 
    VPurpleMin1 = uicontrol('Parent',sliders,'Style','text','Position',[450,10,23,23],...
                    'String','0');
    VPurpleMin2 = uicontrol('Parent',sliders,'Style','text','Position',[900,10,23,23],...
                    'String','1');
    VPurpleMin3 = uicontrol('Parent',sliders,'Style','text','Position',[640,0,100,23],...
                    'String','Min Purple'); 

           
     pause(0.1); 
end
    

while true
    % Acquire a single image.
   tic
       if CamVideo ==1
         rgbFrame = snapshot(cam);
         rgbFrame = imresize(rgbFrame, 0.5);
       else 
         rgbFrame = readFrame(cam);
         rgbFrame = imresize(rgbFrame, 0.25);
       end
       if UI ==1
           figure(1);
           imshow(rgbFrame);
       end
           % Convert RGB to  HSV
   image = rgb2hsv(rgbFrame);
   I = image;
   
   %for blue. Note, the values = colour wheel value/360
   %basically make everything not b;lue = nothing. dark blue =0.7 -0.65
   
   pause(0.1); 
   bmask = I(:,:,1)>=HBlueMin.Value & I(:,:,1)<=HBlueMax.Value & I(:,:,2)>=SBlueMin.Value & I(:,:,2)<=SBlueMax.Value & I(:,:,3)>=VBlueMin.Value & I(:,:,3)<=VBlueMax.Value;
   binblue=imfill(bmask,'holes'); 
   ymask = I(:,:,1)>=HYellowMin.Value & I(:,:,1)<=HYellowMax.Value & I(:,:,2)>=SYellowMin.Value & I(:,:,2)<=SYellowMax.Value & I(:,:,3)>=VYellowMin.Value & I(:,:,3)<=VYellowMax.Value;
   binyellow=imfill(ymask,'holes'); 
   pmask = I(:,:,1)>=HPurpleMin.Value & I(:,:,1)<=HPurpleMax.Value & I(:,:,2)>=SPurpleMin.Value & I(:,:,2)<=SPurpleMax.Value & I(:,:,3)>=VPurpleMin.Value & I(:,:,3)<=VPurpleMax.Value;
   binpurple=imfill(pmask,'holes'); 
  
 
   
[areaYellow,centroidYellow, bboxYellow] = step(hblob, binyellow); % Get the centroids and bounding boxes of the blue blobs
    centroidYellow = int16(centroidYellow); % Convert the centroids into Integer for further steps
    [areaY, idxY] = max(areaYellow(:)); %finds the largest area
    xCntdY = centroidYellow(idxY,1); %x value corresponding to largest centroid
    yCntdY = centroidYellow(idxY,2);%y value corresponding to largest centroid
    j = 1;
    if size(xCntdY,1)~=0
        for i = 1:numel(xCntdY)
            if bboxYellow(i,3)*bboxYellow(i,4) < boxThreshold
                bboxYellowClear(j) = i;
                j = j+1;
            end
        end
    end   
        
           if exist('bboxYellowClear')
                bboxYellow(bboxYellowClear,:) = [];
                xCntdY(bboxYellowClear) = [];
                yCntdY(bboxYellowClear) = [];
                bboxYellowClear = [];
           end
           
            if UI ==1
                figure(2);
                imshow(binyellow);
                hold on;
            end 
            if UI ==1
                for i = 1:numel(xCntdY)
                    plot(xCntdY(i),yCntdY(i),'y*');
                    plot(bboxYellow(i,1):bboxYellow(i,1)+bboxYellow(i,3),bboxYellow(i,2),'y*','linewidth',0.5);
                    plot(bboxYellow(i,1):bboxYellow(i,1)+bboxYellow(i,3),bboxYellow(i,2)+bboxYellow(i,4),'y*','linewidth',0.5);
                    plot(bboxYellow(i,1),bboxYellow(i,2):bboxYellow(i,2)+bboxYellow(i,4),'y*','linewidth',0.5);
                    plot(bboxYellow(i,1)+bboxYellow(i,3),bboxYellow(i,2):bboxYellow(i,2)+bboxYellow(i,4),'y*','linewidth',0.5);
                end
             end
        
        hold off;
    
    [areaBlue,centroidBlue, bboxBlue] = step(hblob, binblue); % Get the centroids and bounding boxes of the blue blobs
    centroidBlue = int16(centroidBlue); % Convert the centroids into Integer for further steps
    [areaB, idxB] = max(areaBlue(:)); %finds the largest area
    xCntdB = centroidBlue(idxB,1); %x value corresponding to largest centroid
    yCntdB = centroidBlue(idxB,2);%y value corresponding to largest centroid
    j = 1;
    if size(xCntdB,1) ~=0
                 for i = 1:numel(xCntdB)
                    if bboxBlue(i,3)*bboxBlue(i,4) < boxThreshold
                        bboxBlueClear(j) = i;
                        j = j+1;
                    end
                 end
    end            
        if exist('bboxBlueClear')
         bboxBlue(bboxBlueClear,:) = [];
        xCntdB(bboxBlueClear) = [];
        yCntdB(bboxBlueClear) = [];
        end
        bboxBlueClear = [];
        if UI ==1
            figure(4);
            imshow(binblue);
            hold on;
        end
        if UI ==1
            for i = 1:numel(xCntdB)
                plot(xCntdB(i),yCntdB(i),'b*');
                plot(bboxBlue(i,1):bboxBlue(i,1)+bboxBlue(i,3),bboxBlue(i,2),'b*','linewidth',0.5);
                plot(bboxBlue(i,1):bboxBlue(i,1)+bboxBlue(i,3),bboxBlue(i,2)+bboxBlue(i,4),'b*','linewidth',0.5);
                plot(bboxBlue(i,1),bboxBlue(i,2):bboxBlue(i,2)+bboxBlue(i,4),'b*','linewidth',0.5);
                plot(bboxBlue(i,1)+bboxBlue(i,3),bboxBlue(i,2):bboxBlue(i,2)+bboxBlue(i,4),'b*','linewidth',0.5);
            end
        end
     hold off;   
     
    
  [areaPurple,centroidPurple, bboxPurple] = step(hblob, binpurple); % Get the centroids and bounding boxes of the blue blobs
    centroidPurple = int16(centroidPurple); % Convert the centroids into Integer for further steps
    [maxareaP, idxP] = max(areaPurple(:)); %finds the largest area
    xCntdP = centroidPurple(idxP,1); %x value corresponding to largest centroid
    yCntdP = centroidPurple(idxP,2);%y value corresponding to largest centroid

    j = 1;
    if size(xCntdP,1) ~=0
        for i = 1:numel(xCntdP)
            if bboxPurple(i,3)*bboxPurple(i,4) < boxThreshold
                bboxPurpleClear(j) = i;
                j = j+1;
            end
        end
    end
        if exist('bboxPurpleClear')
        bboxPurple(bboxPurpleClear,:) = [];
        xCntdP(bboxPurpleClear) = [];
        yCntdP(bboxPurpleClear) = [];
        end
        bboxPurpleClear = [];
        if UI ==1
            figure(5);
            imshow(binpurple);
            hold on;
           end
        if UI ==1
            for i = 1:numel(xCntdP)
                plot(xCntdP(i),yCntdP(i),'r*');
                plot(bboxPurple(i,1):bboxPurple(i,1)+bboxPurple(i,3),bboxPurple(i,2),'r*','linewidth',0.5);
                plot(bboxPurple(i,1):bboxPurple(i,1)+bboxPurple(i,3),bboxPurple(i,2)+bboxPurple(i,4),'r*','linewidth',0.5);
                plot(bboxPurple(i,1),bboxPurple(i,2):bboxPurple(i,2)+bboxPurple(i,4),'r*','linewidth',0.5);
                plot(bboxPurple(i,1)+bboxPurple(i,3),bboxPurple(i,2):bboxPurple(i,2)+bboxPurple(i,4),'r*','linewidth',0.5);
            end
        end
    hold off;    
   
   %if else loop for the obstacle. Assume Blue left, yellow right.

   %if motors ==1
   wheelAngle=0;
   lhs=[];
   rhs=[];
          if (size(xCntdY,1)==0) & ~(size(xCntdB,1)==0)
             wheelAngle= 60;
            lhs= abs(xCntdB-xcentre);
            rhs=[];
             elseif ~(size(xCntdY,1)==0) & (size(xCntdB,1)==0)
                 wheelAngle= 120;
                rhs= abs(xCntdY-xcentre);
                lhs=[];
             elseif ~(size(xCntdB,1)==0) & ~(size(xCntdY,1)==0)
               rhs= abs(xcentre-xCntdY);
               nope=1
               lhs= abs(xCntdB-xcentre);
                  if maxareaP > obstacleThreshold %obstacle is a problem
                      if abs(xCntdB-xCntdP)< abs(xCntdY-xCntdP) %if the purple is on the RHS, new RHS is purple
                          xcentre= xcentre+abs(xCntdB-xCntdP); %new centre
                          lhs= abs(xCntdP-xcentre);
                       elseif  abs(xCntdB-xCntdP)> abs(xCntdY-xCntdP) 
                          xcentre= xcentre-abs(xCntdB-xCntdP);
                           rhs= abs(xcentre-xCntdP);
                      end
                  elseif max(areaPurple)< obstacleThreshold
                          xcentre= (screensize(1,3)/2);
                          rhs= abs(xCntdB-xcentre);
                          lhs= abs(xcentre-xCntdY);
                  end
          
          elseif (size(xCntdB,1)==0) & (size(xCntdY,1)==0);
          wheelAngle=90;   
              fail=1
              lhs=[];
              rhs=[];
          end        
    % end
   
 %  if motors ==1
   %wheelAngle =90;
%if else loop for the wheels

   if ~(size(lhs,1)==0) & ~(size(rhs,1)==0)
        if lhs>rhs
            wheelAngle= 120%*(lhs*0.001)
        elseif lhs<rhs
            wheelAngle=60%90*(rhs*0.001)
        elseif lhs==rhs
            wheelAngle=90;
        end
    elseif ~(size(lhs,1)==0) & (size(rhs,1)==0)
        wheelAngle= 120%*(lhs*0.001);
    elseif (size(lhs,1)==0) & ~(size(rhs,1)==0)
        wheelAngle= 60%120*(rhs*0.001);
   elseif (size(lhs,1)==0) & (size(rhs,1)==0)
        wheelAngle=90;
        here=1
    end
    
%    if ~exist('lhs')
%           wheelAngle= 120;
%    elseif exist('rhs')
%           
%        c
%    else 
%        wheelAngle=90;
%    end   
       wheelAngle
       if motors==1         
        fwrite(s,wheelAngle,'uint8');
                 pause(0.05)   
        end
        
   
   %end
             toc
end


%else
    %return 0;


%clear('cam');