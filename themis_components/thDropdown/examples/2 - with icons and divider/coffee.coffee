angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @foo = ->
      alert "foo"

    @links = [
      { name: "Link One", href: "#", icon: "anchor" }
      { name: "Link Two", href: "#", icon: "car"}
      { divider: 'true' }
      { name: "Action One", ngClick: @foo, icon: "star" }
      { name: "Action Two", ngClick: @foo, icon: "star-o" }
    ]

    return
