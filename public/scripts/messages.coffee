class MessageSystem
  constructor: ->
    handlers = {}

  on: (type, handler) ->
    if event not of @handlers
      @handlers[type] = []
    @handlers[type].push handler

  send: (type, args...) ->
    for handler in @handlers[type]
      handler args...

module.exports = () -> new MessageSystem()
