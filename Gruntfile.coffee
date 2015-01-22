module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compileServer:
        files: [
          expand: true
          cwd: ''
          src: ['*.coffee', '!Gruntfile.coffee']
          ext: '.coffee.js'
        ]

  grunt.loadNpmTasks 'grunt-contrib-coffee'