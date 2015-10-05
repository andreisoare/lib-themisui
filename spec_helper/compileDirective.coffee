# Setup everything required to convert an HTML string into a compiled angular element
# Returns an object with element and scope.
window.compileDirective = (template, options, scope) ->
  compile = scope = q = null
  # Import components
  angular.mock.module 'ThemisComponents'

  # Inject
  inject ($rootScope, $compile) ->
    scope = scope ? $rootScope.$new()
    compile = $compile

  if options and options.promise
    inject ($q) -> q = $q
    scope.deferred = q.defer()
    scope.promise = scope.deferred.promise

  if options and options.action
    scope.action = options.action

  # Compile template
  wrappedTemplate = "<html ng-app>#{template}</html>"
  compiledElement = compile(wrappedTemplate)(scope)
  scope.$digest()
  {element: jQuery(compiledElement), scope: scope}
