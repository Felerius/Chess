io = require 'socket.io-client'
field = require './field'
Board = require './board'
MessageSystem = require './messages'
NetworkComponent = require './components/network'
InputComponent = require './components/input'
ViewComponent = require './components/view'
LogicComponent = require './components/logic'

assignFields = (side) ->
  for svgField in document.querySelectorAll '#board > .field'
    col = parseInt(svgField.getAttribute('x')) / 100
    row = parseInt(svgField.getAttribute('y')) / 100
    rankNum = if side is 'light' then 7 - row else row
    fileNum = if side is 'light' then col else 7 - col
    svgField.id = field.fromNumbers fileNum, rankNum

logMessage = (type, args, numListeners) ->
  console.log("#{type} (#{numListeners} listeners)")
  console.log(args)

socket = io()
socket.on 'init', (msgData) ->
  assignFields msgData.side
  data =
    playerActive: msgData.side is 'light'
    board: new Board()
  msgSystem = new MessageSystem(logMessage)
  network = new NetworkComponent(msgSystem, data, socket)
  input = new InputComponent(msgSystem, data, msgData.side)
  view = new ViewComponent(msgSystem, data)
  logic = new LogicComponent(msgSystem, data)
  # Gives components the chance to perform initialization that relies on
  # the other components existing
  msgSystem.send 'init'
