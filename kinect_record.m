function kinect_record

close all
clear
imaqreset;

%video source
kinect_rgb = videoinput('kinect', 1);
kinect_depth = videoinput('kinect', 2);

%Timeout
kinect_rgb.TimeOut = Inf;
kinect_depth.TimeOut = Inf;

%FrameGrabInterval
kinect_rgb.FrameGrabInterval = 1;
kinect_depth.FrameGrabInterval = 1;

%LoggingMode
kinect_rgb.LoggingMode = 'disk';
kinect_depth.LoggingMode = 'disk';

%FramesPerTrigger
kinect_rgb.FramesPerTrigger = 1;
kinect_depth.FramesPerTrigger = 1;

kinect_rgb.TriggerRepeat = Inf;
kinect_depth.TriggerRepeat = Inf;

% Folder to store videos
cd 'folder/to/store/videos/'

%video writers
timestamp = datestr(now,'mm-dd-yyyy_HH-MM-SS');
title_rgb = strcat(timestamp,'-kinect_rgb.mp4');
title_depth = strcat(timestamp,'-kinect_depth.mj2');

figure('Name', 'Video Recording Preview');
vidRes = kinect_depth.VideoResolution;
hImage = image( zeros(vidRes(2), vidRes(1)) );
preview(kinect_depth, hImage);

chan = [kinect_rgb kinect_depth];
c = uicontrol('String', 'Rec Start');
c.Callback = @mystart;

function mystart(src,event)
    v1 = VideoWriter(title_rgb,'MPEG-4');
    v1.Quality = 100;
    v1.FrameRate = 30;
    kinect_rgb.DiskLogger = v1;

    v2 = VideoWriter(title_depth,'Motion JPEG 2000');
    v2.LosslessCompression = true;
    v2.FrameRate = 30;
    kinect_depth.DiskLogger = v2;
    start(chan)
   
    c = uicontrol('String', 'Rec Stop');
    c.Callback = @mystop;

    function mystop(src,event)
        c.Callback = '';
        c = uicontrol('String', 'Writing');
        stop(kinect_depth)
        stop(kinect_rgb)
        delete(chan);
        clear chan
        c = uicontrol('String', 'Done');
    end
end

end