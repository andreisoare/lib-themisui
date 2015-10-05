angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @genres = [
      { name: "Action", href: "#" }
      { name: "Science Fiction", href: "#" }
      { name: "Drama", href: "#" }
    ]
    @settings = [
      { name: "Name", href: "#" }
      { name: "Avatar", href: "#" }
      { name: "Address", href: "#" }
    ]
    return
