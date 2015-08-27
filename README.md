# ThemisUI

[![Build Status](https://travis-ci.org/clio/lib-themisui.svg)](https://travis-ci.org/clio/lib-themisui)

ThemisUI is a shareable suite of components and brand assets to be shared across Themis projects. ThemisUI also contains a docs viewer to allow for simple consumption of components.

[Docs Viewer](http://themisui-docs.clio.com/)

## Getting started.

Whilst inside the `lib-ThemisUI` directory.

1. Ensure you have npm installed.
2. Do a `npm install` to get dependencies.
3. Run `npm start` to start all the tasks we need and launch the server.
4. Visit http://localhost:3042
5. ???
6. Profit

## Tests

1. Ensure you have npm installed.
2. Do a `npm install` to get dependencies.
3. Run `npm test` to start karma.

## Contents

- `themis_components`
  - A library of reusable components.
- `themis_theme`
  - Our base brand / fonts / icons / colours.

## Installing `node` / `npm`

### Mac

1. Run `brew update` to ensure that the brew formulae are up to date.
2. Install node with `brew install node`.

## Deploying Docs viewer

1. Open a pull request from `master` against `edge` branch.
2. When your pull request is approved and merged it will automatically deploy and be visibile at http://themisui-docs.clio.com/.
