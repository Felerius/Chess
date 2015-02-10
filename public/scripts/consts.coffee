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

  castling:
    light:
      kingSide:
        allBetween: ['f1', 'g1']
        kingTarget: 'g1'
        rookTarget: 'f1'
        rookStart: 'h1'
      queenSide:
        allBetween: ['b1', 'c1', 'd1']
        kingTarget: 'c1'
        rookTarget: 'd1'
        rookStart: 'a1'
    dark:
      kingSide:
        allBetween: ['f8', 'g8']
        kingTarget: 'g8'
        rookTarget: 'f8'
        rookStart: 'h8'
      queenSide:
        allBetween: ['b8', 'c8', 'd8']
        kingTarget: 'c8'
        rookTarget: 'd8'
        rookStart: 'a8'

  pawnStartRow:
    dark: 7
    light: 2

  oppositeColor:
    dark: 'light'
    light: 'dark'

  directions:
    forwardDiagonals:
      light: [dir.nw, dir.ne]
      dark: [dir.sw, dir.se]
    diagonals: [dir.nw, dir.ne, dir.se, dir.sw]
    straights: [dir.n, dir.e, dir.s, dir.w]
    all: [dir.n, dir.ne, dir.e, dir.se, dir.s, dir.sw, dir.w, dir.nw]
    knightJumps: [[1, 2], [2, -1], [2, 1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
    forward:
      light: dir.n
      dark: dir.s
