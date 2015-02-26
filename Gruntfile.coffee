module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  config = {}
  for file in grunt.file.expand {cwd: 'build'}, ['*.coffee']
    taskname = file.replace /\.coffee/, ''
    config[taskname] = require './build/' + file

  grunt.initConfig config

  grunt.registerTask 'build', ['coffee', 'sass', 'copy', 'browserify:compile']
  grunt.registerTask 'serve', ['clean', 'build', 'concurrent:dev']
