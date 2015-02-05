dir =
  n: [0, 1]
  ne: [1, 1]
  e: [1, 0]
  se: [1, -1]
  s: [0, -1]
  sw: [-1, -1]
  w: [-1, 0]
  nw: [-1, 1]

module.exports =
  numberBeginningPieces: 32
  beginningPieces:
    'c8': { piece: 'bishop', color: 'dark' }
    'f8': { piece: 'bishop', color: 'dark' }
    'c1': { piece: 'bishop', color: 'light' }
    'f1': { piece: 'bishop', color: 'light' }
    'e8': { piece: 'king', color: 'dark' }
    'e1': { piece: 'king', color: 'light' }
    'b8': { piece: 'knight', color: 'dark' }
    'g8': { piece: 'knight', color: 'dark' }
    'b1': { piece: 'knight', color: 'light' }
    'g1': { piece: 'knight', color: 'light' }
    'a7': { piece: 'pawn', color: 'dark' }
    'b7': { piece: 'pawn', color: 'dark' }
    'c7': { piece: 'pawn', color: 'dark' }
    'd7': { piece: 'pawn', color: 'dark' }
    'e7': { piece: 'pawn', color: 'dark' }
    'f7': { piece: 'pawn', color: 'dark' }
    'g7': { piece: 'pawn', color: 'dark' }
    'h7': { piece: 'pawn', color: 'dark' }
    'a2': { piece: 'pawn', color: 'light' }
    'b2': { piece: 'pawn', color: 'light' }
    'c2': { piece: 'pawn', color: 'light' }
    'd2': { piece: 'pawn', color: 'light' }
    'e2': { piece: 'pawn', color: 'light' }
    'f2': { piece: 'pawn', color: 'light' }
    'g2': { piece: 'pawn', color: 'light' }
    'h2': { piece: 'pawn', color: 'light' }
    'd8': { piece: 'queen', color: 'dark' }
    'd1': { piece: 'queen', color: 'light' }
    'a8': { piece: 'rook', color: 'dark' }
    'h8': { piece: 'rook', color: 'dark' }
    'a1': { piece: 'rook', color: 'light' }
    'h1': { piece: 'rook', color: 'light' }

  rookStarts:
    dark:
      queenSide: 'a8'
      kingSide: 'h8'
    light:
      queenSide: 'a1'
      kingSide: 'h1'

  pawnStartRow:
    dark: 7
    light: 2

  directions:
    forwardDiagonals:
      light: [dir.nw, dir.ne]
      dark: [dir.sw, dir.se]
    diagonals: [dir.nw, dir.ne, dir.se, dir.sw]
    forward:
      light: dir.n
      dark: dir.s
