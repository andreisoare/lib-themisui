# Filter — `thFilter`

<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Description](#description)
- [Example](#example)
- [Filter object](#filter-object)
	- [Autocomplete filter](#autocomplete-filter)
	- [Select filter](#select-filter)
	- [String filter](#string-filter)
	- [Date filter](#date-filter)
	- [Number filter](#number-filter)
- [activeFilters](#activefilters)
- [onFilterChange(filters)](#onfilterchangefilters)
- [onSave(filters)](#onsavefilters)
- [Implementation details](#implementation-details)

<!-- /TOC -->

## Description

This is a set of components and services that you can use to implement table
filters in Clio.

It supports custom fields that have to be populated by making a network request
to the backend.

## Example

```html
<th-filter filters="controller.filters"
           activeFilters="controller.activeFilters"
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
        ModelClass: Contact
        labelField: "name"
        valueField: "id"
        queryParams: {
          type: "attorney"
        }
      }
      showOnInit: true
    }
    {
      fieldName: "practiceArea"
      label: "Practice Area"
      type: "select"
      data: [
        {label: "Administration", value: 0}
        {label: "Criminal", value: 1}
      ]
    }
    {
      fieldName: "email"
      label: "Email"
      type: "string"
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
    # ...
  ]

  @activeFilters = [
    {
      fieldName: "email"
      operator: "containsAnyOf"
      value: "john@acme.com john@acme.co.uk"
    }
    # ...
  ]

  @onFilterChange = (filters) =>
    # Called every time a filter is changed. This is an opportunity to reload
    # the table, assuming that the table's fetchData uses the @tableFilters
    # field set on the controller when making requests.
    @tableFilters = filters
    @tableDelegate.reload {currentPage: 1}

  @saveFilters: (filters) =>
    # This allows bookmarking a specific set of filters to be displayed in the
    # interface. The "filters" paramter provided by this function can be used
    # later to initialize the "activeFilters" attribute of thFilter.

  return
```

## Filter object

All field objects support the following properties:

* `fieldName` (string)
  * Useful to pass to th-table to know what field to request from the API.
* `label` (string)
  * Useful to show to the user what this filter field actually is.
* `type` (string)
  * One of: "autocomplete", "select", "string", "date", "number".
* `showOnInit` (boolean, default: false)
  * Indicates whether this field should be displayed to the user by default,
    without having to click the "Add" button and enable it from a list.

### Autocomplete filter

Uses our `thAutocomplete` component to query the server for options as you type.

It requires passing 3 more options through the `autocompleteOptions` property.
These 3 options must be supported by `thAutocomplete` as well.

* `ModelClass` (string)
* `labelField` (string)
* `valueField` (string)
* `queryParams` (optional)

They save the developer from having to manually implement `fetchData` for every
autocomplete filter. This would actually be impossible for custom fields that
must be retrieved from the backend: the backend cannot possibly send back
an implementation of `fetchData` for that specific field.

Behind the scenes, `thFilter` expects that `ModelClass` has a `.query(params)`
method that it can call like this:
`ModelClass.query({query: dataObject[valueField]})`.

If there is ever a need to send more than the `query` parameter for the API
request, you can add additional parameters through the `queryParams` option.

`thFilter` will make the request and parse the response internally. It uses
`labelField` to show a specific field for each object from the response array.

### Select filter

Requires an additional `data` field (array) which contains all the options that
the user can select.

The `data` array is actually an array of `{label, value}` objects: the label is
used in the UI for the user to select and the value is what gets sent in the
network request to the backend.

### String filter

This filter will support the following operators:
* is `X`
* containsAnyOf `X`
* containsAllOf `X`

### Date filter

* is `X`
* lessThan `X`
* greaterThan `X`
* between `X`, `Y`
* withinLastDays `X`

### Number filter

* is `X`
* lessThan `X`
* greaterThan `X`
* between `X`, `Y`



## activeFilters

This is an optional attribute that you can pass to the `thFilter` directive to
restore previously saved filters. The value that you must pass to it is the
array of filters that is provided in the `saveFilters()` method.



## onFilterChange(filters)

Called every time a filter is updated by the user.

Receives `filters` as an argument, which stores the filters that are currently
active and has the following format:

```coffeescript
[
  {
    fieldName: "email"
    operator: "containsAnyOf"
    value: "john@acme.com john@acme.co.uk"
  }
  {
    fieldName: "createdDate"
    operator: "between"
    value: [new Date("2015-01-01"), new Date("2015-12-31")]
  }
  # ...
]
```

For filters that have operators with 2 values, `X` and `Y`, the `value` field
will be an array with these values.

For `autocomplete` or `select` filter types the operator will be `is`, because
it must match the exact value selected.



## onSave(filters)

The filter component may display a "Save" button that bookmarks the currently
active filters for future usage. When the user presses this button, `onSave()`
gets called.

It receives the same argument that `onFilterChange()` receives, the array of
active filters.



## Implementation details

`thFilter` uses the [$injector](https://docs.angularjs.org/api/auto/service/$injector)
service to inject the `ModelClass` string.
