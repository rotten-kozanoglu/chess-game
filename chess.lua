local board = {
    {"R", "N", "B", "Q", "K", "B", "N", "R"},
    {"P", "P", "P", "P", "P", "P", "P", "P"},
    {" ", " ", " ", " ", " ", " ", " ", " "},
    {" ", " ", " ", " ", " ", " ", " ", " "},
    {" ", " ", " ", " ", " ", " ", " ", " "},
    {" ", " ", " ", " ", " ", " ", " ", " "},
    {"p", "p", "p", "p", "p", "p", "p", "p"},
    {"r", "n", "b", "q", "k", "b", "n", "r"},
  }
  
  local function printBoard()
    for i = 1, 8 do
      io.write("|")
      for j = 1, 8 do
        io.write(board[i][j] .. "|")
      end
      io.write("\n")
    end
  end
  
local function isValidMove(startRow, startCol, endRow, endCol)
    local piece = board[startRow][startCol]
    local target = board[endRow][endCol]
  
    if target ~= " " and string.sub(target, 1, 1) == string.sub(piece, 1, 1) then
      return false
    end
  
    if piece == "P" then
      local diffRow = endRow - startRow
      local diffCol = math.abs(endCol - startCol)
  
      if diffRow == 1 and diffCol == 0 and target == " " then
        return true 
      elseif diffRow == 2 and diffCol == 0 and startRow == 2 and target == " " and board[startRow + 1][startCol] == " " then
        return true 
      elseif diffRow == 1 and diffCol == 1 and target ~= " " then
        return true 
      else
        return false
      end
    elseif piece == "R" or piece == "r" then
      if startRow == endRow or startCol == endCol then
        if not isObstacleBetween(startRow, startCol, endRow, endCol) then
          return true
        end
      end
    elseif piece == "N" or piece == "n" then
      local diffRow = math.abs(endRow - startRow)
      local diffCol = math.abs(endCol - startCol)
      if (diffRow == 2 and diffCol == 1) or (diffRow == 1 and diffCol == 2) then
        return true
      end
    elseif piece == "B" or piece == "b" then
      local diffRow = math.abs(endRow - startRow)
      local diffCol = math.abs(endCol - startCol)
      if diffRow == diffCol then
        if not isObstacleBetween(startRow, startCol, endRow, endCol) then
          return true
        end
      end
    elseif piece == "Q" or piece == "q" then
      local diffRow = math.abs(endRow - startRow)
      local diffCol = math.abs(endCol - startCol)
      if (startRow == endRow or startCol == endCol) or (diffRow == diffCol) then
        if not isObstacleBetween(startRow, startCol, endRow, endCol) then
          return true
        end
      end
    elseif piece == "K" or piece == "k" then
      local diffRow = math.abs(endRow - startRow)
      local diffCol = math.abs(endCol - startCol)
      if diffRow <= 1 and diffCol <= 1 then
        return true
      end
    end
    return false
end

local function isBlackPiece(piece)
    return string.match(piece, "^[rnbqkp]")
end
  
local function isWhitePiece(piece)
    return string.match(piece, "^[RNBQKP]")
end
  
  
function isObstacleBetween(startRow, startCol, endRow, endCol)
    local rowIncrement = startRow < endRow and 1 or (startRow > endRow and -1 or 0)
    local colIncrement = startCol < endCol and 1 or (startCol > endCol and -1 or 0)

    local row, col = startRow + rowIncrement, startCol + colIncrement
    while row ~= endRow or col ~= endCol do
        if board[row][col] ~= " " then
            return true
        end
        row = row + rowIncrement
        col = col + colIncrement
    end

    return false
end


local function movePiece(startRow, startCol, endRow, endCol)
    if isValidMove(startRow, startCol, endRow, endCol) then
      board[endRow][endCol] = board[startRow][startCol]
      board[startRow][startCol] = " "
      return true
    else
      return false
    end
end

