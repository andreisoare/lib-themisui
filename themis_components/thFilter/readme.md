# Filter — `thFilter`

<!-- TOC depthFrom:2 depthTo:3 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Description](#description)
- [Example](#example)
- [FilterDelegate](#filterdelegate)
- [FilterObject](#filterobject)
	- [Autocomplete filter](#autocomplete-filter)
	- [Select filter](#select-filter)
	- [String filter](#string-filter)
	- [Date filter](#date-filter)
	- [Number filter](#number-filter)

<!-- /TOC -->



## Description

This is a set of components and services that you can use to implement table
filters in Clio.

It supports custom fields that have to be populated by making a network request
to the backend.



## Example

```html
<th-filter delegate="controller.filterDelegate"></th-filter>
```

```coffeescript
controller: (FilterDelegate, FilterObject) ->
  @filterDelegate = FilterDelegate {
    onFilterChange: (filters) =>
      # Called every time a filter is changed. This is an opportunity to reload
      # the table, assuming that the table's fetchData uses the @tableFilters
      # field set on the controller when making requests.
      @tableFilters = filters
      @tableDelegate.reload {currentPage: 1}

    onSaveFilters: (filters) =>
      # This allows bookmarking a specific set of filters to be displayed in the
      # interface. The "filters" parameter provided by this function can be used
      # later to restore filters by calling the loadFilters() method on the
      # delegate object.
  }

  # In reality the array provided to initializeFilters would actually be
  # retrieved with an AJAX call, in order to support custom fields.
  # I'm hardcoding it here to present all the possible types of fields and how
  # they should be configured.
  @filterDelegate.initializeFilters [
    FilterObject {
      fieldIdentifier: "attorney"
      label: "Attorney"
      type: "autocomplete"
      autocompleteOptions: {
        ModelClass: Contact
        labelField: "name"
        valueField: "id"
        queryParams: {
          type: "attorney"
        }
      }
      showOnInit: true
    }
    FilterObject {
      fieldIdentifier: "practiceArea"
      label: "Practice Area"
      type: "select"
      data: [
        {label: "Administration", value: 0}
        {label: "Criminal", value: 1}
      ]
    }
    FilterObject {
      fieldIdentifier: "email"
      label: "Email"
      type: "string"
    }
    FilterObject {
      fieldIdentifier: "coverageDate"
      label: "Coverage Date"
      type: "date"
    }
    FilterObject {
      fieldIdentifier: "costs"
      label: "Total costs"
      type: "number"
    }
    # ...
  ]

  return
```



## FilterDelegate

This service instantiates filter delegates to pass to the `thFilter` component.

```coffeescript
delegate = FilterDelegate(options)
```

It accepts a dictionary of options:

* `onFilterChange(filters)`
  * Called every time a filter is updated by the user.
  * Receives `filters` as an argument, which is an array with the filters that
    are currently active.

* `onSaveFilters(filters)`
  * The filter component may display a "Save" button that bookmarks the
    currently active filters for future usage. When the user presses this
    button, `onSaveFilters()` gets called.
  * It receives the same argument that `onFilterChange()` receives, the array of
    active filters.

The delegate instance exposes the following methods:

* `initializeFilters(filters)`
  * Called to set all the filter options that the component can display.
  * The `filters` argument is an array of new instances of FilterObject.

* `loadFilters(filters)`
  * Used to load an array of filters with values that have been saved by
    `onSaveFilters()`.



## FilterObject

All filter objects are initialized with the following properties:

* `fieldIdentifier` (string)
  * Useful to pass to th-table to know what field to request from the API.
* `label` (string)
  * Useful to show to the user what this filter field actually is.
* `type` (string)
  * One of: "autocomplete", "select", "string", "date", "number".
* `showOnInit` (boolean, default: false)
  * Indicates whether this field should be displayed to the user by default,
    without having to click the "Add" button and enable it from a list.

They expose the following public methods and properties:

* `fieldIdentifier` (string)

* `type` (string)

* `getOperator()` (string)
  * Returns the operator that the user selected for this filter. See below what
    operators each filter type supports.

* `getValue()` (string|array)
  * Returns the string value that the user selected or typed for this filter.
    For operators that work with multiple values (like: `between`), the return
    value is an array with all the string values.

* `serialize()` (string)
  * Converts the filter to a string that can be saved on the backend.

* `deserialize(serializedFilter)`
  * Restores the filter from a serialized string.

### Autocomplete filter

Uses our `thAutocomplete` component to query the server for options as you type.

It requires an additional property to initialize called `autocompleteOptions`,
which is a dictionary of options:

* `ModelClass` (string)
  * A service that represents the Model class of objects to display in the
    autocomplete.

* `labelField` (string)
  * The field that will be displayed in the autocomplete options for each object
    retrieved.

* `valueField` (string)
  * The field that will be used as the filter value for the object that is
    selected.

* `queryParams` (object, optional)
  * Optional query params to send to the backend when making a query.

These options the developer from having to manually implement `fetchData` for
every autocomplete filter. This would actually be impossible for custom fields
that must be retrieved from the backend: the backend cannot possibly send back
an implementation of `fetchData` for that specific field.

Behind the scenes, `thFilter` uses the
[$injector](https://docs.angularjs.org/api/auto/service/$injector) to inject the
model service represented by `ModelClass`. It expects that this service has a
`.query(params)` method that it can call like this:

```coffeescript
ModelClass.query(Object.assign(queryParams, {query: searchString}))
```

`thFilter` will make the request and parse the response internally. It uses
`labelField` to show a specific field for each object from the response array.

The only operator that this filter object uses is `is`, because it represents
an exact match.

#### Pro-tip

Usually these filters and their options will be served by the backend. We don't
want to couple the backend with the frontend and force it to know how the client
names its Model classes.

To avoid this issue, you can do some post-processing to the filter objects after
they are fetched from the backend. For example, the backend would only send:

```coffeescript
{
  fieldIdentifier: "attorney"
  label: "Attorney"
  type: "mattersAutocomplete"
  showOnInit: true
}
```

And the client would recognize `mattersAutocomplete` and translate the options
into:

```coffeescript
{
  fieldIdentifier: "attorney"
  label: "Attorney"
  type: "autocomplete"
  autocompleteOptions: {
    ModelClass: Contact
    labelField: "name"
    valueField: "id"
    queryParams: {
      type: "attorney"
    }
  }
  showOnInit: true
}
```

### Select filter

Requires an additional `data` field (array) which contains all the options that
the user can select.

The `data` array is actually an array of `{label, value}` objects: the label is
used in the UI for the user to select and the value is what gets sent in the
network request to the backend.

For example:

```coffeescript
FilterObject {
  fieldIdentifier: "practiceArea"
  label: "Practice Area"
  type: "select"
  data: [
    {label: "Administration", value: 0}
    {label: "Criminal", value: 1}
  ]
}
```

The only operator that this filter object uses is `is`, because it represents
an exact match.

### String filter

This filter will support the following operators:

* is `X`
* containsAnyOf `X`
* containsAllOf `X`

### Date filter

This filter will support the following operators:

* is `X`
* lessThan `X`
* greaterThan `X`
* between `X`, `Y`
* withinLastDays `X`

### Number filter

This filter will support the following operators:

* is `X`
* lessThan `X`
* greaterThan `X`
* between `X`, `Y`
