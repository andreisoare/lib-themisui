context = describe
describe "ThemisComponents: Directive: thDropdown", ->
  element = null

  context "with default example", ->
    beforeEach ->
      element = compileDirective("""<th-dropdown name="button"></th-dropdown>""").element

    it "is wrapped in a <div> with class 'button-dropdown'", ->
      expect(element.hasClass("button-dropdown")).toBe true

    it "icon caret inits with class 'fa fa-caret-down'", ->
      expect(element.find("i").hasClass("fa fa-caret-down")).toBe true

    it "sets dropdown button text equal to name attr", ->
      expect(element.text()).toMatch "button"

    context "when clicked", ->
      beforeEach ->
        element.find('a').first().triggerHandler 'click'
      it "sets dropdown overlay to visible", ->
        expect(element.find("div.th-dropdown-overlay")).not.toBe null

      context "when backdrop is clicked", ->
        it "dismisses the dropdown list", ->
          element.find(".dd-overlay").triggerHandler 'click'
          expect(element.find("ul").length).toEqual 0

  context "with type", ->
    it "adds type name as a class to button", ->
      element = compileDirective("""<th-dropdown name="button" type="standard"></th-dropdown>""").element
      expect(element.find("a").first().hasClass("standard")).toBe true

  context "with link", ->
    beforeEach ->
      element = compileDirective("""<th-dropdown list="[{name:'link', href:'/example/link'}]"></th-dropdown>""").element

    context "when button is clicked", ->
      beforeEach ->
        element.find('a').first().triggerHandler 'click'

      it "displays a menu with items", ->
        expect(element.find(".dropdown-menu")).not.toBe null
        expect(element.find(".dropdown-item").length).toEqual 1

      it "icon caret inits with class 'fa fa-caret-up'", ->
        expect(element.find("i").hasClass("fa fa-caret-up")).toBe true

      it "adds a anchor tag to the dropdown item", ->
        a = element.find("a.dropdown-item")
        expect(a).not.toBe null
        expect(a.attr("href")).toMatch "/example/link"
        expect(a.text()).toMatch "link"

  context "link with an icon", ->
    beforeEach ->
      element = compileDirective("""<th-dropdown list="[{name:'link', href:'/example/link', icon: 'users'}]"></th-dropdown>""").element
    context "when button is clicked", ->
      beforeEach ->
        element.find('a').first().triggerHandler 'click'
      it "anchor has i element with class 'fa fa-users'", ->
        expect(element.find(".dropdown-item > i").hasClass("fa fa-users")).toBe true

  context "with ng-click", ->
    beforeEach ->
      template = """<th-dropdown name="Button" list="[{name:'action', ngClick: action}]"></th-dropdown>"""
      element = compileDirective(template, {action: -> alert 'response'}).element

    context "when button is clicked", ->
      beforeEach ->
        element.find('a').first().triggerHandler 'click'

      it "displays a menu with items", ->
        expect(element.find(".dropdown-menu")).not.toBe null
        expect(element.find(".dropdown-item").length).toEqual 1

      context "and when dropdown item is clicked", ->
        it "invokes the action", ->
          spyOn(window, 'alert')
          element.find('a.dropdown-item').triggerHandler 'click'
          expect(window.alert).toHaveBeenCalledWith 'response'

  context "action with an icon", ->
    beforeEach ->
      template = """<th-dropdown name="Button" list="[{name:'action', ngClick: action, icon: 'users'}]"></th-dropdown>"""
      element = compileDirective(template, {action: -> alert 'response'}).element
    context "when button is clicked", ->
      beforeEach ->
        element.find('a').first().triggerHandler 'click'
      it "anchor has i element with class 'fa fa-users'", ->
        expect(element.find("a.dropdown-item > i").hasClass("fa fa-users")).toBe true

  context "when divider is passed in", ->
    beforeEach ->
      element = compileDirective("""<th-dropdown name="Button" list="[{divider:true}]"></th-dropdown>""").element
      element.find('a').first().triggerHandler 'click'

    it "displays a menu with items", ->
      expect(element.find(".dropdown-menu")).not.toBe null
      expect(element.find("hr.th-divider").length).toEqual 1


