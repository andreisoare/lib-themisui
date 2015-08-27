angular.module('ThemisComponents')
  .directive "thComponentExample", ($location) ->
    restrict: "EA"
    scope:
      componentName: '=componentName'
      example: '=componentExample'
    replace: true
    template: """
      <div class="th-component-example">
        <h3>{{ example.name }}</h3>
        <form
          action="http://codepen.io/pen/define"
          method="POST"
          target="_blank"
          >

          <input type="hidden" name="data" value='{{ penData }}'>
          <header>
            <a href="" ng-click="showTab('example')">Example
            </a><a href="" ng-click="showTab('html')">HTML
            </a><a href="" ng-click="showTab('coffee')">CoffeeScript
            </a>

            <!--<input type="submit" value="Run in CodePen">-->
          </header>
          <iframe
            ng-show="mode == 'example'"
            scrolling="auto"
            frameborder="0"
            marginheight="0"
            marginwidth="0"
            scrolling="no"
            >
          </iframe>
          <pre ng-show="mode == 'html'"><code class="language-markup">{{ example.html }}</code></pre>
          <pre ng-show="mode == 'coffee'"><code class="language-coffeescript">{{ example.coffee }}</code></pre>
          <div class="loading" ng-show="mode == ''">Loading…</div>
        </form>
        </div>
    """
    controller: ($scope, $element, $timeout) ->
      example = $scope.example

      includeBase = "#{$location.protocol()}://#{$location.host()}:#{$location.port()}"
      includeJS  = [
        "#{includeBase}/build/examples.js"
      ]
      includeCSS = [
        "#{includeBase}/build/examples.css"
        "//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css"
      ]

      exampleInitialized = no
      initializeExample = ->
        exampleInitialized = yes
        $scope.mode = ''

        exampleFrame = $element.find('iframe')[0]
        if exampleFrame?
          html = example.html

          styles = for styleSrc in includeCSS
            "<link href=\"#{styleSrc}\" rel=\"stylesheet\" type=\"text/css\">"
          html = html.replace '</body>', "#{styles.join('')}</body>"

          js = includeJS[..]
          js.push "#{includeBase}/components/#{$scope.componentName}/examples/#{example.name}.js"
          scripts = for scriptSrc in js
            "<script src=\"#{scriptSrc}\"></script>"
          html = html.replace '</body>', "#{scripts.join('')}</body>"

          exampleFrame.contentWindow.document.open()
          exampleFrame.contentWindow.document.write html
          exampleFrame.contentWindow.document.close()

          exampleFrame.contentWindow.document.addEventListener "DOMSubtreeModified", ->
            $timeout ->
              exampleFrame.style.height = '0px'
              exampleFrame.style.height = exampleFrame.contentWindow.document.body.scrollHeight + 10 + 'px'
            , 100

          exampleFrame.style.height = '0px'
          $timeout ->
            $scope.mode = 'example'
            exampleFrame.style.height = exampleFrame.contentWindow.document.body.scrollHeight + 10 + 'px'
          , 1500

          $timeout -> Prism.highlightAll()

      $scope.penData = JSON.stringify
        title: "#{$scope.componentName} - #{example.name}"
        html: example.html
        js: example.coffee
        js_pre_processor: "coffeescript"
        js_external: includeJS.join ";"
        css_external: includeCSS.join ";"

      $scope.showTab = (name) ->
        $scope.mode = name

        if name is 'example' and not exampleInitialized
          initializeExample()

      $scope.showTab 'example'
