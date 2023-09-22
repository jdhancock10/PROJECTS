%% ROULETTE SIMULATION
% JAMES HANCOCK
% AUGUST 2023

clear
clc

%rng(4) %lands on 32

% STARTING VARIABLES
numbers = ["0" "28" "9" "26" "30" "11" "7" "20" "32" "17" "5" "22" "34" ...
           "15" "3" "24" "36" "13" "1" "00" "27" "10" "25" "29" "12" "8"...
           "19" "31" "18" "6" "21" "33" "16" "4" "23" "35" "14" "2"]; % AMERICAN ROULETTE
blanks =  [" " "  " " " "  " "  " "  " " " "  " "  " "  " " " "  " "  " ...
           "  " " " "  " "  " "  " " " "  " "  " "  " "  " "  " "  " " "...
           "  " "  " "  " " " "  " "  " "  " " " "  " "  " "  " " "];

splitBet = [];
startingFunds = 100;
funds = startingFunds; 
cashOut = false;

% EACH ITTERATION OF THE LOOP IS ONE GAME OF ROULETTE
while funds > 0 & cashOut == false
    clc
    fprintf("==============================================================\n")
    fprintf("-------------------------- ROULETTE --------------------------\n")
    fprintf("==============================================================\n")
    fprintf("Place a bet on a single number or an entire row of" + ...
        " numbers.\nYou can also bet on colours and odd or even " + ...
        "numbers. A bet on \na single number, including 0 and 00 " + ...
        "pays 35:1. Bets on red or \nblack, odd or even pay 1:1.\n\n")
    fprintf("Funds: $%.2f\n\n", funds);
    bet = input("Bet: $");
    choice = input("Bet on: ","s");

    if choice == "split"
        numSplit = input("How many bets do you want to make? ");
            for i = 1:numSplit
                splitBet(i) = input("Bet on: ");
            end
    end

    if bet > funds || bet <= 0
        error("ILLEGAL BET! YOU HAVE BEEN KICKED OUT.")
    end
    funds = funds - bet;

    % SIMULATES THE WHEEL SPINNING
    numSpins = randi([10,48]);
    mid = 1;
    for i = 1:numSpins
        clc
        fprintf("==============================================================\n")
        fprintf("-------------------------- ROULETTE --------------------------\n")
        fprintf("==============================================================\n")
        fprintf("Funds: $%.2f\n\n", funds);
        fprintf("Bet: $%.2f\n", bet);
        fprintf("Bet on: %s\n", choice);
        ind = [(mid-3):(mid+3)];
        indA = find(ind>length(numbers));
        indB = find(ind<1);
        ind(indA) = ind(indA)-length(numbers);
        ind(indB) = ind(indB)+length(numbers);
    
        currNumbers = numbers(ind);
        currBlanks = blanks(ind);
        currBlanks(4) = "O";
        fprintf("\t\t\t\t%s   %s   %s   %s   %s   %s   %s\n",currBlanks)
        fprintf("\t\t\t\t%s   %s   %s   %s   %s   %s   %s\n",currNumbers)
        
        mid = mid +1;
        pause(0.15)
    end
    finalNum = currNumbers(4);

    % PRINT WINNINGS TO USER AND ADDS TO TOTAL FUNDS
    if choice == "split"
        winnings = findSplitWinnings(bet, splitBet, finalNum);
    else
        winnings = findWinnings(bet, choice, finalNum);
    end
    if winnings > 0
        fprintf("You win $%.2f.", winnings)
    else
        fprintf("You lost.")
        if funds <= 0 
            pause(2);
            break;
        end
    end
    funds = funds + winnings;
    cashOut = input("\nCash out? ",'s');
    cashOut = checkCashOut(cashOut);
end

% AFTER CASHOUT OR FUNDS RUN OUT
clc
fprintf("==============================================================\n")
fprintf("-------------------------- ROULETTE --------------------------\n")
fprintf("==============================================================\n")
if funds==0
    fprintf("...everything. That means you're due to win next time.\n")
