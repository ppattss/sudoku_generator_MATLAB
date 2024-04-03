%%%{
%#####      Project:    Sudoku Solution Generator   #####
%#####      Author:     Peter Patterson             #####
%#####      Date:       17/08/2018                  #####
%#####      Version:    Matlab 2018a                #####
%%%}
%% ###   Initial Setup   ###
% start timer
tic; 
% clear workspace variables and output
clc
clear
clear all
% set limit and trigger values
iterationLimit = 1.25e6;
setGlobalLimit(iterationLimit);
backTrackTrigger = 1;
setBacktrackTrigger(backTrackTrigger);
backtrackLoopLimit= 10;
setGlobalCount(0);

%% ###   Stage 1 - Generate Blank Solution and Box 1   ###
% instanciate blank solution array and generate first box
savedSolution = blankSolution();
boxA =  randperm(9);
savedSolution = updateSolution(savedSolution, boxA, 1, 1);
setGlobalSol(savedSolution);

%% ###   Stage 2 - Generate Boxes 2,3,4,5,7  ###
% Box 2 (2,1)
thisX = 2;
thisY = 1;
generateBox(thisX,thisY);
% Box 3 (3,1)
thisX = 3;
thisY = 1;
generateBox(thisX,thisY);
% Box 4 (1,2)
thisX = 1;
thisY = 2;
generateBox(thisX,thisY);
% Box 5 (2,2)
thisX = 2;
thisY = 2;
generateBox(thisX,thisY);
% Box 7 (1,3)
thisX = 1;
thisY = 3;
generateBox(thisX,thisY);

%% ###    Stage 3 - Generate Boxes 6,8,9 and Backtrack if required   ###
prebacktrackSolution = getGlobalSol;
triggerVal=getBacktrackTrigger;
backCount=0;

while (triggerVal>0)
    % Box 6 (3,2)
    thisX = 3;
    thisY = 2;
    generateBox(thisX,thisY);
    % Box 8 (2,3)
    thisX = 2;
    thisY = 3;
    generateBox(thisX,thisY);
    % Box 9 (3,3)
    thisX = 3;
    thisY = 3;
    generateBox(thisX,thisY);
    
    savedSolution = getGlobalSol;
    backCount=backCount+1;
    
    if (savedSolution(9,9)>0 && savedSolution(7,9)>0 && savedSolution(9,7)>0)
        %triggerVal=0;
        setBacktrackTrigger(0);
        triggerOuput = getBacktrackTrigger;
        fprintf('solution found, trigger output set to %d\n', triggerOuput);
        break
    else
        setGlobalSol(prebacktrackSolution);
        fprintf('beginning backtracking (attempt %d)\n',backCount);
    end
    
    if (backCount>backtrackLoopLimit)
        %triggerVal=0;
        setBacktrackTrigger(0);
         triggerOuput = getBacktrackTrigger;
        fprintf('backtrack limit reached, trigger output set to %d\n', triggerOuput);
        break
    end
end


%% ###   Stage 4 - Output data and Save Solution to File   ###
% assign and print out solution
savedSolution = getGlobalSol;
savedSolution
totalIterations = getGlobalCount;
saveSolution(savedSolution);


fprintf('total number of iterations = %d\n',totalIterations);
toc
endTime=toc;% stop timer
%fprintf('total simulation time = %d seconds\n',endTime);
itTime=totalIterations/endTime;
fprintf('iterations per second = %d/sec\n',itTime);


%% ###   Output solution to figure (UITable)   ###
%{
f = figure;
t = uitable(f,'Data', savedSolution,'fontname','courier');
set(t,'ColumnWidth',{50})
set(t,'RowName',{})
set(t,'ColumnName',{})
set(t,'FontSize',50)
table_extent = get(t,'Extent');
set(t,'Position',[10 10 table_extent(3)+5 table_extent(4)+5])
figure_size = get(f,'outerposition');
desired_fig_size = [figure_size(1) figure_size(2) table_extent(3)+50 table_extent(4)+100];
set(f,'outerposition', desired_fig_size);
%}


%% ###   Methods   ###

% ## blankSolution ##
function initialSolution = blankSolution()
% generate 9x9 array of zeros
initialSolution = zeros(9,9);
end

