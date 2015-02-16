field = require '../field'

class InputComponent
  constructor: (@msgSystem, @data, @playerColor) ->
    @currentHighlighted = null
    @wasCurrentClicked = false
    @_addEventListeners()
    @msgSystem.on 'movesCalculated', @_onMovesCalculated

  _addEventListeners: ->
    for f in field.all()
      svgField = document.getElementById f
      svgField.addEventListener 'click', @_onFieldClick
      svgField.addEventListener 'mouseover', @_onFieldMouseOver
      svgField.addEventListener 'mouseout', @_onFieldMouseOut

  _onMovesCalculated: (possibleMoves) =>
    @possibleMoves = possibleMoves

  _handleNonActiveHighlight: (f, isClick) ->
    piece = @data.board.get f
    # Test for inactive selection or hover
    if piece?
      @msgSystem.send 'pieceSelected', f, @possibleMoves[f], false
      @currentHighlighted = f
      @wasCurrentClicked = isClick
    else
      @msgSystem.send 'pieceSelected', null
      @currentHighlighted = null

  _onFieldClick: (event) =>
    f = event.target.id
    if @data.playerActive
      # Test for move
      if @currentHighlighted? and @wasCurrentClicked
        move = @_tryFindMove f
        if move?
          @msgSystem.send 'move', move
          @msgSystem.send 'pieceSelected', null
          @currentHighlighted = null
          return
      piece = @data.board.get f
      # Test for active selection
      if piece?.color is @playerColor
        @msgSystem.send 'pieceSelected', f, @possibleMoves[f], true
        @currentHighlighted = f
        @wasCurrentClicked = true
        return
    @_handleNonActiveHighlight f, true

  _onFieldMouseOver: (event) =>
    @_handleNonActiveHighlight event.target.id, false

  _onFieldMouseOut: (event) =>

  _tryFindMove: (f) ->
    moves = @possibleMoves[@currentHighlighted]
    if moves?
      return (m for m in moves when m.to is f)[0]
    return null

module.exports = InputComponent
