context = describe
describe "ThemisComponents: Directive: thItem", ->
  element = null

  context "with href", ->
    beforeEach ->
      element = compileDirective("""<th-item name="First" href="#"><th-item>""").element
    it "replace directive with anchor with class 'dropdown-item'", ->
      expect(element).not.toBe null
      expect(element.is("a")).toBe true
      expect(element.hasClass("dropdown-item")).toBe true
    it "sets text of anchor with name attribute", ->
      expect(element.text()).toMatch "First"
    it "set anchor element href attr with href attribute", ->
      expect(element.attr("href")).toMatch "#"

  context "with icon", ->
    beforeEach ->
      element = compileDirective("""<th-item name="first" href="#" icon="icn"></th-item>""").element
    it "add i element to the anchor element", ->
      expect(element.find("i").length).toEqual 1
    it "sets class based on icon attribute", ->
      expect(element.find("i").hasClass("fa fa-icn"))

  context "with action", ->
    beforeEach ->
      template = """<th-item name="First" ng-click="action()"></th-item>"""
      element = compileDirective(template, {action: -> alert 'response'}).element
    it "adds attr 'ng-click' set to anchor tag", ->
      expect(element.attr('ng-click')).toMatch "action()"
    it "adds attr 'href' with value of '#'", ->
      expect(element.attr("href")).toMatch "#"
    it "replace directive with anchor with class 'dropdown-item'", ->
      expect(element).not.toBe null
      expect(element.is("a")).toBe true
      expect(element.hasClass("dropdown-item")).toBe true
    it "add anchor element", ->
      expect(element.length).toEqual 1
    it "sets text of anchor with name attribute", ->
      expect(element.text()).toMatch "First"

    context "and when dropdown item is clicked", ->
      it "invokes the action", ->
        spyOn(window, 'alert')
        element.triggerHandler 'click'
        expect(window.alert).toHaveBeenCalledWith 'response'
