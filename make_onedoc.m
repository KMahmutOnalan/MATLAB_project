

folderPath = '';

excelFilePath = '';

startRow=1;

for k= 1:46

    matFileName = fullfile(folderPath, sprintf('time_Subject%d.mat',k));

    try

        %load the current . mat file 

        loadedData = load(matFileName);

       % Assuming each .mat file contains exactly two tables
        % Get the names of the table variables dynamically

        tableVarNames = fieldnames(loadedData.results);

        % Extract both tables

        table1 = loadedData.results.(tableVarNames{6});
        table2= loadedData.results.(tableVarNames{7});

        % Add the participant_id column
        table1.participant_id = repmat(k, height(table1), 1);
        table2.participant_id = repmat(k,height(table2), 1);

        % Initialize the new column with empty strings
        table1.condition = repmat({''}, height(table1), 1); 
        table2.condition = repmat({''}, height(table2), 1);

        % Apply conditions to the first table
        for i = 1: height(table1)

             if  (table1.Var4{i} == 1 ) && (table1.Var2{i} == 1)

            table1.condition{i} = {'past_black'};
         
             elseif  (table1.Var4{i} == 1) && (table1.Var2{i} == 2)

            table1.condition{i} = {'future_white'};
            
        else

            error('Unsupported variable types for Var4 and Var2 in table1.');
             end

        end
       

        % Apply conditions to the second table

        for i = 1:height(table2)

             if   (table2.Var4{i} == 2) && (table2.Var2{i} == 1)

          table2.condition{i}= {'past_white'};
            
             elseif  (table2.Var4{i} ==  2) && (table2.Var2{i}== 2)

             table2.condition{i} = {'future_black'};

             else

            error('Unsupported variable types for Var4 and Var2 in table2.');

        end

            
        end
       
      
         %create a cell array for header with K value

        header = {['Participant_id', num2str(k)]};

        writecell (header,excelFilePath,'Sheet','Sheet1', 'Range',sprintf('A%d',startRow));

        startRow = startRow +1 ; 

        writetable(table1,excelFilePath,'Sheet','Sheet1', 'Range',sprintf('A%d',startRow));

        startRow = startRow + height(table1)+ 1;

        header = {['Participant_id', num2str(k)]};

        writecell (header,excelFilePath,'Sheet','Sheet1', 'Range',sprintf('A%d',startRow));

        startRow = startRow +1 ; 

        writetable(table2,excelFilePath,'Sheet','Sheet1', 'Range',sprintf('A%d',startRow));

        startRow = startRow + height(table2)+ 1;
         
        
    catch   ME

        disp(['Error prosessing file ', matFileName, ':', ME.message]);

    end



end