describe 'ThemisComponents: Directive: thPopover', ->
  element = httpBackend = scope = compile = defaultState = null
  validTemplate = """
    <a href="" th-popover="/template.html">Popover</a>
  """
  mockResponse = "<h1>Popover</h1>"

  compileDirective = (state, template) ->
    template = template ? validTemplate
    element = compile(template)(scope)
    scope.$digest()

    return element

  beforeEach module 'ThemisComponents'

  beforeEach inject ($injector) ->
    httpBackend = $injector.get '$httpBackend'
    scope = $injector.get('$rootScope').$new()
    compile = $injector.get '$compile'

  beforeEach ->
    httpBackend.when('GET', '/template.html').respond mockResponse
    element = compileDirective()

  afterEach ->
    # Cleanup any popovers we may leave open after tests run.
    for overlay in document.querySelectorAll('.th-popover-overlay')
      angular.element(overlay).triggerHandler 'click'

  it 'should request a template', ->
    element.triggerHandler 'click'
    httpBackend.flush()
    httpBackend.expectGET '/template.html'

  it 'should open popover', ->
    element.triggerHandler 'click'
    expect(document.querySelector('.th-popover-view')).not.toBeNull()

  it 'should open overlay under the popover', ->
    element.triggerHandler 'click'
    expect(document.querySelector('.th-popover-overlay')).not.toBeNull()

  it 'should close after it opens', ->
    element.triggerHandler 'click'
    angular.element(document.querySelector('.th-popover-overlay')).triggerHandler 'click'

    expect(document.querySelector('.th-popover-view')).toBeNull()
    expect(document.querySelector('.th-popover-overlay')).toBeNull()
