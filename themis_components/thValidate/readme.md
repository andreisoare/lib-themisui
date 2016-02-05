# Validations

## Description

After doing some research, we concluded that Angular's default form validation
functionality is the best solution.

The only problem is that it cannot be used outside forms, for example:

* Input fields outside forms.
* Validating data objects in our JavaScript code.

As long as the above aren't needed, `ngMessages` is the best solution to display
validation errors to the user.

There is a [great tutorial](https://scotch.io/tutorials/angularjs-form-validation-with-ngmessages)
from scotch.io that explains how to use `ngMessages`.

Creating custom validators is documented
[here](https://docs.angularjs.org/guide/forms) under "Custom Validation".

Note that some input types have additional builtin validators. For example:

* [input\[email\]](https://docs.angularjs.org/api/ng/input/input%5Bemail%5D)
  automatically sets `formName.inputName.$error.email`.
* [input\[number\]](https://docs.angularjs.org/api/ng/input/input%5Bnumber%5D)
  supports `min` and `max` as validators.

If there will ever be a need for validations outside forms, consider the
following proposal:



## Validator Service

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
