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

