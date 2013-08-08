division [![](https://travis-ci.org/codename-/division.png)](https://travis-ci.org/codename-/division)
========

Simple and powerful wrapper over [node.js](http://nodejs.org/) [cluster](http://nodejs.org/api/cluster.html) API.  
This module is inspired by impressive but abandoned project [Cluster](https://github.com/LearnBoost/cluster) created by [@visionmedia](https://github.com/visionmedia).

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
 *  standalone (without 3rd-party dependencies)
 *  zero-downtime restart
 *  maintains worker count
 *  forceful shutdown support
 *  graceful shutdown support
 *  bundled extensions
    *  debug: enable verbose debugging informations
    *  signals: add ability to control cluster with POSIX signals

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
var cluster = new division();

// You can chain methods
cluster.set('path', 'app.js').run();
```

## API Reference

### Division class

#### Attributes

###### version

###### environment

###### settings

#### Methods

###### configure

###### set

###### get

###### use

###### enable

###### disable

###### enabled

###### disabled

###### run

### Master class

` Master ` is returned when you call ` run ` method from ` Division ` and it is also set as a scope for callback function of this method.

#### Attributes

` Master ` provide these public attributes

###### pid

###### startup

#### Methods

` Master ` provide these public methods

###### addSignalListener

###### increase

###### decrease

###### restart

###### close

###### destroy

###### kill

###### maintenance

###### publish

###### broadcast

#### Events

` Master ` inherit his prototype from `EventEmitter` and emit these events

###### error

###### increase

###### decrease

###### restart

###### close

###### destroy

###### fork

###### online

###### listening

###### disconnect

###### exit

### Worker class

` Worker ` is returned in some of ` Master ` events

#### Attributes

` Worker ` provide these public attributes

###### id

###### pid

###### startup

###### status

#### Methods

` Worker ` provide these public methods

###### close

###### kill

###### publish

#### Events

` Worker ` inherit his prototype from `EventEmitter` and emit these events

###### close

###### kill

###### publish
