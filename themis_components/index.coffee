angular = require 'angular'

angular.module 'ThemisComponents', [
  require 'angular-animate'
]

require './thBindMarkdown/'
require './thButton/'
require './thCheckbox/'
require './thCompile/'
require './thComponentExample/'
require './thContextualMessage/'
require './thDropdown/'
require './thInput/'
require './thLazy/'
require './thModal/'
require './thPopover/'
require './thSelect/'
require './thSwitch/'
require './thTabset/'
require './thWithLabel/'

module.exports = 'ThemisComponents'
