%% settings
dataLocation = 'LDOS-CoMoDa-forEMPIRE.xls';
personalityProfileLocation = 'big5_working.xlsx';

minRatingsPerUser = 25;
minRatingsPerClass = 10;
persThreshold = 50;

data = xlsread(dataLocation);
personality = xlsread(personalityProfileLocation);
%% counting occurences
% contingency table dVert = neutral/notneutral; dHor = alone/notAlone

% column 14 = endEmo; column 13 = social;

persParams = [1,2,3,4,5];

for k = 1:length(persParams)
    
    personalityParam = persParams(k);
    emotionAndSocialTable = zeros(2,2);
    
    disp(' ')
    disp('***********NEW PERSONALITY PARAMETER************')
    disp('-----------parameter<50-------------')
    % personality param < 50
    for i = 1: size(data,1)
        % data(i,[1,2,3,13,14])
        if (data(i,13)==1 && data(i,14)==7 && any(personality(:,1) == data(i,1)) &&  personality(find(personality(:,1)==data(i,1)),1+personalityParam)<persThreshold )
            emotionAndSocialTable(1,1) = emotionAndSocialTable(1,1)+1;
            
        elseif (data(i,13)==1 && data(i,14)~=7 && any(personality(:,1) == data(i,1)) &&  personality(find(personality(:,1)==data(i,1)),1+personalityParam)<persThreshold )
            emotionAndSocialTable(2,1) = emotionAndSocialTable(2,1)+1;
            
        elseif (data(i,13)~=1 && data(i,14)==7 && any(personality(:,1) == data(i,1)) &&  personality(find(personality(:,1)==data(i,1)),1+personalityParam)<persThreshold )
            emotionAndSocialTable(1,2) = emotionAndSocialTable(1,2)+1;
            
        elseif (data(i,13)~=1 && data(i,14)~=7 && any(personality(:,1) == data(i,1)) &&  personality(find(personality(:,1)==data(i,1)),1+personalityParam)<persThreshold )
            emotionAndSocialTable(2,2) = emotionAndSocialTable(2,2)+1;
        else
            continue;
        end
    end
    
    disp(['emotion/social table for  persParam ' num2str(personalityParam) ';<50:'])
    disp(emotionAndSocialTable);
    
    %calculating proportions
    notNeutralProportionAverage = sum(emotionAndSocialTable(2,:))/(sum(sum(emotionAndSocialTable)));
    notNeutralProportionAlone = emotionAndSocialTable(2,1)/sum(emotionAndSocialTable(:,1));
    notNeutralProportionNotAlone = emotionAndSocialTable(2,2)/sum(emotionAndSocialTable(:,2));
    
    % generating variables for t test 0 = neutral; 1 = emotion 
    % alone
    alone = zeros(sum(emotionAndSocialTable(:,1)),1);
    alone(1:emotionAndSocialTable(2,1))=1;
    % not alone
    notAlone = zeros(sum(emotionAndSocialTable(:,2)),1);
    notAlone(1:emotionAndSocialTable(2,2))=1;
    % average
    average = zeros(sum(sum(emotionAndSocialTable)),1);
    average(1:sum(emotionAndSocialTable(2,:)))=1;
    
    % t test alone vs average
    [h1,p1] = ttest2(alone, average);
    % t test notAlone vs average
    [h2,p2] = ttest2(notAlone, average);
    % t test alone vs notAlone
    [h3,p3] = ttest2(alone, notAlone);
           
    disp(['For persParam '  num2str(personalityParam) '; <50: emotion average = ' num2str(notNeutralProportionAverage), '%; emotion when alone =  ' num2str(notNeutralProportionAlone) '%; emotion when with company = ' num2str(notNeutralProportionNotAlone) '%.']);
    disp(['alone vs average: pVal = ' num2str(p1) '; h = ' num2str(h1) '. Sample sizes: ' num2str(length(alone)) ', ' num2str(length(average))]);
    disp(['notAlone vs average: pVal = ' num2str(p2) '; h = ' num2str(h2) '. Sample sizes: ' num2str(length(notAlone)) ', ' num2str(length(average))]);
    disp(['alone vs notAlone: pVal = ' num2str(p3) '; h = ' num2str(h3) '. Sample sizes: ' num2str(length(alone)) ', ' num2str(length(notAlone))]);
    
    %%%%
    
    
    disp('-----------parameter>=50-------------')
    emotionAndSocialTable = zeros(2,2);
    
    
    % personality param >= 50
    for i = 1: size(data,1)
        % data(i,[1,2,3,13,14])
        if (data(i,13)==1 && data(i,14)==7 && any(personality(:,1) == data(i,1)) &&  personality(find(personality(:,1)==data(i,1)),1+personalityParam)>=persThreshold )
            emotionAndSocialTable(1,1) = emotionAndSocialTable(1,1)+1;
            
        elseif (data(i,13)==1 && data(i,14)~=7 && any(personality(:,1) == data(i,1)) &&  personality(find(personality(:,1)==data(i,1)),1+personalityParam)>=persThreshold )
            emotionAndSocialTable(2,1) = emotionAndSocialTable(2,1)+1;
            
        elseif (data(i,13)~=1 && data(i,14)==7 && any(personality(:,1) == data(i,1)) &&  personality(find(personality(:,1)==data(i,1)),1+personalityParam)>=persThreshold )
            emotionAndSocialTable(1,2) = emotionAndSocialTable(1,2)+1;
            
        elseif (data(i,13)~=1 && data(i,14)~=7 && any(personality(:,1) == data(i,1)) &&  personality(find(personality(:,1)==data(i,1)),1+personalityParam)>=persThreshold )
            emotionAndSocialTable(2,2) = emotionAndSocialTable(2,2)+1;
        else
            continue;
        end
    end
    
    disp(['emotion/social table for  persParam ' num2str(personalityParam) ';>=50:'])
    disp(emotionAndSocialTable);
    
    notNeutralProportionAverage = sum(emotionAndSocialTable(2,:))/(sum(sum(emotionAndSocialTable)));
    notNeutralProportionAlone = emotionAndSocialTable(2,1)/sum(emotionAndSocialTable(:,1));
    notNeutralProportionNotAlone = emotionAndSocialTable(2,2)/sum(emotionAndSocialTable(:,2));
    
    % generating variables for t test 0 = neutral; 1 = emotion 
    % alone
    alone = zeros(sum(emotionAndSocialTable(:,1)),1);
    alone(1:emotionAndSocialTable(2,1))=1;
    % not alone
    notAlone = zeros(sum(emotionAndSocialTable(:,2)),1);
    notAlone(1:emotionAndSocialTable(2,2))=1;
    % average
    average = zeros(sum(sum(emotionAndSocialTable)),1);
    average(1:sum(emotionAndSocialTable(2,:)))=1;
    
    % t test alone vs average
    [h1,p1] = ttest2(alone, average);
    % t test notAlone vs average
    [h2,p2] = ttest2(notAlone, average);
    % t test alone vs notAlone
    [h3,p3] = ttest2(alone, notAlone);
    
    disp(['For persParam ' num2str(personalityParam) '; >= 50: emotion average = ' num2str(notNeutralProportionAverage), '%; emotion when alone =  ' num2str(notNeutralProportionAlone) '%; emotion when with company = ' num2str(notNeutralProportionNotAlone) '%.']);
    disp(['alone vs average: pVal = ' num2str(p1) '; h = ' num2str(h1) '. Sample sizes: ' num2str(length(alone)) ', ' num2str(length(average))]);
    disp(['notAlone vs average: pVal = ' num2str(p2) '; h = ' num2str(h2) '. Sample sizes: ' num2str(length(notAlone)) ', ' num2str(length(average))]);
    disp(['alone vs notAlone: pVal = ' num2str(p3) '; h = ' num2str(h3) '. Sample sizes: ' num2str(length(alone)) ', ' num2str(length(notAlone))]);
end