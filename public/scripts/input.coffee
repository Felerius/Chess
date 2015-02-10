consts = require './consts'
field = require './field'

class GameInput
  constructor:  ->
    for f in field.all()
      svgField = document.getElementById f
      svgField.addEventListener 'click', @_onFieldClick

  _onFieldClick: (event) =>
    @onFieldClick event.target.id

module.exports = () -> new GameInput()
