module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      server:
        files: [
          expand: true
          cwd: 'server'
          src: ['**/*.coffee']
          dest: 'dist/'
          ext: '.js'
        ]
      client:
        files: [
          expand: true
          cwd: 'client'
          src: ['scripts/**/*.coffee', '!scripts/game/**/*.coffee']
          dest: 'dist/public/'
          ext: '.js'
        ]
    sass:
      styles:
        files: [
          expand: true
          cwd: 'client'
          src: ['styles/**/*.scss']
          dest: 'dist/public/'
          ext: '.css'
        ]
    browserify:
      game:
        files:
          'dist/public/scripts/game.bundle.js': 'client/scripts/game/index.coffee'
        options:
          transform: ['coffeeify']
          browserifyOptions:
            extensions: ['.coffee']
            debug: true
    copy:
      views:
        files: [
          expand: true
          cwd: 'server'
          src: ['views/**']
          dest: 'dist/'
        ]
    clean: ['dist/*']

  grunt.loadNpmTasks p for p in [
    'grunt-contrib-coffee'
    'grunt-contrib-watch'
    'grunt-contrib-clean'
    'grunt-contrib-copy'
    'grunt-nodemon'
    'grunt-concurrent'
    # Uses libsass, a c library, quicker then the ruby version but potentially
    # incomplete. Check here: http://sass-compatibility.github.io/.
    # Consider replacing with https://github.com/gruntjs/grunt-contrib-sass
    # if missing features are needed
    'grunt-sass'
    'grunt-browserify'
  ]

  grunt.registerTask 'build', ['coffee', 'sass', 'copy', 'browserify:game']