% ## backtrack ##
function thisBack = backtrack()
readSolution = getGlobalSol;
thisBack = zeros(9);
writeSolution = updateSolution(readSolution, thisBack, 3, 2);
setGlobalSol(writeSolution);
writeSolution = updateSolution(readSolution, thisBack, 2, 3);
setGlobalSol(writeSolution);
writeSolution = updateSolution(readSolution, thisBack, 3, 3);
setGlobalSol(writeSolution);
%writeSolution
end

% ## generateBox ##
function thisRand = generateBox(thisX,thisY)
% generate a 1x9 randomly ordered array of numbers 1 to 9
% and compute dupe check for box position @thisX,thisY
fprintf('box(%d,%d) isUnique= ',thisX,thisY);
thisLoop = 0;
readSolution = getGlobalSol;
thisLoopLimit = getGlobalLimit;
thisGlobalCount = getGlobalCount;
while (thisLoop < thisLoopLimit)
    thisRand= randperm(9);
    isUniqueX = checkBoxX(readSolution, thisRand, thisX,thisY);
    isUniqueY = checkBoxY(readSolution, thisRand, thisX,thisY);
    if (isUniqueX == 1 && isUniqueY == 1)
        fprintf('true, took %d attempts, adding box to solution\n',thisLoop);
        writeSolution = updateSolution(readSolution, thisRand, thisX, thisY);
        setGlobalSol(writeSolution);
        break
    else
        %fprintf('isUnique = false for box(%d,%d), regenerating attempt %d\n',thisX,thisY,thisLoop);
        thisLoop = thisLoop + 1;
        thisGlobalCount = getGlobalCount;
        thisGlobalCount = thisGlobalCount + 1;
        setGlobalCount(thisGlobalCount);
    end
    if (thisLoop == thisLoopLimit)
        fprintf('false\naborting loop, ');
        thisGlobalCount = getGlobalCount;
        thisGlobalCount = thisGlobalCount + thisLoopLimit;
        setGlobalCount(thisGlobalCount);
        trigger=1;
        setBacktrackTrigger(trigger);
    end
    
end
end

% ## checkBox X ##
function isUnique = checkBoxX(thisSolution, boxToCheck, thisX, thisY)
% check current box against existing solution
isUnique = false;
for i=1:1:3
    a=i;
    b=i+3;
    c=i+6;
    
    % Y axis box shift
    switch (thisY)
        case 1
            yShift=0;
        case 2
            yShift=3;
        case 3
            yShift=6;
        otherwise
            fprintf('error \n');
    end
    
    p=1+yShift;
    q=2+yShift;
    r=3+yShift;
    
    for j=1:1:9
        %fprintf('checking thisBox(%d) against thisSolution(1,%d) \n',a,j);
        %fprintf('thisBox(%d) = %d, thisSolution(1,%d) = %d\n', a,boxToCheck(a),j,thisSolution(1,j));
        if (boxToCheck(a)~=thisSolution(p,j))
            isUnique = true;
        else
            %fprintf('DUPE FOUND!!!! \n');
            isUnique = false;
            return
        end
        
        %fprintf('checking thisBox(%d) against thisSolution(2,%d) \n',b,j);
        %fprintf('thisBox(%d) = %d, thisSolution(2,%d) = %d\n', b,boxToCheck(b),j,thisSolution(2,j));
        if (boxToCheck(b)~=thisSolution(q,j))
            isUnique = true;
        else
            %fprintf('DUPE FOUND!!!! \n');
            isUnique = false;
            return
        end
        
        %fprintf('checking thisBox(%d) against thisSolution(3,%d) \n',c,j);
        %fprintf('thisBox(%d) = %d, thisSolution(3,%d) = %d\n', c,boxToCheck(c),j,thisSolution(3,j));
        if (boxToCheck(c)~=thisSolution(r,j))
            isUnique = true;
        else
            % fprintf('DUPE FOUND!!!! \n');
            isUnique = false;
            return
        end
    end
end
end

