# Filter — `thFilter`

## Description

This is a set of components and services that you can use to implement table
filters in Clio.

It supports custom fields that have to be populated by making a network request
to the backend.

## Example

```html
<th-filter filters="controller.filters"
           onFilterChange="controller.onFilterChange"
           saveFilters="controller.saveFilters">
</th-filter>
```

```coffeescript
controller: ->
  # In reality @filters would actually be retrieved with an AJAX call, in order
  # to support custom fields.
  #
  # I'm harcoding it here to get a sense of all the possible types of fields and
  # how they should be configured.
  @filters = [
    {
      fieldName: "attorney"
      label: "Attorney"
      type: "autocomplete"
      autocompleteOptions: {
        modelClass: Contact
        labelField: "name"
        queryParams: {
          type: "attorney"
        }
      }
      showOnInit: true
    }
    {
      fieldName: "practiceArea"
      label: "Practice Area"
      type: "select" # Pre-populated list of options.
      data: [
        "Administration"
        "Criminal"
      ]
    }
    {
      fieldName: "email"
      label: "Email"
      type: "search" # Free text input.
    }
    {
      fieldName: "coverageDate"
      label: "Coverage Date"
      type: "date"
    }
    {
      fieldName: "costs"
      label: "Total costs"
      type: "number"
    }
  ]

  @onFilterChange = (filters) =>
    # Called every time a filter is changed. This is an opportunity to reload
    # the table, assuming that the table's fetchData uses the @tableFilters
    # field set on the controller when making requests.
    @tableFilters = filters
    @tableDelegate.reload {currentPage: 1}

  @saveFilters: (filters) =>
    # TODO
    # This is a future feature that allows bookmarking a specific set of
    # filters to be displayed in the interface.

  return
```

## Filter object

All field objects support the following properties:

* `fieldName` (string)
  * Useful to pass to th-table to know what field to request from the API.
* `label` (string)
  * Useful to show to the user what this filter field actually is.
* `type` (string)
  * One of: "autocomplete", "select", "search", "date", "number".
* `showOnInit` (boolean, default: false)
  * Indicates whether this field should be displayed to the user by default,
    without having to click the "Add" button and enable it from a list.

### Autocomplete Filter

Uses our th-autocomplete component to query the server for options as you type.

It requires adding 2 more options to th-autocomplete in order to work:
* ModelClass
* labelField

This saves the developer from having to manually implement `fetchData` for every
autocomplete filter. This would actually be impossible for custom fields that
must be retrieved from the backend: the backend cannot possibly send back
an implementation of `fetchData` for that specific field.

Behind the scenes, `thFilter` expects that `ModelClass` has a `.query(params)`
method that it can call with `{query: searchString}` as a parameter. If so,
it will make the request and parse the response internally.

It uses `labelField` to show a specific field for each object from the response
array.

### Select Filter

Requires an additional `data` field (array) which contains all the options that
the user can select.



## onFilterChange(filters)

Called every time a filter is updated by the user.

Receives `filters` as an argument, which stores the filters that are currently
active and has the following format:

```coffeescript
[
  {
    fieldName: "..." # String
    value: "..." # String
  }
  # ...
]
```



## onSave(filters)

In the future the filter component may have a "Save" button that bookmarks the
currently active filters for future usage.

It receives the same argument that `onFilterChange()` receives, the array of
active filters.
