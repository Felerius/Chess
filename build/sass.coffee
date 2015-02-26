module.exports =
  styles:
    files: [
      expand: true
      cwd: 'client/styles'
      src: ['**/*.scss']
      dest: 'dist/public/styles'
      ext: '.css'
    ]
