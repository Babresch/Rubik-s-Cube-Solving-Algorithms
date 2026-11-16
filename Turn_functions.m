%clc
%clear


% corner position
%corner is 1/8
cornerP = [01 02 03 04 05 06 07 08];


% Apply a sample move sequence to the corner permutation
%{
cornerP = R_po(cornerP)
cornerP = RP_po(cornerP)

cornerP = L_po(cornerP)
cornerP = LP_po(cornerP)

cornerP = U_po(cornerP)
cornerP = UP_po(cornerP)
%}


% edge orientation:
    %Red, blue, orange, green

    %true = oriented
    %false = not

edgeO = [0 0 0 0];


% edge position
    %edge is 1/12

edgeP = [];

% corner orientation:
    %starts at 0 with a correct orientation and moves up by one for each
    %clockwise orientation (0, 1, 2, 0...)

cornerO = [0 0 0 0 0 0 0 0];


% R move
%{
function [cornerP] = R_po(cornerP)
    persistent A

    if isempty(A)
        A = cornerP([7,2,3,6]);
    end

    cornerP([2, 3, 6, 7]) = A;
    A = cornerP([7,2,3,6]);

end
%}


%cornerP = D2_po(cornerP)
%cornerP = DP_po(cornerP)


moves = {@R_po, @RP_po, @L_po, @LP_po, @U_po, @UP_po, @F_po, @FP_po, @D_po, @DP_po, @B_po, @BP_po, @B2_po, @R2_po, @L2_po, @F2_po, @D2_po, @U2_po,};


% CUBE SOLVING






function tenStep();

%scramble
scramble = input('input scramble here: ', 's');
%scramble = split(string(scramble));
scramble = regexp(strtrim(scramble), '\s+', 'split');
scramble = replace(scramble, "'", "P");

% Apply the entered scramble as a sequence of move indexes
functions = cell(1,length(scramble));

for i = 1:length(scramble)
    functions{i} = str2func(char(scramble{i} + "_po"));
end

%disp(scramble);
%disp(functions)

for i = 1:length(functions)
    cornerP = functions{i}(cornerP);
end

functions;
cornerP

moveSet = [];
maxMoves = 1000;
A = [01 02 03 04 05 06 07 08];

solveMoves = {};
prevMove = {};
j = 1;
b = 1;
c = 1;

while ~isequal(cornerP, A) && j <= maxMoves

    bestMove = [];
    bestScore = inf;
    bestMoveHandle = [];


    tenStep = cell(1, 10);

   
    for i = 1:10
        temp = cornerP;
        tenStep{i} = moves{randi(length(moves))};
        temp = tenStep(temp);
        moveSet{i} = temp;
    end
    tenStep


    if isa(prevMove, 'function_handle')
        PrevMoveName = func2str(prevMove);

        if contains(PrevMoveName, "P")
            inverseMove = erase(PrevMoveName, "P");
        else
            inverseMove = insertAfter(PrevMoveName,1,"P");
        end

        if contains(PrevMoveName, "2")
            doubleMove = erase(PrevMoveName, "2");
        else
            doubleMove = insertAfter(PrevMoveName,1,"2");
        end

    else
        doubleMove = 0;
        inverseMove = 0;
    end
    CurrentMoveName = func2str(moves{i});



    if ~isequal(moves{i}, prevMove) && ~isequal(CurrentMoveName, inverseMove) && ~isequal(CurrentMoveName, doubleMove)
        temp = cornerP;

        for i = 1:length(tenStep)
            candidateState = tenStep{i}(temp);
        end

        if sum(candidateState ~= A) < bestScore
            bestScore = sum(candidateState ~= A);

            
            for i = 1:(length(moveSet))
                bestMove{i} = func2str(tenStep{i})
                bestMoveHandle{i} = moveSet{i};
            end

           
        
        end
    else
        i;
    end

    prevMove = bestMoveHandle;
    for j = 1:length(moveSet)
        solveMoves{j} = bestMove;
        solveMoves{j} = replace(solveMoves{j}, "_po", "");
        solveMoves{j} = replace(solveMoves{j}, "P", "'");
    end

end
    
solveMoves


end


%function cubesolving();
%scramble
scramble = input('input scramble here: ', 's');
%scramble = split(string(scramble));
scramble = regexp(strtrim(scramble), '\s+', 'split');
scramble = replace(scramble, "'", "P");

% Apply the entered scramble as a sequence of move indexes
functions = cell(1,length(scramble));

for i = 1:length(scramble)
    functions{i} = str2func(char(scramble{i} + "_po"));
end

%disp(scramble);
%disp(functions)

for i = 1:length(functions)
    cornerP = functions{i}(cornerP);
end

functions;
cornerP



bestMove = [];
bestScore = inf;
bestCornerP = [];
solveMoves = {};
j = 1;
maxMoves = 1000;

prevMove = [];

A = [01 02 03 04 05 06 07 08];