% ## checkBox Y ##
function isUniqueY = checkBoxY(thisSolution, boxToCheck, thisX, thisY)
% check current box against existing solution
isUniqueY = false;
z=0;
for i=1:1:3
    a=z+i;
    b=z+i+1;
    c=z+i+2;
    
    % X axis box shift
    switch (thisX)
        case 1
            xShift=0;
        case 2
            xShift=3;
        case 3
            xShift=6;
        otherwise
            fprintf('error \n');
    end
    
    p=1+xShift;
    q=2+xShift;
    r=3+xShift;
    
    for j=1:1:9
        %fprintf('checking thisBox(%d) against thisSolution(%d,%d) \n',a,j,p);
        %fprintf('thisBox(%d) = %d, thisSolution(1,%d) = %d\n', a,boxToCheck(a),j,thisSolution(1,j));
        if (boxToCheck(a)~=thisSolution(j,p))
            isUniqueY = true;
        else
            %fprintf('DUPE FOUND!!!! \n');
            isUniqueY = false;
            return
        end
        
        % fprintf('checking thisBox(%d) against thisSolution(%d,%d) \n',b,j,q);
        %fprintf('thisBox(%d) = %d, thisSolution(2,%d) = %d\n', b,boxToCheck(b),j,thisSolution(2,j));
        if (boxToCheck(b)~=thisSolution(j,q))
            isUniqueY = true;
        else
            %fprintf('DUPE FOUND!!!! \n');
            isUniqueY = false;
            return
        end
        
        %fprintf('checking thisBox(%d) against thisSolution(%d,%d) \n',c,j,r);
        %fprintf('thisBox(%d) = %d, thisSolution(3,%d) = %d\n', c,boxToCheck(c),j,thisSolution(3,j));
        if (boxToCheck(c)~=thisSolution(j,r))
            isUniqueY = true;
        else
            % fprintf('DUPE FOUND!!!! \n');
            isUniqueY = false;
            return
        end
    end
    z=z+2;
end
end

% ## updateSolution ##
function updatedSolution = updateSolution(thisSolution,thingToSave,thisX,thisY)
% save checked random array into solution array
switch (thisX)
    case 1
        xShift = 0;
    case 2
        xShift = 3;
    case 3
        xShift = 6;
    otherwise
        fprintf('error \n');
end
switch (thisY)
    case 1
        yShift = 0;
    case 2
        yShift = 3;
    case 3
        yShift = 6;
    otherwise
        fprintf('error \n');
end
for i=1:1:3
    x=i+xShift;
    y1=1+yShift;
    y2=2+yShift;
    y3=3+yShift;
    a=i;
    b=i+3;
    c=i+6;
    thisSolution(y1,x) = thingToSave(a);
    thisSolution(y2,x) = thingToSave(b);
    thisSolution(y3,x) = thingToSave(c);
end
updatedSolution = thisSolution;
setGlobalSol(updatedSolution);
%fprintf('end of updateSolution \n');
end

% ## save solution to file ##
function solutionToSave = saveSolution(thisSolution)

separatorArray = NaN(2,9);

solutionName = 'solutions.csv';
formatOut = 'dd-mm-yyyy';
currentDate = datetime('today','TimeZone','local','Format','dd-MM-yyyy');
dateString = datestr(currentDate,formatOut);
writeName = strcat(dateString,'_',solutionName);
fprintf('\nwriting solution to file %s\n', writeName);


if (exist(writeName, 'file') ==2)
    readFile = csvread(writeName);
    csvwrite('solutionsBackup.csv',readFile)
    updatedSolution = [readFile;separatorArray;thisSolution];
    csvwrite(writeName,updatedSolution)
else
    csvwrite(writeName,thisSolution)
end


%{
fileNameAvailable = false;
solutionNumber = 1;
solutionName = 'solution%d.csv';
writeName = sprintf(solutionName,solutionNumber);

while (fileNameAvailable == 0)

if (exist(writeName, 'file') ==2)
    solutionNumber = solutionNumber +1;
    writeName = sprintf(solutionName,solutionNumber);
else
    fileNameAvailable = true;
end

end

if (exist(writeName, 'file') ==0)
 csvwrite(writeName,thisSolution)
end
%}

end


%% ###   Global Variables   ###

function setGlobalSol(val)
global solution
solution = val;
end
function r = getGlobalSol
global solution
r = solution;
end

function setGlobalLimit(val)
global loopLimit
loopLimit = val;
end
function r = getGlobalLimit
global loopLimit
r = loopLimit;
end

function setBacktrackTrigger(val)
global backtrackLimit
backtrackLimit = val;
end
function r = getBacktrackTrigger
global backtrackLimit
r = backtrackLimit;
end

function setGlobalCount(val)
global globalCount
globalCount = val;
end
function r = getGlobalCount
global globalCount
r = globalCount;
end


function setValidBool(val)
global globalValid
globalValid = val;
end
function r = getValidBool
global globalValid
r = globalValid;
end

