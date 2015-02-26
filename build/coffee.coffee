module.exports =
  server:
    files: [
      expand: true
      cwd: 'server'
      src: ['**/*.coffee']
      dest: 'dist'
      ext: '.js'
    ]
  client:
    files: [
      expand: true
      cwd: 'client/scripts'
      src: ['**/*.coffee', '!game/**']
      dest: 'dist/public/scripts'
      ext: '.js'
    ]