elseif funds>startingFunds
    fprintf("You made $%.2f! But you could've won more.\n", funds-startingFunds)
elseif funds<startingFunds
    fprintf("You only lost $%.2f! One win could turn everything around.\n", ...
        startingFunds-funds)
end


%% FUNCTIONS TO DETERMINE THE PLAYER'S WINNINGS (IF ANY)
function [winnings] = findWinnings(bet, choice, finalNum)
winnings = 0;
finalNumDouble = double(finalNum);

% SETS OF NUMBERS BETS CAN BE PLACED ON
red = ["9" "30" "7" "32" "5" "34" "3" "36" "1" "27" "25" "12" "19" "18"....
    "21" "16" "23" "14"];
black = ["28" "26" "11" "20" "17" "22" "15" "24" "13" "10" "29" "8" "31"....
    "6" "33" "4" "35" "2"];
col1 = ["1" "4" "7" "10" "13" "16" "19" "22" "25" "28" "31" "34"];
col2 = ["2" "5" "8" "11" "14" "17" "20" "23" "26" "29" "32" "35"];
col3 = ["3" "6" "9" "12" "15" "18" "21" "24" "27" "30" "33" "36"];

% RED OR BLACK
switch choice
    case {"red", "RED","Red"}
        if (find(finalNum == red))>0
            winnings = bet*2;
        end
    case {"black", "BLACK", "Black"}
        if (find(finalNum == black))>0
            winnings = bet*2;
        end
    case {"green", "GREEN","Green"}
        if finalNumDouble==0
            winnings = bet*2;
        end
        

% ODD OR EVEN
    case {"odd", "ODD","Odd"}
        if rem(finalNumDouble,2)~=0 && finalNumDouble ~= 0
            winnings = bet*2;
        end
    case {"even", "EVEN","Even"}
        if rem(finalNumDouble,2)==0 && finalNumDouble ~= 0
            winnings = bet*2;
        end

% HIGH OR LOW
    case {"high", "HIGH","High"}
        if finalNumDouble >= 19
            winnings = bet*2;
        end
    case {"low", "LOW","Low"}
        if finalNumDouble <= 18 && finalNumDouble > 0
            winnings = bet*2;
        end
% THIRDS 
    case {"third1", "THIRD1","Third1"}
        if finalNumDouble >= 0 && finalNumDouble <= 12
            winnings = bet*3;
        end
    case {"third2", "THIRD2","Third2"}
        if finalNumDouble >= 13 && finalNumDouble <= 21
            winnings = bet*3;
        end
    case {"third3", "THIRD3","Third3"}
        if finalNumDouble >= 22 && finalNumDouble <= 36
            winnings = bet*2;
        end

% COLUMNS
    case {"col1", "COL1", "Col1"}
        if (find(finalNum == col1))>0
            winnings = bet*3;
        end
    case {"col2", "COL2", "Col2"}
        if (find(finalNum == col2))>0
            winnings = bet*3;
        end
    case {"col3", "COL3", "Col3"}
        if (find(finalNum == col3))>0
            winnings = bet*3;
        end
end

% SINGLE NUMBER
if finalNum == choice
    winnings = bet*36;
end

end

% SPLITS (MULTIPLE NUMBERS)
function [winnings] = findSplitWinnings(bet, splitBets, finalNum)
winnings = 0;
    for i = 1:length(splitBets)
        if double(finalNum) == splitBets(i)
            winnings = floor(36/length(splitBets))*bet;
        end
    end
end

%% CHECKS IF PLAYER WANTS TO CASH OUT (STOP PLAYING)
function [cashOut] = checkCashOut(cashOut)
    switch cashOut
        case {"yes", "Yes", "y", "YES", "Y"}
            cashOut = true;
        otherwise
            cashOut = false;
    end
end



