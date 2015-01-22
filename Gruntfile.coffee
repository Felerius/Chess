serverScripts = ['*.coffee', '!Gruntfile.coffee']

module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compileServer:
        files: [
          expand: true
          cwd: ''
          src: serverScripts
          ext: '.coffee.js'
        ]
    watch:
      serverScripts:
        files: serverScripts
        tasks: ['coffee:compileServer']

  grunt.loadNpmTasks p for p in [
    'grunt-contrib-coffee'
    'grunt-contrib-watch'
  ]

  grunt.registerTask 'compile', ['coffee:compileServer']
  grunt.registerTask 'automate', ['compile', 'watch']