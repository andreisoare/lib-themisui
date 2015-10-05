angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @foo = ->
      alert "foo"

    return