local function isSquareUnderAttack(row, col, isWhiteTurn)
    local opponentChar = isWhiteTurn and "b" or "w" 
  
    local pawnAttackRows = isWhiteTurn and {row - 1} or {row + 1}
    for _, attackRow in ipairs(pawnAttackRows) do
      for _, attackCol in ipairs({col - 1, col + 1}) do
        if attackRow >= 1 and attackRow <= 8 and attackCol >= 1 and attackCol <= 8 and
           board[attackRow][attackCol] == opponentChar .. "p" then
          return true
        end
      end
    end
  
    local knightMoves = {
      {-2, -1}, {-2, 1}, {-1, -2}, {-1, 2},
      {1, -2}, {1, 2}, {2, -1}, {2, 1}
    }
    for _, move in ipairs(knightMoves) do
      local attackRow, attackCol = row + move[1], col + move[2]
      if attackRow >= 1 and attackRow <= 8 and attackCol >= 1 and attackCol <= 8 and
         board[attackRow][attackCol] == opponentChar .. "n" then
        return true
      end
    end
  
    local rookDirections = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    for _, direction in ipairs(rookDirections) do
      local dx, dy = direction[1], direction[2]
      local newRow, newCol = row + dx, col + dy
      while newRow >= 1 and newRow <= 8 and newCol >= 1 and newCol <= 8 do
        local piece = board[newRow][newCol]
        if piece == opponentChar .. "r" or piece == opponentChar .. "q" then
          return true
        elseif piece ~= " " then
          break 
        end
        newRow, newCol = newRow + dx, newCol + dy
      end
    end
  
    local bishopDirections = {{-1, -1}, {-1, 1}, {1, -1}, {1, 1}}
    for _, direction in ipairs(bishopDirections) do
      local dx, dy = direction[1], direction[2]
      local newRow, newCol = row + dx, col + dy
      while newRow >= 1 and newRow <= 8 and newCol >= 1 and newCol <= 8 do
        local piece = board[newRow][newCol]
        if piece == opponentChar .. "b" or piece == opponentChar .. "q" then
          return true
        elseif piece ~= " " then
          break  
        end
        newRow, newCol = newRow + dx, newCol + dy
      end
    end
  
    local kingMoves = {
      {-1, -1}, {-1, 0}, {-1, 1},
      {0, -1},            {0, 1},
      {1, -1}, {1, 0},  {1, 1}
    }
    for _, move in ipairs(kingMoves) do
      local attackRow, attackCol = row + move[1], col + move[2]
      if attackRow >= 1 and attackRow <= 8 and attackCol >= 1 and attackCol <= 8 and
         board[attackRow][attackCol] == opponentChar .. "k" then
        return true
      end
    end
  
    return false  
end
  

local function findKingPosition(isWhiteTurn)
    local kingChar = isWhiteTurn and "K" or "k"
    for row = 1, 8 do
      for col = 1, 8 do
        if board[row][col] == kingChar then
          return row, col
        end
      end
    end
    return nil, nil
end
  
  
local function isCheckmate(isWhiteTurn)
    local kingRow, kingCol = findKingPosition(isWhiteTurn)
    if isSquareUnderAttack(kingRow, kingCol, isWhiteTurn) then
      for row = 1, 8 do
        for col = 1, 8 do
          if isWhiteTurn and isWhitePiece(board[row][col]) then
            for newRow = 1, 8 do
              for newCol = 1, 8 do
                if isValidMove(row, col, newRow, newCol) and not isSquareUnderAttack(newRow, newCol, isWhiteTurn) then
                  return false 
                end
              end
            end
          elseif not isWhiteTurn and isBlackPiece(board[row][col]) then
            for newRow = 1, 8 do
              for newCol = 1, 8 do
                if isValidMove(row, col, newRow, newCol) and not isSquareUnderAttack(newRow, newCol, isWhiteTurn) then
                  return false
                end
              end
            end
          end
        end
      end
      return true
    end
    return false
end

local function isStalemate(isWhiteTurn)
    for row = 1, 8 do
      for col = 1, 8 do
        if (isWhiteTurn and isWhitePiece(board[row][col])) or (not isWhiteTurn and isBlackPiece(board[row][col])) then
          for newRow = 1, 8 do
            for newCol = 1, 8 do
              if isValidMove(row, col, newRow, newCol) and not isSquareUnderAttack(newRow, newCol, isWhiteTurn) then
                return false 
              end
            end
          end
        end
      end
    end
    return true
end
  
local function main()
    while true do
      printBoard()
      io.write("Enter your move (e.g., 'a2 a4'): ")
      local move = io.read("*line")
  
      local startColChar, startRowStr, endColChar, endRowStr = string.match(move, "([a-h])([1-8]) ([a-h])([1-8])")
  
      if startColChar and startRowStr and endColChar and endRowStr then
        local startCol = string.byte(startColChar) - string.byte("a") + 1
        local startRow = tonumber(startRowStr)
        local endCol = string.byte(endColChar) - string.byte("a") + 1
        local endRow = tonumber(endRowStr)
  
        if movePiece(startRow, startCol, endRow, endCol) then
          io.write("\n")
          io.write("Press Enter to end your turn.")
          io.read("*line")
  
          if isCheckmate() then
            io.write("Checkmate! Game over.\n")
            break
          elseif isStalemate() then
            io.write("Stalemate! Game over.\n")
            break
          end
        else
          io.write("Invalid move. Please try again.\n")
        end
      else
        io.write("Invalid move format. Please use the format 'a2 a4'.\n")
      end
    end
end
  
  
main() 
