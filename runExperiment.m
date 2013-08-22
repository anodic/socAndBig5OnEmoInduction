%% settings
dataLocation = 'LDOS-CoMoDa-forEMPIRE.xls';

minRatingsPerUser = 25;
minRatingsPerClass = 5;

data = xlsread(dataLocation);

%% count adequate users
% get unique user ids
userIds = unique(data(:,1));
% count the amount of entries per user
[amounts, users] = hist(data(:,1),userIds);
% plot ratings per user
%stem (users,amounts);
%count users with number of ratings higher than threshold
adequateUsrs = (find (amounts>minRatingsPerUser));
adequateUsersIds = users(adequateUsrs);
amountOfAdequateUsers = length(find (amounts>minRatingsPerUser));
disp(['There are ' num2str(amountOfAdequateUsers) ' users with more than ' num2str(minRatingsPerUser) ' ratings.']);

% initialize matrix with rows: userID|#rC1|#rC2
userC1C2Matrix = zeros(amountOfAdequateUsers,3);

% count amount of ratings when alone and amount of ratings when with
% company for each user
for i = 1: length(adequateUsersIds) % only those over threshold
    % find entries of user 
    entriesByUserI = find(data(:,1)==adequateUsersIds(i)); 
    % count amount of ratings by user i in context 1
    userC1C2Matrix(i,2) = length(find(data(entriesByUserI,13)==1));
    % count amount of ratings by user i in context 2
    userC1C2Matrix(i,3) = length(find(data(entriesByUserI,13)~=1));
        
    % display result
    %disp(['User ' num2str(adequateUsersIds(i)) ' -> C1: ' num2str(amountOfRatingsInC1) '   C2: ' num2str(amountOfRatingsInC2)]);
   
    % save results in matrix
    userC1C2Matrix(i,1) = adequateUsersIds(i);
       
end

%count users with number of ratings higher than threshold, and number of
%ratings per class higher than class threshold
adequateIds = find (userC1C2Matrix(:,2)< minRatingsPerClass);
adequateIds= [adequateIds; find(userC1C2Matrix(:,3)< minRatingsPerClass)];
amountOfAdequateUsersForClass = amountOfAdequateUsers - length(unique(adequateIds));

disp(['There are ' num2str(amountOfAdequateUsersForClass) ' users with more than ' num2str(minRatingsPerUser) ' ratings and at least ' num2str(minRatingsPerClass) ' ratings per class.']);

% select only the users that meet both conditions
badIndex = find( userC1C2Matrix(:,2)<minRatingsPerClass);
badIndex = [badIndex; find( userC1C2Matrix(:,3)<minRatingsPerClass)];
userC1C2Matrix(badIndex,:)=[];
   
%% intensity of experience

intensityC1 = zeros (size(userC1C2Matrix,1),1);
intensityC2 = zeros (size(userC1C2Matrix,1),1);
averageRatingDataset = mean (data(:,3));

% calculate intensity for each adequate user when alone and when with company
for i = 1: size(userC1C2Matrix,1)
    currUserId = userC1C2Matrix(i,1);
    currRatingsInd = find(data(:,1)==currUserId & data(:,13)==1);
    currRatings = data(currRatingsInd,3);
    currRatings = currRatings - averageRatingDataset;
    currRatings = mean(currRatings);
    intensityC1(i) = abs(currRatings);
end

for i = 1: size(userC1C2Matrix,1)
    currUserId = userC1C2Matrix(i,1);
    currRatingsInd = find(data(:,1)==currUserId & data(:,13)~=1);
    currRatings = data(currRatingsInd,3);
    currRatings = currRatings - averageRatingDataset;
    currRatings = mean(currRatings);
    intensityC2(i) = abs(currRatings);
end

[pi,hi] = ranksum(intensityC1,intensityC2)

%% dispersion of ratings

dispersionC1 = zeros (size(userC1C2Matrix,1),1);
dispersionC2 = zeros (size(userC1C2Matrix,1),1);
averageRatingDataset = mean (data(:,3));

% calculate intensity for each adequate user when alone and when with company
for i = 1: size(userC1C2Matrix,1)
    currUserId = userC1C2Matrix(i,1);
    currRatingsInd = find(data(:,1)==currUserId & data(:,13)==1);
    currRatings = data(currRatingsInd,3);
    dispersionC1(i) = var(currRatings);
end

for i = 1: size(userC1C2Matrix,1)
    currUserId = userC1C2Matrix(i,1);
    currRatingsInd = find(data(:,1)==currUserId & data(:,13)~=1);
    currRatings = data(currRatingsInd,3);
    dispersionC2(i) = var(currRatings);
end

[pd,hd] = ranksum(dispersionC1,dispersionC2)
