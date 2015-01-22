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
    clean:
      serverScripts: ['*.coffee.js']
    nodemon:
      dev:
        script: 'server.coffee.js'
        ext: 'coffee.js'
    concurrent:
      dev: ['nodemon:dev', 'watch']
      options:
        logConcurrentOutput: true

  grunt.loadNpmTasks p for p in [
    'grunt-contrib-coffee'
    'grunt-contrib-watch'
    'grunt-contrib-clean'
    'grunt-nodemon'
    'grunt-concurrent'
  ]

  grunt.registerTask 'compile', ['coffee:compileServer']
  grunt.registerTask 'automate', ['clean', 'compile', 'concurrent:dev']