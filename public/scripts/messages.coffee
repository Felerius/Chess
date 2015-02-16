class MessageSystem
  constructor: ->
    @handlers = {}

  on: (type, handler) ->
    if type not of @handlers
      @handlers[type] = []
    @handlers[type].push handler

  send: (type, args...) ->
    return if not @handlers[type]?
    for handler in @handlers[type]
      handler args...

module.exports = MessageSystem
