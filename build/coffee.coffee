module.exports =
  server:
    files: [
      expand: true
      cwd: 'server'
      src: ['**/*.coffee']
      dest: 'dist'
      ext: '.js'
      # Needed for things like config.default.coffee
      extDot: 'last'
    ]
  client:
    files: [
      expand: true
      cwd: 'client/scripts'
      src: ['**/*.coffee', '!game/**']
      dest: 'dist/public/scripts'
      ext: '.js'
    ]
  openshiftConfig:
    files:
      'dist/config.js': 'deployment/openshift.config.coffee'
