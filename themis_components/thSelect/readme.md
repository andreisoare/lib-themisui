# Select — `thSelect`

## Description

A simple replacement for the standard select visuals. This component only replaces the `select` HTML element and allows for the native `option` to be used. This that W3 specs also apply for the Themis version. For example, only one `option` can selected at a time and the `select` value will always default to the last selected `option`.

The componenet can be used in two ways:

- The `th-select` can be used in the same manner as a native `select` if databinding / angular controllers are not being utilized. See example 1.

- It can also be used by passing an array of options as a attribute. Note that they cannot both be used as the directive defaults to using the 'options' array if it exists. See example 2.


