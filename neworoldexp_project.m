input ('start >>>>', 's');
PsychDefaultSetup (1);
Screen('Preference','SkipSyncTests',1);

  
try

    drctpath = 'C:\Users\PychComp\Desktop\NeworOld';

    %----------------------------------------------------------------------
    %                              WINDOW SETTING
    %----------------------------------------------------------------------

    %Define screenNumber:

    % Get the screen numbers. This gives us a number for each of the screens
    % attached to our computer.
    screens = Screen('Screens');

    % To draw we select the maximum of these numbers. So in a situation where we
    % have two screens attached to our monitor we will draw to the external
    % screen.
    screenNumber = max(screens);

    %Define rect:

    %     rect = [0 0 1280 800];

    % Define Window Colors - black, white and grey

    black = BlackIndex(screenNumber);
    white = WhiteIndex(screenNumber);
    grey = white / 2;

    % Open the window

    %[Mywindow, rect] = Screen ('OpenWindow', screenNumber,white);
    [Mywindow, windowRect] = PsychImaging('OpenWindow', screenNumber, black, []);


    % -- open screen ekranından sonra eklenecek %%
    % Flip to clear

    Screen('Flip', Mywindow);

    % Query the frame duration - interframeinterval - (minimum time between two frames) - frame elde etme.

    ifi = Screen('GetFlipInterval', Mywindow);

    % Get the size of the on screen window in pixels

    % For help see: Screen WindowSize?
    [screenXpixels, screenYpixels] = Screen('WindowSize', Mywindow);

    % Get the centre coordinate of the window in pixels
    % For help see: help RectCenter

    [xCenter, yCenter] = RectCenter(windowRect);

    % Set up alpha-blending for smooth (anti-aliased) lines
    Screen('BlendFunction', Mywindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');


    %----------------------------------------------------------------------
    %                 Stimuli and condition identfy
    %----------------------------------------------------------------------

    % identfy photo path

    drctpath = 'C:\Users\PychComp\Desktop\NeworOld'; 
    addpath (drctpath) 
    cd([drctpath '\NOphoto']); 

    % identfy old and new number (for old = 30 images ; for new = 30 images; totally = 60 images)

    old = 2 ;
    new = 2 ;
    Ntrials =  old + new;



    for  i = 1 : old

        stimulusold {i} = imread (['old' num2str(i) '.png']);


    end



    for i = 1 : new

        stimulusnew {i} = imread (['new' num2str(i) '.png']);




    end



    stimulie =[(1:old) ; (1:new) ; (1:old) ; (1:new)]'; % create matrix for stimuli
    condi =  [ones(old,1); 2*ones(new,1); ones(old,1); 2*ones(new,1)]';



    %----------------------------------------------------------------------
    %                  identify stimulus screen location
    %----------------------------------------------------------------------


    xsize=640; %image size in pixels x-dim
    ysize=720; %image size in pixels y-dim
    ysize2=ysize; % this is if I need to have different sizes
    xsize2=xsize;
    x=0; % drawing position relative to center
    y=0;
    x0 = windowRect(3)/2; % screen center
    y0 = windowRect(4)/2;
    x3 = windowRect(3)/3; % 1/3 of screen
    x4 = x3*2; %2/3 of screen
    s1=.5; %this scales the stimuli to half size
    s2=1;

    %   destrectL = [x3-s1*xsize2+x, y0-s1*ysize2+y, x3+s1*xsize2+x, ...
    %         y0+s1*ysize2+y]; % left position

    %     destrectR = [x4-s1*xsize2+x, y0-s1*ysize2+y, x4+s1*xsize2+x, ...
    %         y0+s1*ysize2+y]; %right position

    destrect = [x0-s2*xsize/2+x, y0-s2*ysize/2+y, x0+s2*xsize/2+x, ...
        y0+s2*ysize/2+y]; %center position


    %     destrectL = [xCenter/2-s1*xsize2+x, yCenter-s1*ysize2+y, xCenter/2+s1*xsize2+x, ...
    %        yCenter+s1*ysize2+y];

    destrectL = [xCenter/2-s1*xsize2+x, yCenter-s1*ysize2+y, xCenter/2+s1*xsize2+x, ...
        yCenter+s1*ysize2+y];

    destrectR = [xCenter + xsize2/2+x, yCenter-s1*ysize2+y, xCenter+960+x, ...
        yCenter+s1*ysize2+y]; %right position





    %----------------------------------------------------------------------
    %                       Timing Information
    %----------------------------------------------------------------------

    % Presentation Time for the stimulie in seconds and frames
    % We will present each element of our sequence for two seconds
    %presSecs = .50;
    %waitframes = round(presSecs/ ifi);

    % Length of time and number of frames we will use for each stimulie

    numSecs = .03;
    numFrames = round(numSecs / ifi);

    % Interstimulus interval time in seconds and frames

    %isiTimeSecs = .50;
    %isiTimeFrames = round(isiTimeSecs / ifi);



    waitframes = 1;

    % for counter-  We will be presenting each of our numbers 10 through 0 for one seconds
    % each
    presSecs = 1;
    waitframes1 = round(presSecs / ifi);

    % Flip outside of the loop to get a time stamp
    % Get an initial screen flip for timing


    vbl = Screen('Flip', Mywindow);

    %----------------------------------------------------------------------
    %                        EXP. LOOP
    %----------------------------------------------------------------------

    %--------------------- 1. Congurent Condition --------------------------



    i = 1;

    while   i  <= Ntrials*2

        % fixation point show for 0.5 s -

        % Draw the fixation point
        Screen('DrawDots', Mywindow, [xCenter; yCenter], 10, white, [], 2);

        % Flip to the screen
        vbl = Screen('Flip', Mywindow, vbl + ((waitframes - 1) - 0.5) * ifi);
        WaitSecs (.5);




        for frame = 1: numFrames

            if condi (i) == 1    % condition for trial i is old


                stimulus_id = stimulie (i);
                texture = Screen('MakeTexture', Mywindow, stimulusold {stimulus_id});
                Screen ('DrawTexture', Mywindow, texture,[], destrectL,0);



            elseif  condi (i) == 2  % condition for trial i is new

                stimulus_id = stimulie (i);
                texture = Screen('MakeTexture', Mywindow, stimulusnew{stimulus_id});
                Screen ('DrawTexture',Mywindow,texture,[], destrectR,0);


            end



            vbl  = Screen('Flip', Mywindow, vbl + (waitframes - 0.5) * ifi);
            %Screen('Flip', Mywindow)

            %WaitSecs(.30);
            %
            %KbWait;


        end

        % ---------- NEWOROLD Screen ------------- %%%

        Screen('TextSize', Mywindow, 70);
        Screen('TextFont', Mywindow, 'Times');
        DrawFormattedText(Mywindow, ' Old or New ? \n\n For Old press O \n\n For New press N ', ...
            'center', 'center',white, 0);
        Screen('Flip', Mywindow);
        KbWait;


        i = i +1;

    end

    %-----------------------------------------------------------------
    %-------------------- second part--------

    %----------------------------------------------------------------

    Screen('TextSize', Mywindow, 70);
    Screen('TextFont', Mywindow, 'Times');
    DrawFormattedText(Mywindow, 'Second Part \n\n Press Any Key To Begin', ...
        'center', 'center',white, 0);
    Screen('Flip', Mywindow);
    %WaitSecs(2);
    KbStrokeWait;


    i = 1;

    while   i  <= Ntrials*2

        % fixation point show for 0.5 s -

        % Draw the fixation point
        Screen('DrawDots', Mywindow, [xCenter; yCenter], 10, white, [], 2);

        % Flip to the screen
        vbl = Screen('Flip', Mywindow, vbl + ((waitframes - 1) - 0.5) * ifi);
        WaitSecs (.5);




        for frame = 1: numFrames

            if condi (i) == 1    % condition for trial i is old


                stimulus_id = stimulie (i);
                texture = Screen('MakeTexture', Mywindow, stimulusold {stimulus_id});
                Screen ('DrawTexture', Mywindow, texture,[], destrectR,0);



            elseif  condi (i) == 2  % condition for trial i is new

                stimulus_id = stimulie (i);
                texture = Screen('MakeTexture', Mywindow, stimulusnew{stimulus_id});
                Screen ('DrawTexture',Mywindow,texture,[], destrectL,0);


            end



            vbl  = Screen('Flip', Mywindow, vbl + (waitframes - 0.5) * ifi);
            %Screen('Flip', Mywindow)

            %WaitSecs(.30);
            %
            %KbWait;

        end




        % ---------- NEWOROLD Screen ------------- %%%

        Screen('TextSize', Mywindow, 70);
        Screen('TextFont', Mywindow, 'Times');
        DrawFormattedText(Mywindow, ' Old or New ? \n\n For Old press O \n\n For New press N ', ...
            'center', 'center',white, 0);
        Screen('Flip', Mywindow);
        KbWait;


        i = i +1;

    end



    % closing window:
    sca; % - kısa hali :  screen('CloseAll');

catch %#ok<*CTCH>
    % This "catch" section executes in case of an error in the "try"
    % section []
    % above.  Importantly, it closes the onscreen window if it's open.
    sca;
    fclose('all');
    psychrethrow(psychlasterror);
end


