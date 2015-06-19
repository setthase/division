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


