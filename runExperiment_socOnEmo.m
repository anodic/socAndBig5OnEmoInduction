%% settings
dataLocation = 'LDOS-CoMoDa-forEMPIRE.xls';

minRatingsPerUser = 25;
minRatingsPerClass = 5;

data = xlsread(dataLocation);

%% counting occurences
% contingency table dVert = home/notHome; dHor = alone/notAlone

neutralTable = zeros(2,2);
notNeutralTable = zeros(2,2);

% neutral
for i = 1: size(data,1)
    
   % home+alone
   if (data(i,11)==1 && data(i,13)==1 && data(i,14)==7)
       neutralTable(1,1) = neutralTable(1,1)+1;    
   % home+company
   elseif (data(i,11)==1 && data(i,13)~=1 && data(i,14)==7)
       neutralTable(1,2) = neutralTable(1,2)+1;    
   % notHome+alone
   elseif (data(i,11)~=1 && data(i,13)==1 && data(i,14)==7)
       neutralTable(2,1) = neutralTable(2,1)+1;    
   % notHome+notAlone
   elseif (data(i,11)~=1 && data(i,13)~=1 && data(i,14)==7)
       neutralTable(2,2) = neutralTable(2,2)+1;    
   else
       continue;
   end
end

disp(neutralTable);

% notNeutral
for i = 1: size(data,1)
    
   % home+alone
   if (data(i,11)==1 && data(i,13)==1 && data(i,14)~=7)
       notNeutralTable(1,1) = notNeutralTable(1,1)+1;    
   % home+notAlone
   elseif (data(i,11)==1 && data(i,13)~=1 && data(i,14)~=7)
       notNeutralTable(1,2) = notNeutralTable(1,2)+1;    
   % notHome+alone
   elseif (data(i,11)~=1 && data(i,13)==1 && data(i,14)~=7)
       notNeutralTable(2,1) = notNeutralTable(2,1)+1;    
   % notHome+notAlone
   elseif (data(i,11)~=1 && data(i,13)~=1 && data(i,14)~=7)
       notNeutralTable(2,2) = notNeutralTable(2,2)+1;    
   else
       continue;
   end         
end

disp(notNeutralTable);

% proportion of not neutral

proportionNotNeutralTable = zeros(2,2);

proportionNotNeutralTable=notNeutralTable./(notNeutralTable+neutralTable);

disp(proportionNotNeutralTable);

