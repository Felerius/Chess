A_CHAR_CODE = "a".charCodeAt(0)

class Board
  constructor: (@darkSide) ->
      
  _fieldToNum: (field) ->
    file = field.charCodeAt(0) - A_CHAR_CODE
    rank = parseInt(field[1]) - 1
    num = file*8 + rank
    num = 63 - num if @darkSide
    return num

  _numToField: (num) ->
    num = 63 - num if @darkSide
    return String.fromCharCode(A_CHAR_CODE + Math.floor(num/8)) + (num % 8 + 1)

module.exports = (darkSide) -> new Board(darkSide)
