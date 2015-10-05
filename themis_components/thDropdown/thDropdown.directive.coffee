template = """
  <div class="button-dropdown">
    <div class="dd-overlay" ng-click="dropdown.toggle()" ng-if="dropdown.visible"></div>
    <a href="#"
      ng-class="dropdown.type"
      ng-click="dropdown.toggle()">
      {{dropdown.name}}
      <i class="fa" ng-class="dropdown.toggleCaret()"></i>
    </a>
    <div
      ng-click="dropdown.toggle()"
      ng-if="dropdown.visible"
      class="dropdown-menu"
      ng-class="dropdown.type"
      >
      <ng-switch on="item.type" ng-repeat="item in dropdown.processedItems">
        <th-item ng-switch-when='link'
          name="{{item.name}}"
          href="{{item.href}}"
          icon="{{item.icon}}">
        </th-item>
        <th-item ng-switch-when='action'
          name="{{item.name}}"
          ng-click="item.ngClick()"
          icon="{{item.icon}}">
        </th-item>
        <th-divider ng-switch-default></th-divider>
      </ng-switch>
      <ng-transclude></ng-transclude>
    </div>
  </div>
"""

angular.module("ThemisComponents")
  .directive "thDropdown", ->
    restrict: "E"
    template: template
    replace: true
    controllerAs: "dropdown"
    bindToController: true
    transclude: true
    scope:
      name: "@"
      list: "="
      type: "@"
      disabled: "@"
    controller: ($element, $attrs) ->
      @processedItems = []
      @list = @list ? []
      @visible = false

      @toggle = ->
        @visible = !@visible

      @toggleCaret = ->
        if @visible then 'fa-caret-up' else 'fa-caret-down'

      processList = =>
        for item in @list
          if item.href?
            item.type = "link"
            @processedItems.push item
          else if item.ngClick?
            item.type = "action"
            @processedItems.push item
          else
            @processedItems.push item

      processList()
      return

    link: (scope, elem, attr) ->
      # set button to disabled if attr passed
      elem.find("a").attr('disabled', 'disabled') if attr.disabled?

      elem.on 'click', (event) ->
        menu = elem[0].getElementsByClassName("dropdown-menu")[0]
        # if menu hidden. no need to adjust
        return if menu == undefined
        # append to the body to avoid overflow issues with parent element
        body = angular.element(document.body)
        body.append(menu)

        # sizes needed to check location
        menuWidth = menu?.offsetWidth
        bodyRightPosition = document.body.getBoundingClientRect().right
        buttonRect = elem[0].getBoundingClientRect()

        # adjusted positions
        adjustedTop = buttonRect.top + buttonRect.height + 2
        adjustedRight = bodyRightPosition - buttonRect.right

        # dropdown menu list defaults to right alignment to button
        # if the button is left aligned let's set menu left align
        if (menuWidth > buttonRect.right)
          angular.element(menu).css
            top: adjustedTop
            right: "inherit"
        else
          angular.element(menu).css
            top: adjustedTop
            right: adjustedRight

