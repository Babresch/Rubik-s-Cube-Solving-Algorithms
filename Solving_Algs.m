function cubesolving();
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
maxMoves = 100000;

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
solveMoves
cornerP



end



