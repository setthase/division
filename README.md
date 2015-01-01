![division](https://github.com/codename-/division/raw/master/content/logo.png)
========

[![](https://img.shields.io/travis/codename-/division.svg?style=flat-square)](https://travis-ci.org/codename-/division) [![](https://img.shields.io/coveralls/codename-/division.svg?style=flat-square)](https://coveralls.io/r/codename-/division) ![](https://img.shields.io/node/v/division.svg?style=flat-square) [ ![](https://img.shields.io/npm/v/division.svg?style=flat-square)](https://npmjs.org/package/division) ![](https://img.shields.io/badge/license-MIT-green.svg?style=flat-square) ![](https://img.shields.io/npm/dm/division.svg?style=flat-square)

Simple yet powerful wrapper over [node.js](http://nodejs.org/) [cluster](http://nodejs.org/api/cluster.html) API.<br>
This module is inspired by impressive, but abandoned project [Cluster](https://github.com/LearnBoost/cluster) created by [TJ Holowaychuk](https://github.com/tj).

## Installation

```bash
$ npm install division
```
#### Running Tests

First go to module directory and install development dependencies:

```bash
$ npm install
```

Then you can test module typing:

```bash
$ npm test
```

## Features

The most valuable feature: you don't need to change your code to working within cluster.

Other features:

  * works with node version ≥ 0.10
  * standalone (without 3rd-party dependencies)
  * zero-downtime restart
  * maintains worker count
  * forceful shutdown support
  * graceful shutdown support
  * bundled extensions
    * debug: enable verbose debugging informations
    * watch: reload cluster when files was changed
    * signals: add ability to control cluster with POSIX signals

## Example

More examples you can find in `examples` directory.

### Standard configuration example

```javascript
var division = require('division');
var cluster = new division();

// Configuration for development environment
cluster.configure('development', function () {
  // Put your development configuration here
  cluster.set('args', ['--some-process-args', 'send-to-workers']);
});

// Configuration for production environment
cluster.configure('production', function () {
  // Put your production configuration here
  cluster.enable('silent');
});

// Configuration for all environments
// TIP: this is pointing to cluster
cluster.configure(function () {
  this.set('path', 'app.js');
});

// You can also set settings without configuration block
cluster.set('size', 2);

// Use extensions
// TIP: You can chain (almost) all methods
cluster.use('debug').use('signals');

// Start your application as a cluster!
cluster.run(function () {
  // `this` is pointing to the Master instance
});
```

You can set environment while launching application - in this way:

```bash
$ NODE_ENV=production node cluster.js
```

### Minimal configuration example

```javascript
var division = require('division');
// You can pass settings in constructor
var cluster = new division({ path : 'app.js' });

cluster.run();
```

### API Reference

For API reference take a look at [API.md](https://github.com/codename-/division/blob/master/API.md) file.

