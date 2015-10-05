angular = require 'angular'

angular.module('ThemisComponentsApp')
  .controller 'ComponentDetailsController', ($scope, $http, $sce) ->
    # Set blank state
    $scope.name = ""
    $scope.readme =
        markdown: """
          <br><br>
          **Greetings,**

          We're just loading things up. Everything will be good to go in a minute.

          *Cheerio!*
          <br><br>
        """

    $http.get '/readme.md'
    .then (response) ->
      $scope.readme = markdown: response.data

    $scope.examples = []

    $scope.$on 'selectedComponent', (event, component) ->
      $http.get "/components/#{component}.json"
      .then (response) ->
        $scope.name = component
        $scope.readme =
          markdown: response.data.readme
          html: $sce.trustAsHtml response.data.readmeHTML
        $scope.examples = response.data.examples

    $scope.penData = (name, example) ->
      JSON.stringify
        title: "#{name} - #{example.name}"
        html: example.html
        js: example.coffee
        js_pre_processor: "coffeescript"
        js_external: "http://localhost:3000/assets/themis_components/index.js"
        css_external: "http://localhost:3000/assets/themis_components/index.css"
