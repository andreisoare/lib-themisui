angular.module('ThemisComponents')
  .directive "thCheckbox", ->
    restrict: "EA"
    replace: true
    template: require './thCheckbox.template.html'
    scope:
      name: '@'
      change: '&ngChange'
      checked: '=ngModel'
    bindToController: true
    controllerAs: 'checkbox'
    controller: ($scope, $element) ->
      @checked = @checked ? false

      @toggle = ->
        $scope.$apply =>
          @checked = not @checked
        @change() if @change?

      $element.on 'click', =>
        @toggle()

      return
