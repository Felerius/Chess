module.exports =
  views:
    files: [
      expand: true
      cwd: 'server/views'
      src: ['**']
      dest: 'dist/views'
    ]
  packageJson:
    files:
      'dist/package.json': 'package.json'
