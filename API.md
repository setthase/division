## API Reference

[ [division](#division-class) | [Master](#master-class) | [Worker](#worker-class) ]

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

### Master class

` Master ` is returned when you call ` run ` method from ` Division ` and it is also set as a scope for callback function of this method.

[ [Attributes](#attributes-1) | [Methods](#methods-1) | [Events](#events) ]

#### Attributes

[ [pid](#pid) | [startup](#startup) ]

###### pid
*Constant String*<br>
Contain current master process ID (PID number)

###### startup
*Constant Number*<br>
Contain timestamp number indicating start of cluster process.

#### Methods

[ [addSignalListener](#addsignallistener) | [increase](#increase) | [decrease](#decrease) | [restart](#restart) | [close](#close) | [destroy](#destroy) | [kill](#kill) | [maintenance](#maintenance) | [publish](#publish) | [broadcast](#broadcast) ]

###### addSignalListener
Listen for **process** `event` or POSIX `signal` and firing `callback` in **Master** scope.

**parameters:** `event_or_signal` *required String*, `callback` *required Function*<br>
**return:** *Master instance* (for chaining)

###### increase
Increase number of active workers by `amount`; by default `amount` is equal `1`.

**parameters:** `amount` *optional Number*<br>
**return:** *Master instance* (for chaining)

###### decrease
Decrease number of active workers by `amount`; by default `amount` is equal `1`.

**parameters:** `amount` *optional Number*<br>
**return:** *Master instance* (for chaining)

###### restart
Gracefully restarts all workers.

**return:** *Master instance* (for chaining)

###### close
Gracefully close all workers.

**return:** *Master instance* (for chaining)

###### destroy
Forcefully destroy all workers.

**return:** *Master instance* (for chaining)

###### kill
Send POSIX `signal` to all workers; by default `signal` is equal `SIGTERM`.

**parameters:** `signal` *optional String*<br>
**return:** *Master instance* (for chaining)

###### maintenance
Maintain active workers amount, re-spawning or closing if necessary.

**return:** *Master instance* (for chaining)

###### publish
Send `event` message to **Worker** process with specified `id`.

**parameters:** `id` *required Number*, `event` *required String*, `parameters...` *optional list of mixed values*<br>
**return:** *Master instance* (for chaining)

###### broadcast
Send `event` message to all **Worker** processes.

**parameters:** `event` *required String*, `parameters...` *optional list of mixed values*<br>
**return:** *Master instance* (for chaining)

#### Events

**Master** inherit from `Event Emitter` and all events (listed below) are called with the **Master** scope.

[ [error](#error) | [increase](#increase-1) | [decrease](#decrease-1) | [restart](#restart-1) | [close](#close-1) | [destroy](#destroy-1) | [fork](#fork) | [online](#online) | [listening](#listening) | [disconnect](#disconnect) | [exit](#exit) ]

###### error
Event emitted when some error occurred.

**Callback parameters:** `error` *String* containing error stack trace.

###### increase
Event emitted when number of workers is going to be increased.

**Callback parameters:** `amount` *Number* of workers that need to be added to current group.

###### decrease
Event emitted when number of workers is going to be decreased.

**Callback parameters:** `amount` *Number* of workers that need to be removed from current group.

###### restart
Event emitted when worker processes are going to be restarted.

###### close
Event emitted when cluster process is going to be gracefully closed.

###### destroy
Event emitted when cluster process is going to be forcefully destroyed.

###### fork
Event emitted when new cluster worker process was forked.

**Callback parameters:** `worker` *Worker* instance for newly created worker.

###### online
Event emitted when new cluster worker process is ready to do his job.

**Callback parameters:** `worker` *Worker* instance for newly created worker.

###### listening
Event emitted when worker start listening for incoming connections.

**Callback parameters:** `worker` *Worker* instance for this worker, `address` *Object* describing address on which worker is listening.

###### disconnect
Event emitted when worker process stop listen for incoming connections.

**Callback parameters:** `worker` *Worker* instance for disconnected worker.

###### exit
Event emitted when worker process has quit.

**Callback parameters:** `worker` *Worker* instance for closed worker, `code` *Number* with exit status code, `signal` *String* with POSIX signal (eg. `SIGKILL`) which caused that process exited.

### Worker class

`Worker` is returned in few events emitted from **Master** instance.

[ [Attributes](#attributes-2) | [Methods](#methods-2) | [Events](#events-1) ]

#### Attributes

[ [id](#id) | [pid](#pid-1) | [startup](#startup-1) | [status](#status) ]

###### id
*Constant Number*<br>
Contain current cluster worker ID number.

###### pid
*Constant String*<br>
Contain current worker process ID (PID) number.

###### startup
*Constant Number*<br>
Contain timestamp number indicating start of **Worker** process.

###### status
*Read-Only String*<br>
Contain current **Worker** status. Available statuses:

  * **none** - when worker process is creating
  * **online** - when worker process is successfully forked
  * **listening** - when worker process is listening for connections
  * **disconnected** - when worker process is disconnected (properly closed)
  * **dead** - when worker process died (killed by error or signal)

#### Methods

[ [close](#close-2) | [kill](#kill-1) | [publish](#publish-1) ]

###### close
Gracefully close worker. But if worker doesn't close within `timeout` (in ms), then it would be forcefully killed;<br>
by default `timeout` is equal `2000`.

**parameters:** `timeout` *optional Number*, `decrease` *optional Boolean*<br>
**return:** *Worker instance* (for chaining)

###### kill
Send POSIX `signal` to that worker; by default `signal` is equal `SIGTERM`.

**parameters:** `signal` *optional String*<br>
**return:** *Worker instance* (for chaining)

###### publish
Send message object (with two fields: `event` and `parameters`) to worker process.<br>
To receive messages you must have specified `message` listener in your application:

```javascript
process.on("message", function (msg) {
  var event = msg.event, parameters = msg.parameters;

  // do something with your message
});
```

**parameters:** `event` *required String*, `parameters...` *optional list of mixed values*<br>
**return:** *Worker instance* (for chaining)

#### Events

**Worker** inherit from `Event Emitter` and all events (listed below) are called with the **Worker** scope.

[ [close](#close-3) | [kill](#kill-2) | [publish](#publish-2) ]

###### close
Event emitted when worker process is going to be gracefully closed.

###### kill
Event emitted when worker process is going to receive POSIX signal.

**Callback parameters:** `signal` *String* with the name of signal.

###### publish
Event emitted when worker process is going to receive message object.

**Callback parameters:** `event` *String* with the event name, `parameters` *Array* of mixed values.
