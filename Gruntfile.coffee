module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  config = {}
  for file in grunt.file.expand {cwd: 'build'}, ['*.coffee']
    taskname = file.replace /\.coffee/, ''
    config[taskname] = require './build/' + file

  grunt.initConfig config

  grunt.registerTask 'build', ['coffee:client', 'coffee:server', 'sass', 'copy:views', 'browserify:compile']
  grunt.registerTask 'serve', ['clean', 'build', 'concurrent:dev']
  grunt.registerTask 'deployOpenshift', ['clean', 'build', 'copy:packageJson', 'coffee:openshiftConfig', 'buildcontrol:openshift']
