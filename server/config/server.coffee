# Default config for testing

module.exports =
  port: process.env.PORT ? 8080
  ip: process.env.IP ? '127.0.0.1'
  sessionSecret: 'default-session-secret'
