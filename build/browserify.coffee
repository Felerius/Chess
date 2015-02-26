bundles =
  'dist/public/scripts/game.bundle.js': 'client/scripts/game/index.coffee'

module.exports =
  options:
    transform: ['coffeeify']
    browserifyOptions:
      extensions: ['.coffee']
      debug: true
  compile:
    files: bundles
  watch:
    files: bundles
    options:
      watch: true
      keepAlive: true
