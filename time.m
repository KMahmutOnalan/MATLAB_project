
%input ('start >>>>', 's');

function [results] = time(subject) % eddxddp. call command window

try

    PsychDefaultSetup (1);
    Screen('Preference','SkipSyncTests',0);


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
    [Mywindow, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, []);



    % -- open screen ekranından sonra eklenecek %%
    % Flip to clear

    Screen('Flip', Mywindow);

    % Query the frame duration - interframeinterval - (minimum time between two frames) - frame elde etme.

     Screen('GetFlipInterval', Mywindow);

    % Get the size of the on screen window in pixels

    % For help see: Screen WindowSize?
    [screenXpixels, screenYpixels] = Screen('WindowSize', Mywindow);

    % Get the centre coordinate of the window in pixels
    % For help see: help RectCenter

    [xCenter, yCenter] = RectCenter(windowRect);

    % Set up alpha-blending for smooth (anti-aliased) lines
    Screen('BlendFunction', Mywindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    %----------------------------------------------------------------------
    %                       WINDOW SETTING FINESHED
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    %                 Stimuli and condition identfy
    %----------------------------------------------------------------------

    drctpath = 'C:\Users\PychComp\Desktop\exp4a'; 
    addpath (drctpath) 

    % Trial BLOCKS

    [~,~,deneme] = xlsread('trial.xlsx');
    trials = deneme (:,1); % stimuli (totally 4 stimuli)
    trial1 = deneme (:,2); % past or future (1 = past, 2 = future)
    trial2 = deneme(:,3); % 1 = white blok - 2  =  black blok


    % CONGRUENT CONDITION

    [~,~,VorNonV1] = xlsread('pastfutureword1.xlsx');

    show1 = VorNonV1 (:,1); % stimulie
    condition11 = VorNonV1 (:,2); % past or future
    condition12 = VorNonV1(:,3);  % verb or nonverb
    condition13 = VorNonV1 (:,4); % congruent

    % INCONGRUENT CONDITION

    [~,~,VorNonV2] = xlsread('pastfutureword2.xlsx');

    show2 = VorNonV2 (:,1); % stimulie
    condition21 = VorNonV2 (:,2); % past or future
    condition22 = VorNonV2(:,3);  % verb or nonverb
    condition23 = VorNonV2 (:,4); % incongruent





    %----------------------------------------------------------------------
    %            Randomization of stimulus/ condition order
    %----------------------------------------------------------------------

%     rng("shuffle")

    seed = round(sum(10 * clock)); % set a "random" seed for this experimental session
    rng(seed)

    % trial Randomization

    
    random_ordert = randperm(length(trials));
    trials = trials(random_ordert);   % stimulie were randomized
    trial2 = trial2(random_ordert);   % white and black blocks were randomized

    %fixation_timet = rand (length(trials),1) * (0.3 - 0.2) + 0.2;


    % Randomization 1

    %seed1 = round(sum(10 * clock)); % set a "random" seed for this experimental session
    %rng(seed1)
    random_order1 = randperm(length(show1));  % assing random order to stimuli-

    show1 = show1(random_order1);   % stimulie were randomized
    condition11 = condition11(random_order1); % Past and furture condition were randondomized
    condition12 = condition12(random_order1); % verb and nonverb condition were randomized

    %fixation_time1 = rand (length(show1),1) * (0.3 - 0.2) + 0.2; % fixationcross were randomized (200- 300 ms)

    % Randomization 2

    %seed2 = round(sum(10 * clock)); % set a "random" seed for this experimental session
    %rng(seed2)

    random_order2 = randperm(length(show2));  % assing random order to stimuli-

    show2 = show2(random_order2);   % stimulie were randomized
    condition21 = condition21(random_order2); % Past and furture condition were randondomized
    condition22 = condition22(random_order2); % verb and nonverb condition were randomized

    %fixation_time2 = rand (length(show2),1) * (0.3 - 0.2) + 0.2; % fixationcross were randomized (200- 300 ms)





    %----------------------------------------------------------------------
    %    Create vectors to save subject's responses : key pressed,
    %              correct/error and RT for each trial
    %
    %----------------------------------------------------------------------




    % Congruent Condition - for response 1 - response matrix

    response_key1 = cell(length(show1),1);

    response_correct1 = NaN(length(show1),1);

    response_time1 = NaN(length(show1),1);


    % InCongruent Condition - for response 2 - response matrix

    response_key2 = cell(length(show2),1);

    response_correct2 = NaN(length(show2),1);

    response_time2 = NaN(length(show2),1);




    %----------------------------------------------------------------------
    %                       Clock Information
    %----------------------------------------------------------------------

    % Starting number

    currentNumber = 60;  % 1 minutes
    %color identfy
    color = black;
    % We set the text size to be nice and big here
    Screen('TextSize', Mywindow, 300);

    Screen('Flip', Mywindow);



    % ---------------------------------------------------------------------
    %            WelCome Screen and İnstruction
    %----------------------------------------------------------------------


   
    Screen ('TextFont', Mywindow, 'Arial');
    Screen ('TextSize', Mywindow, 40);

    DrawFormattedText(Mywindow, ['Hoşgeldiniz\n\n Bu çalışma iki kısımdan oluşmaktadır. \n\n Her iki kısımda da aşağıda verilen görevi yerine getirmeniz beklenmektedir. ' ...
        '\n\n Görev: \n\n   ' ...
        'Her bir sabitleme noktasından sonra ekranda bir kelime belirecektir. \n\n Ekrana çıkan her bir kelimeyi geçmişe ya da geleceğe atıfta bulunacak şekilde kategorize etmelisiniz.\n\n Örneğin, "çıktı" kelimesi GEÇMİŞ olarak kategorize edilirken, "çıkacak" kelimesi GELECEK olarak kategorize edilecektir.\n\n' ...
        'Ekranda beliren her kelimenin geçmişle mi yoksa gelecekle mi ilgili olduğuna mümkün olduğunca hızlı ve doğru bir şekilde karar vermelisiniz.\n\n  ' ...
        ' \n\n   ' ...
        '\n\n Deneme aşamasına geçmek için herhangi bir tuşa basın'], ...
        'center', 'center', 0);
    Screen ('Flip', Mywindow);
    WaitSecs(4);
    KbStrokeWait;

    
    % -----------------------------------------------------
    %                  DENEME BLOGU
    % ------------------------------------------------------

    for i = 1: length (trials)


        % Draw the fixation point -
        Screen('DrawDots', Mywindow, [xCenter; yCenter], 20, [86, 101, 115], [], 2);
        Screen('Flip', Mywindow);
        WaitSecs(0.5); % 200- 300 ms


        % add blanck screen - Blanck screen ms 400 ms yap

        Screen('FillRect', Mywindow, grey, []);
        Screen('Flip', Mywindow);
        WaitSecs(0.5);


        if trial2 {i} == 1

            Screen('TextSize', Mywindow, 120);
            Screen('TextFont', Mywindow, 'Arial');
            DrawFormattedText(Mywindow, char(trials(i,:)), 'center','center', white, 0);

        elseif trial2 {i} == 2

            Screen('TextSize', Mywindow, 120);
            Screen('TextFont', Mywindow, 'Arial');
            DrawFormattedText(Mywindow, char(trials(i,:)), 'center','center', black, 0);

        end

        Screen('Flip', Mywindow);
        KbWait();

    end




    Screen ('TextFont', Mywindow, 'Arial');
    Screen ('TextSize', Mywindow, 35);
    DrawFormattedText(Mywindow, 'Deneme aşaması bitmiştir \n\n Birinci bölüme başlamak için bir tuşa basın \n\n',...
        'center', 'center', black);
    Screen('Flip', Mywindow);
    WaitSecs(1);
    KbStrokeWait;




    %----------------------------------------------------------------------
    %                        EXP. LOOP
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    %---------------------- 1. Congurent Condition --------------------------


    for  i = 1 : length(show1)



        % Draw the fixation point
        Screen('DrawDots', Mywindow, [xCenter; yCenter], 20, [86, 101, 115], [], 2);
        Screen('Flip', Mywindow);
        WaitSecs(0.5); % 200 - 300 ms


        % add blanck screen - 400 ms değiştir.
        Screen('FillRect', Mywindow, grey, []);
        Screen('Flip', Mywindow);
        WaitSecs(0.5);


        %if condition12 {i} ==1  % word condition

            if condition11{i} == 1 % pastverbs


                Screen('TextSize', Mywindow, 120);
                Screen('TextFont', Mywindow, 'Arial');
                DrawFormattedText(Mywindow, char(show1(i,:)),'center','center', black, 0); % for DRAWFORMATTEDTEXT need char for string



            elseif condition11{i} == 2% futureverbs


                Screen('TextSize', Mywindow, 120);
                Screen('TextFont', Mywindow, 'Arial');
                DrawFormattedText(Mywindow, char(show1(i,:)), 'center','center',white, 0); % for DRAWFORMATTEDTEXT need char for string


            end


       % elseif condition12 {i} == 2 % nonverb condition

            %if condition11{i} == 1 % pastverbs


%                 Screen('TextSize', Mywindow, 120);
%                 Screen('TextFont', Mywindow, 'Arial');
%                 DrawFormattedText(Mywindow, char(show1(i,:)), 'center','center', black, 0); % for DRAWFORMATTEDTEXT need char for string



            %elseif condition11{i} == 2 % futureverbs


%                 Screen('TextSize', Mywindow, 120);
%                 Screen('TextFont', Mywindow, 'Arial');
%                 DrawFormattedText(Mywindow, char(show1(i,:)), 'center','center',white, 0); % for DRAWFORMATTEDTEXT need char for string


            %end



        %end

        Screen('Flip', Mywindow);


        % collecting responses (key pressed and RT) and saving them in a vector

        try

            FlushEvents ('KeyDown'); % Removing the queue of events for key presses
            t1 = GetSecs;
            time1 = 0;

            while time1 < 100000

                [keyIsDown,t2, keyCode] = KbCheck; % determine state of keyboard
                time1 =  (t2 - t1)*1000; % convert to ms

                if (keyIsDown) % has a key been pressed ?

                    key1 = KbName (find(keyCode));  % find key's name
                    response_key1{i} = key1;
                    response_time1(i) = time1;


                    % checking whether responses are correct, and saving them in a
                    % vector

                    if condition11 {i} == 1 && strcmp (response_key1{i}, 'd') == 1  % pastverb and bottom key (d)
                        response_correct1(i) = 1;   % it's correct


                    elseif condition11 {i} == 1 && strcmp (response_key1{i}, 'f') == 1  % pastverb and up key (f)
                        response_correct1(i) = 0;  % it's error

                    elseif condition11 {i} == 2 && strcmp (response_key1{i}, 'd') == 1  % future and bottom key (d)
                        response_correct1(i) = 0;  % it's 


                    elseif condition11 {i} == 2 && strcmp (response_key1{i}, 'f') == 1  % future and up key (d)
                        response_correct1(i) = 1;  % it's correct


                    end

                    break;

                end
            end

        catch

        end

    end % for -  end



    % -------------------- SECOND PART --------------------------------


    % ---- From 120 to 0 --- Counter

    while currentNumber >= 0

        % Convert our current number to display into a string
        numberString = num2str(currentNumber);

        % Draw our number to the screen
        DrawFormattedText(Mywindow, numberString, 'center', 'center', color);

        % Flip to the screen
        Screen('Flip', Mywindow);

        % Increment the number
        currentNumber = currentNumber - 1;

        WaitSecs(1);


    end


    Screen('TextSize', Mywindow, 35);
    Screen('TextFont', Mywindow, 'Arial');
    DrawFormattedText(Mywindow, 'İkinci bölüme başlamak için bir tuşa basın', ...
        'center', 'center', 0);
    Screen('Flip', Mywindow);
    KbStrokeWait;


    % -------------------- SECOND PART ------------------------------------

    %----------------------------------------------------------------------

    % ------------------2. Incongurent Condition --------------------------


    for  i = 1 : length(show2)



        % Draw the fixation point
        Screen('DrawDots', Mywindow, [xCenter; yCenter], 20, [86, 101, 115], [], 2);
        Screen('Flip', Mywindow);
        WaitSecs(0.5);


        % add blanck screen - 400 ms 
        Screen('FillRect', Mywindow, grey, []);
        Screen('Flip', Mywindow);
        WaitSecs(0.5);


        %if condition22 {i} ==1  % word condition

            if condition21{i} == 1 % pastverbs


                Screen('TextSize', Mywindow, 120);
                Screen('TextFont', Mywindow, 'Arial');
                DrawFormattedText(Mywindow, char(show2(i,:)), 'center','center', white, 0); % for DRAWFORMATTEDTEXT need char for string



            elseif condition21{i} == 2 % futureverbs


                Screen('TextSize', Mywindow, 120);
                Screen('TextFont', Mywindow, 'Arial');
                DrawFormattedText(Mywindow, char(show2(i,:)), 'center','center',black, 0); % for DRAWFORMATTEDTEXT need char for string


            end




        %elseif condition22 {i} == 2 % nonverb condition

%             if condition21{i} == 1 % pastverbs
% 
% 
%                 Screen('TextSize', Mywindow, 120);
%                 Screen('TextFont', Mywindow, 'Arial');
%                 DrawFormattedText(Mywindow, char(show2(i,:)), 'center','center', white, 0); % for DRAWFORMATTEDTEXT need char for string
% 
% 
% 
%             elseif condition21{i} == 2 % futureverbs
% 
% 
%                 Screen('TextSize', Mywindow, 120);
%                 Screen('TextFont', Mywindow, 'Arial');
%                 DrawFormattedText(Mywindow, char(show2(i,:)), 'center','center',black, 0); % for DRAWFORMATTEDTEXT need char for string
% 
% 
%             end

       % end

        Screen('Flip', Mywindow);



        % ----collecting responses (key pressed and RT) and saving them in a vector----

        try

            FlushEvents ('KeyDown'); % Removing the queue of events for key presses
            t1 = GetSecs;
            time2 = 0;

            while time2 < 1000000

                [keyIsDown,t2, keyCode] = KbCheck; % determine state of keyboard
                time2 = (t2 - t1)*1000;  % * 1000 - convert from second to millisecond

                if (keyIsDown) % has a key been pressed ?

                    key2 = KbName (find(keyCode));  % find key's name
                    response_key2{i} = key2;
                    response_time2(i) = time2;


                    % checking whether responses are correct, and saving them in a
                    % vector

                    if condition21 {i} == 1 && strcmp (response_key2{i}, 'd') == 1  % pastverb and bottom key (d)
                        response_correct2(i) = 1;  % it's correct


                    elseif condition21 {i} == 1 && strcmp (response_key2{i}, 'f') == 1  % pastverb and up key (f)
                        response_correct2(i) = 0;  % it's error

                    elseif condition21 {i} == 2 && strcmp (response_key2{i}, 'd') == 1  % future and bottom key (d)
                        response_correct2(i) = 0; % it's error


                    elseif condition21 {i} == 2 && strcmp (response_key2{i}, 'f') == 1  % future and up key (f)
                        response_correct2(i) = 1;  % it's correct


                    end

                    break;

                end
            end

        catch

        end


    end % for -  end




    % End of experiment screens. We clear the screen once they have made theirresponse


    Screen ('TextFont', Mywindow, 'Arial');
    Screen ('TextSize', Mywindow, 35);
    DrawFormattedText(Mywindow, 'Çalışmayı tamamladınız. \n\n Katılımınız için teşekkürler ! \n\n',...
        'center', 'center', black);
    Screen('Flip', Mywindow);
    KbStrokeWait;


    Screen('FillRect', Mywindow, grey, []);
    Screen('Flip', Mywindow);
    WaitSecs(5);
    KbStrokeWait;





    %----------------------------------------------------------------------
    %                      Saving Responses
    %----------------------------------------------------------------------

    results.subject = subject;

    % Congruent Condition  results :

    %results.seed1    = seed1;
    results.ntrials1 = length(show1);
    results.stimulus.id1 = show1;
    results.stimulus.condition11 = condition11;
    results.stimulus.condition12 = condition12;
    results.stimulus.condition13 = condition13;
    %results.stimulus.fixation_time1 = fixation_time1;

    results.response.key1 = response_key1;
    results.response.time1 = response_time1;
    results.response.correct1 = response_correct1;
 
    % Incongruent Condition  results :



    %results.seed2    = seed2;
    results.ntrials2 = length(show2);
    results.stimulus.id2 = show2;
    results.stimulus.condition21 = condition21;
    results.stimulus.condition22 = condition22;
    results.stimulus.condition23 = condition23;
    %results.stimulus.fixation_time2 = fixation_time2;

    results.response.key2 = response_key2;
    results.response.time2 = response_time2;
    results.response.correct2 = response_correct2;

    % create  tables  for  responses

    results.T1 = table(results.stimulus.id1, results.stimulus.condition11, results.stimulus.condition12, ...
        results.stimulus.condition13,results.response.key1, results.response.time1,results.response.correct1);

    results.T2= table (results.stimulus.id2,results.stimulus.condition21, results.stimulus.condition22, results.stimulus.condition23, ...
       results.response.key2,results.response.time2, results.response.correct2);


    cd([drctpath '\results1']);

    df = sprintf('time_Subject%d.xlsx', subject);
    fout=sprintf('time_Subject%d.mat', subject);
    save(fout, 'results');
    writetable(results.T1,df,'Sheet',1);
    writetable(results.T2,df,'Sheet',2);


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