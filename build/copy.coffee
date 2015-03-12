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
  openshiftHooks:
    options:
      # Keep file permissions
      mode: true
    files: [
      expand: true
      cwd: 'deployment/openshift/hooks'
      src: '*'
      dest: 'dist/.openshift/action_hooks'
    ]
