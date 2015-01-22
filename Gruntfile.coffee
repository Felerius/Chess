serverScripts = ['*.coffee', '!Gruntfile.coffee']
styles = ['public/styles/**/*.scss']

module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compileServer:
        files: [
          expand: true
          src: serverScripts
          ext: '.coffee.js'
        ]
    sass:
      styles:
        files: [
          expand: true
          src: styles
          ext: '.scss.css'
        ]
    watch:
      serverScripts:
        files: serverScripts
        tasks: ['coffee:compileServer']
      styles:
        files: styles
        tasks: ['sass:styles']
    clean:
      serverScripts: ['*.coffee.js']
      styles: ['public/styles/**/*.scss.css']
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
    # Uses libsass, a c library, quicker then the ruby version but potentially
    # incomplete. Check here: http://sass-compatibility.github.io/.
    # Consider replacing with https://github.com/gruntjs/grunt-contrib-sass
    # if missing features are needed
    'grunt-sass'
  ]

  grunt.registerTask 'compile', ['coffee:compileServer', 'sass:styles']
  grunt.registerTask 'automate', ['clean', 'compile', 'concurrent:dev']