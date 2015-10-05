angular.module("ThemisComponents")
  .directive "thDivider", ->
    restrict: "E"
    replace: true
    scope: {}
    template: """
      <hr class="th-divider"></hr>
    """


