linkTemplate = """
  <a class="dropdown-item" href="{{href}}">
    <i ng-if="icon" class="fa fa-{{icon}}"></i>
    {{name}}
  </a>
"""

actionTemplate = """
  <a class="dropdown-item" href="#">
    <i ng-if="icon" class="fa fa-{{icon}}"></i>
    {{name}}
  </a>
"""

angular.module("ThemisComponents")
  .directive "thItem", ->
    restrict: "E"
    replace: true
    require: "^thDropdown"
    scope:
      href: "@"
      name: "@"
      icon: "@"
    template: (element, attrs) ->
      switch
        when attrs.href?
          linkTemplate
        else
          actionTemplate





