field = require '../field'

class InputComponent
  constructor: (@msgSystem) ->
    @currentHighlighted = null
    @wasCurrentClicked = false
    @_addEventListeners()
    @msgSystem.on 'statusUpdated', @_onStatusUpdated
    @msgSystem.on 'move', @_onMove

  _addEventListeners: ->
    for f in field.all()
      svgField = document.getElementById f
      svgField.addEventListener 'click', @_onFieldClick
      svgField.addEventListener 'mouseover', @_onFieldMouseOver

  _onStatusUpdated: (status, init) =>
    @status = status
    if @currentHighlighted?
      moves = status.getPossibleMoves @currentHighlighted
      active = status.playerActive and @wasCurrentClicked
      @msgSystem.send 'pieceSelected', @currentHighlighted, moves, active

  _onMove: (move) =>
    changedFields = [move.from]
    changedFields.push(move.captured) if move.captured?
    changedFields.push(move.secondaryMove.from) if move.secondaryMove?
    if @currentHighlighted in changedFields
      @currentHighlighted = null

  _handleNonActiveHighlight: (f, isClick) ->
    piece = @status.board.get f
    # Test for inactive selection or hover
    if piece?
      @msgSystem.send 'pieceSelected', f, @status.getPossibleMoves(f), false
      @currentHighlighted = f
      @wasCurrentClicked = isClick
    else
      @msgSystem.send 'pieceSelected', null
      @currentHighlighted = null

  _onFieldClick: (event) =>
    f = event.target.id
    if @status.playerActive
      # Test for move
      if @currentHighlighted? and @wasCurrentClicked and @status.playerColor is @status.board.get(@currentHighlighted).color
        move = @_tryFindMove f
        if move?
          @msgSystem.send 'move', move
          @msgSystem.send 'pieceSelected', null
          @currentHighlighted = null
          return
      # Test for active selection
      piece = @status.board.get f
      if piece?.color is @status.playerColor
        @msgSystem.send 'pieceSelected', f, @status.getPossibleMoves(f), true
        @currentHighlighted = f
        @wasCurrentClicked = true
        return
    @_handleNonActiveHighlight f, true

  _onFieldMouseOver: (event) =>
    return if @currentHighlighted? and @wasCurrentClicked
    @_handleNonActiveHighlight event.target.id, false

  _tryFindMove: (f) ->
    moves = @status.getPossibleMoves(@currentHighlighted)
    if moves?
      return (m for m in moves when m.to is f)[0]
    return null

module.exports = InputComponent