while ~isequal(cornerP, A) && j <= maxMoves

    bestMove = [];
    bestScore = inf;
    bestCornerP = [];
    bestMoveHandle = [];
 

    for i = 1:length(moves)
        testCornerP = moves{i}(cornerP);

        %currentMove = A - testCornerP;

            if isa(prevMove, 'function_handle')
                PrevMoveName = func2str(prevMove);
                
                if contains(PrevMoveName, "P")
                    inverseMove = erase(PrevMoveName, "P");
                else
                    inverseMove = insertAfter(PrevMoveName,1,"P");
                end

                if contains(PrevMoveName, "2")
                    doubleMove = erase(PrevMoveName, "2");
                else
                    doubleMove = insertAfter(PrevMoveName,1,"2");
                end

            else
                doubleMove = 0;
                inverseMove = 0;
            end
            CurrentMoveName = func2str(moves{i});



    
        if sum(testCornerP ~= A) < bestScore && ~isequal(moves{i}, prevMove) && ~isequal(CurrentMoveName, inverseMove) && ~isequal(CurrentMoveName, doubleMove)
            bestScore = sum(testCornerP ~= A);
            %bestScore = sum(abs(currentMove), 'all');
            bestMove = func2str(moves{i});
            bestCornerP = testCornerP;
            bestMoveHandle = moves{i};
        else
            i;
        end
    end

    prevMove = bestMoveHandle;
    cornerP = bestCornerP;
    solveMoves{j} = bestMove;
    solveMoves{j} = replace(solveMoves{j}, "_po", "");
    solveMoves{j} = replace(solveMoves{j}, "P", "'");
    j = j + 1;
end

solveMoves = strjoin(solveMoves);
solveMoves = solveMoves + ""
cornerP

%end


function visitedMethod()

%scramble
scramble = input('input scramble here: ', 's');
scramble = regexp(strtrim(scramble), '\s+', 'split');
scramble = replace(scramble, "'", "P");

% Apply the entered scramble as a sequence of move indexes
functions = cell(1,length(scramble));

for i = 1:length(scramble)
    functions{i} = str2func(char(scramble{i} + "_po"));
end

%disp(scramble);
%disp(functions)
new = cornerP;

for i = 1:length(functions)
    cornerP = functions{i}(new);
    new = cornerP;
end

functions;
cornerP

queue = {cornerP};
visited = containers.Map;
visited(mat2str(cornerP)) = true;

while ~isempty(queue)

    current = queue{1};
    queue(1) = [];

    for i = 1:length(moves)

        next = moves{i}(current);
        key = mat2str(next);

        if ~isKey(visited, key)

            visited(key) = true;
            queue{end+1} = next

        end
    end
end

queue

end


% turn_algs

% R' move
function [cornerP] = RP_po(cornerP)

cornerP([2, 3, 6, 7]) = cornerP([7,2,3,6]);

end

% R move
function [cornerP] = R_po(cornerP)

cornerP([2, 3, 6, 7]) = cornerP([3,6,7,2]);

end

% R2 move
function [cornerP] = R2_po(cornerP)

cornerP([2, 3, 6, 7]) = cornerP([7,2,3,6]);
cornerP([2, 3, 6, 7]) = cornerP([7,2,3,6]);

end
%---------

% L move
function [cornerP] = L_po(cornerP)

cornerP([1,4,5,8]) = cornerP([8,1,4,5]);

end

% L' move
function [cornerP] = LP_po(cornerP)

cornerP([1,4,5,8]) = cornerP([4,5,8,1]);

end

% L2 move
function [cornerP] = L2_po(cornerP)

cornerP([1,4,5,8]) = cornerP([4,5,8,1]);
cornerP([1,4,5,8]) = cornerP([4,5,8,1]);

end
%-------

% U move
function [cornerP] = U_po(cornerP)

cornerP([1, 2, 3, 4]) = cornerP([4,1,2,3]);


end

% U' move
function [cornerP] = UP_po(cornerP)

cornerP([1, 2, 3, 4]) = cornerP([2,3,4,1]);

end

% U2 move
function [cornerP] = U2_po(cornerP)

cornerP([1, 2, 3, 4]) = cornerP([4,1,2,3]);
cornerP([1, 2, 3, 4]) = cornerP([4,1,2,3]);


end
%--------



% F move
function [cornerP] = F_po(cornerP)

cornerP([3,4,5,6]) = cornerP([4,5,6,3]);


end

% F' move
function [cornerP] = FP_po(cornerP)

cornerP([3,4,5,6]) = cornerP([6,3,4,5]);

end

% F2 move
function [cornerP] = F2_po(cornerP)

cornerP([3,4,5,6]) = cornerP([4,5,6,3]);
cornerP([3,4,5,6]) = cornerP([4,5,6,3]);

end
%------------


% D' move
function [cornerP] = DP_po(cornerP)

cornerP([5,6,7,8]) = cornerP([6,7,8,5]);


end

% D move
function [cornerP] = D_po(cornerP)

cornerP([5,6,7,8]) = cornerP([8,5,6,7]);

end

% D2 move
function [cornerP] = D2_po(cornerP)

cornerP([5,6,7,8]) = cornerP([6,7,8,5]);
cornerP([5,6,7,8]) = cornerP([6,7,8,5]);

end
%------------


% B' move
function [cornerP] = BP_po(cornerP)

cornerP([1,2,7,8]) = cornerP([8,1,2,7]);


end

% B move
function [cornerP] = B_po(cornerP)

cornerP([1,2,7,8]) = cornerP([2,7,8,1]);

end

% B2 move
function [cornerP] = B2_po(cornerP)

cornerP([1,2,7,8]) = cornerP([8,1,2,7]);
cornerP([1,2,7,8]) = cornerP([8,1,2,7]);

end
