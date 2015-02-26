module.exports =
  game:
    files:
      'dist/public/scripts/game.bundle.js': 'client/scripts/game/index.coffee'
    options:
      transform: ['coffeeify']
      browserifyOptions:
        extensions: ['.coffee']
        debug: true
