angular = require 'angular'

angular.module 'ThemisComponentsApp', [
  require 'angular-route'
  require 'angular-sanitize'
  require '../../themis_components/index.coffee' # requiring ThemisComponents
]

require './initializeRoutes'
require './controllers'
