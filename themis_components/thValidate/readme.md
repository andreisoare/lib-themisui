# Alternative #1

Rely heavily on Angular's implicit form validation.

```html
<form name="myForm" th-validate-submit="controller.submitFunction()" novalidate>
  <div ng-class="{'has-error': myForm.firstName.$touched && myForm.firstName.$invalid}">
    <label>First Name</label>
    <input
      type="text"
      name="firstName"
      ng-model = "controller.person.firstName"

      required
      ng-minlength="2"
      ng-maxlength="10"
      ng-pattern="[a-z]+"

      custom-validator
      another-custom-validator
      >
    <th-validate-message
      input="myForm.firstName"
      message-required="You MUST fill this field!"
      message-minlength="You must type at least 2 characters here."
      message-custom-validator="Bla bla bla custom"
      message-another-custom-validator="Bla bla bla another custom"
      >
    </th-validate-message>
  </div>

  <button type="submit">Submit</button>
</form>
```

Creating custom validators is documented
[here](https://docs.angularjs.org/guide/forms) under "Custom Validation".

Note that some input types have additional builtin validators. For example:

* [input\[email\]](https://docs.angularjs.org/api/ng/input/input%5Bemail%5D)
  automatically sets `formName.inputName.$error.email`.
* [input\[number\]](https://docs.angularjs.org/api/ng/input/input%5Bnumber%5D)
  supports `min` and `max` as validators.



# Alternative #2

If we want to validations outside templates as well, we can build something more
generic.

```coffeescript
controller: (Validator) ->
  # Used in ng-model for inputs
  @person = {
    email: null
    name: {
      first: null
      last: null
    }
    age: null
  }

  @personValidations = Validator @person, {
    "name.first": {
      required: {
        value: true
        message: "YOU NEED TO WRITE A PERSON NAME"
      }
      length: {
        min: 5
        max: 20
        message: "Length must be between 5 and 20!"
      }
    }

    "name.last": {
      required: true
      length: {min: 5, max: 20}
    }

    age: {
      number: true
      customValidator: (value) -> true or "Custom message if invalid."
    }

    email: {
      pattern: new RegExp ".+\@.+\..+"
    }
  }

  # Use the following functions in the template or in your JS code:

  @personValidations.name.first.valid() # true or false
  @personValidations.name.first.message() # Error message in case it's invalid.

  @personValidations.age().valid()
  @personValidations.age().message()

  @personValidations.valid() # true is all fields are valid
```

```html
  <form name="myForm" th-validate-enabled="controller.personValidations.valid()" novalidate>
    <div ng-class="{'has-error': !controller.personValidations.name.first.valid()}">
      <label>First Name</label>
      <input type="text" name="firstName" ng-model = "controller.person.name.first">
      <th-validate-message field="controller.personValidations.name.first"></th-validate-message>
    </div>

    <button type="submit">Submit</button>
  </form>
```
