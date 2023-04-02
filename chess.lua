local board = {}
for i = 1, 8 do
  board[i] = {}
  for j = 1, 8 do
    board[i][j] = " "
  end
end

board[1][1] = "r"
board[1][2] = "n"
board[1][3] = "b"
board[1][4] = "q"
board[1][5] = "k"
board[1][6] = "b"
board[1][7] = "n"
board[1][8] = "r"

for i = 1, 8 do
  board[2][i] = "p"
  board[7][i] = "P"
end

board[8][1] = "R"
board[8][2] = "N"
board[8][3] = "B"
board[8][4] = "Q"
board[8][5] = "K"
board[8][6] = "B"
board[8][7] = "N"
board[8][8] = "R"

function printBoard()
  for i = 8, 1, -1 do
    io.write(i .. " ")
    for j = 1, 8 do
      io.write(board[i][j] .. " ")
    end
    io.write("\n")
  end
  io.write("  a b c d e f g h\n")
end

function isLegalMove(piece, from, to)
  if piece == "p" then
    if from[1] == to[1] then 
      if from[2] == "2" and to[2] == "4" and board[3][from[1]] == " " then
        return true
      elseif tonumber(from[2]) + 1 == tonumber(to[2]) and board[tonumber(to[2])][from[1]] == " " then
        return true
      end
    else 
      if tonumber(from[2]) + 1 == tonumber(to[2]) and (tonumber(from[1]) + 1 == tonumber(to[1]) or tonumber(from[1]) - 1 == tonumber(to[1])) and board[tonumber(to[2])][tonumber(to[1])] ~= " " then
        return true
      end
    end
  elseif piece == "P" then
    if from[1] == to[1] then 
      if from[2] == "7" and to[2] == "5" and board[6][from[1]] == " " then
        return true
      elseif tonumber(from[2]) - 1 == tonumber(to[2]) and board[tonumber(to[2])][from[1]] == " " then
        return true
      end
    else 
      if tonumber(from[2]) - 1 == tonumber(to[2]) and (tonumber(from[1]) + 1 == tonumber(to[1]) or tonumber(from[1]) - 1 == tonumber(to[1])) and board[tonumber(to[2])][tonumber(to[1])] ~= " " then
        return true
      end
    end
  elseif piece == "r" or piece == "R" then
    if from[1] == to[1] then 
        local min = math.min(from[2], to[2])
        local max = math.max(from[2], to[2])
        for i = min + 1, max - 1 do
            if board[tonumber(from[2])][i] ~= " " then
                return false
            end
        end
        return true
    elseif from[2] == to[2] then 
        local min = math.min(from[1], to[1])
        local max = math.max(from[1], to[1])
        for i = min + 1, max - 1 do
            if board[i][tonumber(from[1])] ~= " " then
                return false
            end
        end
        return true
    end
    elseif piece == "n" or piece == "N" then
        if (tonumber(from[1]) - tonumber(to[1]))^2 + (tonumber(from[2]) - tonumber(to[2]))^2 == 5 then
            return true
        end
    elseif piece == "b" or piece == "B" then
        if math.abs(tonumber(from[1]) - tonumber(to[1])) == math.abs(tonumber(from[2]) - tonumber(to[2])) then
            local i = tonumber(from[1])
            local j = tonumber(from[2])
            while i ~= tonumber(to[1]) and j ~= tonumber(to[2]) do
                if i < tonumber(to[1]) then
                    i = i + 1
                else
                    i = i - 1
                end
                if j < tonumber(to[2]) then
                    j = j + 1
                else
                    j = j - 1
                end
                if board[i][j] ~= " " then
                    return false
                end
            end
            return true
        end
    elseif piece == "q" or piece == "Q" then
        if from[1] == to[1] or from[2] == to[2] then 
            return isLegalMove(piece:lower(), from, to)
        elseif math.abs(tonumber(from[1]) - tonumber(to[1])) == math.abs(tonumber(from[2]) - tonumber(to[2])) then -- diagonal move
            return isLegalMove(piece:lower(), from, to)
       end
    elseif piece == "k" or piece == "K" then
      if (tonumber(from[1]) - tonumber(to[1]))^2 + (tonumber(from[2]) - tonumber(to[2]))^2 <= 2 then -- one square move
        return true
     end
    end
     return false
end

local function isValidPosition(pos)
    local col = pos:sub(1,1)
    local row = tonumber(pos:sub(2,2))
    return col and row and col:find("[a-h]") and row >= 1 and row <= 8
end

function movePiece(from, to)
    local piece = board[tonumber(from[2])][from[1]]
    if isLegalMove(piece, from, to) then
      board[tonumber(to[2])][to[1]] = piece
      board[tonumber(from[2])][from[1]] = " "
      return true
    else
      return false
    end
end
  

local currentPlayer = 'white'
while true do
    printBoard()
    print(currentPlayer .. "'s move")
    local from = ""
    while from == "" do
        io.write("Enter the piece's current position (e.g. 'e2'): ")
        local input = io.read()
        if board[tonumber(input:sub(2,2))][tonumber(input:sub(1,1))] ~= " " and board[tonumber(input:sub(2,2))][tonumber(input:sub(1,1))]:lower() == currentPlayer:sub(1,1) then
            from = input
        end
    end
    local to = ""
    while to == "" do
        io.write("Enter the piece's destination (e.g. 'e4'): ")
        local input = io.read()
        if isLegalMove(board[tonumber(from:sub(2,2))][tonumber(from:sub(1,1))], from, input) then
            to = input
        else
            print("Invalid move. Try again.")
        end
    end
    local piece = board[tonumber(from:sub(2,2))][tonumber(from:sub(1,1))]
    movePiece(board, from, to)
    if currentPlayer == "white" then
        currentPlayer = "black"
    else
        currentPlayer = "white"
    end
end

playChess()
