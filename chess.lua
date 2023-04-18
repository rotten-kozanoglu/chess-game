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

local function validMove(startRow, startCol, endRow, endCol)
  local piece = board[startRow][startCol]
  local target = board[endRow][endCol]
  if target ~= " " and string.sub(target, 1, 1) == string.sub(piece, 1, 1) then
    return false
  end
  if piece == "P" then
    local diffRow = endRow - startRow
    local diffCol = math.abs(endCol - startCol)
    if diffRow == 1 and diffCol == 0 and target == " " then
      return true -- Forward one
    elseif diffRow == 2 and diffCol == 0 and startRow == 2 and target == " " and board[startRow + 1][startCol] == " " then
      return true -- Forward two
    elseif diffRow == 1 and diffCol == 1 and target ~= " " then
      return true -- Capture diagonally
    else
      return false
    end
  end
  return true
end

local function movePiece(startRow, startCol, endRow, endCol)
  if validMove(startRow, startCol, endRow, endCol) then
    board[endRow][endCol] = board[startRow][startCol]
    board[startRow][startCol] = " "
    return true
  else
    return false
  end
end

while true do
  for i = 1, 8 do
    io.write("|")
    for j = 1, 8 do
      io.write(board[i][j] .. "|")
    end
    io.write("\n")
  end

  io.write("Enter your move (e.g. 'a2 a3'): ")
  local move = io.read("*line")
  local startCol = string.byte(string.sub(move, 1, 1)) - string.byte("a") + 1
  local startRow = tonumber(string.sub(move, 2, 2))
  local endCol = string.byte(string.sub(move, 4, 4)) - string.byte("a") + 1
  local endRow = tonumber(string.sub(move, 5, 5))
  if movePiece(startRow, startCol, endRow, endCol) then  
    io.write("\n")
    io.write("Press Enter to end your turn.")
    io.read("*line")
  else
    io.write("Invalid move. Please try again.\n")
  end
end
