module.exports =
  serverScripts:
    files: ['server/**/*.coffee']
    tasks: ['coffee:server']
  # Non browserify
  clientScripts:
    files: ['client/scripts/**/*.coffee', '!client/scripts/game/**']
    tasks: ['coffee:client']
  styles:
    files: ['client/styles/**/*.scss']
    tasks: ['sass']
  views:
    files: ['server/views/**']
    tasks: ['copy:views']
