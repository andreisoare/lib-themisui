angular.module 'ThemisComponents'
  .directive 'thTableCell', ->
    restrict: 'E'
    require: '^thTableRow'
    bindToController: true
    controllerAs: 'thTableCell'
    controller: ->
      return
    link: (scope, element, attrs, thTable) ->
      return
