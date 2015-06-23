overlayTemplate = """
  <div class="th-popover-overlay"></div>
"""

template = """
  <div
    class="th-popover-view"
    ng-class="{ loading: !loaded }"
    >
    <i></i>
    <div
      class="th-popover-content"
      th-compile="content"
      ></div>
  </div>
"""

angular.module('ThemisComponents')
  .directive "thPopover", ($compile, $rootScope, $timeout, $http) ->
    restrict: "A"
    scope: true
    link: ($scope, element, attributes) ->
      view = null
      arrow = null
      overlay = null

      templateURL = attributes.thPopover
      $scope.loaded = no
      $scope.content = ""

      positionPopover = ->
        # Reset our width so we can measure without being effected
        # by the loading restrictions.
        view.css
          width: "auto"

        minInset = 12

        # Get some sizes we need.
        anchorRect = element[0].getBoundingClientRect()
        viewRect = view[0].getBoundingClientRect()

        # Setup our width. If we are loading set a sensible default.
        maxWidth = window.innerWidth - minInset*3
        viewWidth = if $scope.loaded then Math.min maxWidth, viewRect.width else 200

        # Assuming no window bounds where would we like to be?
        viewGoalLeft = anchorRect.left + anchorRect.width/2 - viewWidth/2

        # Enforce left boundary.
        minLeft = minInset
        viewLeft = Math.max minLeft, viewGoalLeft

        # Enforce right boundary.
        minRight = window.innerWidth - viewWidth - minInset*3
        viewLeft = Math.min minRight, viewGoalLeft if viewGoalLeft > 0

        # Position the popover.
        view.css
          top: "#{ anchorRect.top + anchorRect.height + 10 }px"
          left: "#{ viewLeft }px"
          width: "#{ viewWidth }px"

        # Position the arrow.
        arrow.css
          left: "#{ anchorRect.left - viewLeft + anchorRect.width/2 }px"

      $scope.$on 'thPopover.dismiss', ->
        overlay?.remove()
        view?.remove()

      element.on 'click', -> $scope.$apply ->
        view = angular.element template unless view?
        overlay = angular.element overlayTemplate unless overlay?
        arrow = view.find 'i'

        body = angular.element(document.body)
        body.append overlay
        body.append view

        overlay.on 'click', ->
          $scope.dismiss()

        $compile(view)($scope)

        $timeout ->
          positionPopover()

        view.on 'click', (event) ->
          # When an A tag in a popover and is clicked the popover should normally
          # close. However, we do have components that will live in popovers that
          # will be exceptions to this rule.
          whitelist = [
            '.chzn-container *'
            '.th-switch *'
          ]
          whitelistSelector = whitelist.join ', '

          if !event.target.matches(whitelistSelector) and event.target.matches("a, a *")
            $scope.$apply -> $scope.dismiss()

        unless $scope.loaded
          $http.get templateURL
          .then (response) ->
            $scope.loaded = yes
            $scope.content = response.data
            $timeout ->
              positionPopover()
          , ->
            $scope.dismiss()


      $scope.dismiss = ->
        $scope.$broadcast 'thPopover.dismiss'
