### Division class

[ [Attributes](#attributes) | [Methods](#methods) ]

#### Attributes

[ [version](#version) | [environment](#environment) | [settings](#settings) ]

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

[ [configure](#configure) | [set](#set) | [get](#get) | [use](#use) | [enable](#enable) | [disable](#disable) | [enabled](#enabled) | [disabled](#disabled) | [run](#run) ]

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
Use the given `extension`. If `extension` is string - this method try to `require` extension library; if function then this method invoke that function in **Master** instance scope.

**parameters:** `extension` *required String or Function*, `parameters...` *optional list of mixed values*<br>
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


