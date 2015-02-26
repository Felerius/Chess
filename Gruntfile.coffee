module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  # Load and apply config
  config = {}
  for file in grunt.file.expand {cwd: 'build'}, '*.coffee'
    taskname = file.replace /\.coffee/, ''
    config[taskname] = require './build/' + file

  grunt.initConfig config

  # Load tasks
  for file in grunt.file.expand {cwd: 'build/tasks'}, '*'
    tasks = grunt.file.read('build/tasks/' + file).match /[^\r\n]+/g
    grunt.registerTask file, tasks
