# <input> wrapped in a <span> to avoid automatic copying of
inputTemplate = """
  <span class="th-input-wrapper">
    <span ng-if="input.prefix" class="th-input-prefix">{{input.prefix}}</span>
    <input
      class="th-input"
      ng-class="[{'with-icon': input.icon}, {'with-prefix': input.prefix}, {'with-postfix': input.postfix}]"
      id="{{input.id}}"
      type="{{input.type}}"
      name="{{input.name}}"
      value="{{input.value}}"
      placeholder="{{input.placeholder}}">

    <i ng-if="input.icon" class="th-input-icon fa fa-{{input.icon}}"></i>

    <span ng-if="input.postfix" class="th-input-postfix">{{input.postfix}}</span>
  </span>
"""

angular.module('ThemisComponents').directive "thInput", ->
  restrict: "E"
  bindToController: true
  controllerAs: 'input'
  replace: true
  scope:
    type: '@'
    name: '@'
    value: '@'
    icon: '@'
    prefix: '@'
    postfix: '@'
  template: inputTemplate
  controller: ($attrs) ->
    @placeholder = $attrs.placeholder

  link: (scope, element) ->
    # add box shadow on entire element when in focus
    element.find("input").on "focus", ->
      angular.element(this.parentElement).addClass("has-focus")
    element.find("input").on "blur", ->
      angular.element(this.parentElement).removeClass("has-focus")
    return
