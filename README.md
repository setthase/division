division [![](https://travis-ci.org/codename-/division.png)](https://travis-ci.org/codename-/division) [![](https://badge.fury.io/js/division.png)](https://npmjs.org/package/division)
========

Simple and powerful wrapper over [node.js](http://nodejs.org/) [cluster](http://nodejs.org/api/cluster.html) API.<br>
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
 * works with node version >= 0.8
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

## API Reference

### Division class

#### Attributes

`Division` provide these public attributes

###### version
*Constant String*<br>
Contain current version number of **division** module.

###### environment
*Constant String*, default: `'development'`<br>
Contain name of current runtime environment (`NODE_ENV`).

**NOTE:** This could be set only when starting application. This cannot be changed when application is running.

###### settings
*Read-Only Object*, default: `{ extensions: [], size: Math.max(2, require('os').cpus().length) }`<br>
Contain current **division** configuration. List of currently available configuration keys:

  * **path** ( *String* ) — path to workers file
  * **args** ( *Array* ) — string arguments passed to workers
  * **size** ( *Number* ) — amount of workers processes to be run
  * **silent** ( *Boolean* ) — whether or not to send output to parent stdio
  * **timeout** ( *Number* ) — time in ms to kill worker process, which don't want to close itself after `close`

**NOTE:** Settings are read-only when directly called. They can be changed only by class methods or by constructor call.

**NOTE:** `path`, `args` and `silent` can be modified until `run` method is not called. After that, changes will not take effects.

#### Methods

`Division` provide these public methods.

###### configure
Conditionally perform the following `action` if **NODE_ENV** matches `environment` or if there is no `environment` set.

**parameters:** `environment` *optional String*, `action` *required Function*<br>
**return:** *division instance* (for chaining)

###### set
Set `setting` to `value`.

**parameters:** `setting` *required String*, `value` *required Mixed*<br>
**return:** *division instance* (for chaining)

###### get
Get `value` from `setting`.

**parameters:** `setting` *required String*<br>
**return:** value of `setting` field

###### use
Use the given `extension`. If `extension` is string method try to `require` extension library, if function then method invoke this function in **Master** instance scope.

**parameters:** `extension` *required String or Function*, `parameters...` *optional Mixed values*<br>
**return:** *division instance* (for chaining)

###### enable
Set `setting` to *true*.

**parameters:** `setting` *required String*<br>
**return:** *division instance* (for chaining)

###### disable
Set `setting` to *false*.

**parameters:** `setting` *required String*<br>
**return:** *division instance* (for chaining)

###### enabled
Check if `setting` is *truthy*.

**parameters:** `setting` *required String*<br>
**return:** *Boolean value*

###### disabled
Check if `setting` is *falsy*.

**parameters:** `setting` *required String*<br>
**return:** *Boolean value*

###### run
Run configured cluster process. `action` function is invoked in **Master** instance scope.

**NOTE:** This could be called only once in whole application life.

**parameters:** `action` *optional Function*<br>
**return:** *Master instance*

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
