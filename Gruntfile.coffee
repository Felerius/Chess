serverScripts = ['*.coffee', '!Gruntfile.coffee']
styles = ['public/styles/**/*.scss']
browserifyBundles =
  'public/scripts/chess.bundle.js': 'public/scripts/chess.coffee'

module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      compileServer:
        files: [
          expand: true
          src: serverScripts
          ext: '.js'
        ]
    sass:
      styles:
        files: [
          expand: true
          src: styles
          ext: '.css'
        ]
    browserify:
      compileClientScripts:
        files: browserifyBundles
        options:
          transform: ['coffeeify']
          browserifyOptions:
            extensions: ['.coffee']
            debug: true
      watchClientScripts:
        files: browserifyBundles
        options:
          transform: ['coffeeify']
          watch: true
          keepAlive: true
          browserifyOptions:
            extensions: ['.coffee']
            debug: true
    watch:
      serverScripts:
        files: serverScripts
        tasks: ['coffee:compileServer']
      styles:
        files: styles
        tasks: ['sass:styles']
    clean:
      serverScripts: ['*.js']
      styles: ['public/styles/**/*.css']
      clientScript: ['public/scripts/**/*.bundle.js']
    nodemon:
      dev:
        script: 'server.js'
        options:
          ignore: ['node_modules/', 'public/']
          ext: 'js'
    concurrent:
      dev: ['nodemon:dev', 'watch', 'browserify:watchClientScripts']
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
    'grunt-browserify'
  ]

  grunt.registerTask 'compile', ['coffee:compileServer', 'sass:styles', 'browserify:compileClientScripts']
  grunt.registerTask 'automate', ['clean', 'compile', 'concurrent:dev']
