# ThemisUI

[![Usage Docs](http://dabuttonfactory.com/button.png?t=Usage+Docs&f=Calibri&ts=15&tc=fff&tshs=1&tshc=444&w=110&h=18&c=3&bgt=gradient&bgc=69adf1&ebgc=4891dc&bs=1&bc=236ab4)](http://themisui-docs.clio.com/)
[![Build Status](https://travis-ci.org/clio/lib-themisui.svg)](https://travis-ci.org/clio/lib-themisui)

ThemisUI is a shareable suite of components and brand assets to be shared across Themis projects. ThemisUI also contains a docs viewer to allow for simple consumption of components.


## Usage

We're running in stealth mode for now meaning we don't yet want to list on NPM. So to install run:

```bash
npm install git+ssh://git@github.com/clio/lib-themisui.git
```

You can specify [any other release](https://github.com/clio/lib-themisui/releases) as well.

Next you just need to include ThemisUI in your angular application like so:

```javascript
angular = require('angular');

angular.module 'YourApp', [
    require 'lib-ThemisUI'
];
```

You can now use any of our components in your application. The APIs for each component explain their usage.


## Running Docs

### Getting started.

Whilst inside the `lib-ThemisUI` directory.

1. Ensure you have npm installed.
2. Do a `npm install` to get dependencies.
3. Run `npm start` to start all the tasks we need and launch the server.
4. Visit http://localhost:3042
5. ???
6. Profit

### Tests

1. Ensure you have npm installed.
2. Do a `npm install` to get dependencies.
3. Run `npm test` to start karma.

### Installing `node` / `npm`

### Mac

1. Run `brew update` to ensure that the brew formulae are up to date.
2. Install node with `brew install node`.


## Contents

- `themis_components`
  - A library of reusable components.
- `themis_theme`
  - Our base brand / fonts / icons / colours.


## Deploying Docs viewer

1. Open a pull request from `master` against `edge` branch.
2. When your pull request is approved and merged it will automatically deploy and be visibile at http://themisui-docs.clio.com/.