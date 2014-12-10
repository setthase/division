# Require dependencies
{exec}         = require 'child_process'
cluster        = require 'cluster'
{EventEmitter} = require 'events'

############################
#
# Worker
# Wrapper around worker process of cluster
#
module.exports = class Worker extends EventEmitter

  ############################
  #
  # Constructor
  #
  constructor: ->

    # Helper providing definer of values (added to instance)
    __define = (args...) => Object.defineProperty.apply null, [].concat this, args

    # Private constants
    __define 'instance', value: do cluster.fork

    # Public constants
    __define 'id',  enumerable: yes, value: @instance.id
    __define 'pid', enumerable: yes, value: @instance.process.pid

    __define 'startup', enumerable: yes, value: do Date.now
    __define 'status',  enumerable: yes, get : ->
      return @instance.state

    # Private variables
    __define 'decreased', writable: yes, value: no

  ############################
  #
  # Define public methods
  #

  # Helper providing definer of methods (added to prototype)
  __define = (args...) -> Object.defineProperty.apply null, [].concat Worker.prototype, args

  # Gracefully close worker - if worker doesn't close within `timeout`, then it would be forcefully killed
  __define 'close', enumerable: yes, value: (timeout = 2000, decrease) ->
    # Emit 'close' event
    @emit.call this, 'close'

    # Set decreased flag
    @decreased = yes if decrease

    # Disconnect worker
    try do @instance.disconnect unless @status is 'disconnected' or @status is 'dead'

    # Set timeout for forcefully close worker
    setTimeout =>
      unless @status is 'dead'
        # Use POSIX command `kill(1)` to definitely kill process
        exec "kill -s kill #{@pid}", ->

    , timeout

    return this

  # Send `signal` to worker - if `signal` is not specified then send `SIGTERM`
  __define 'kill', enumerable: yes, value: (signal = 'SIGTERM') ->
    # Emit 'kill' event
    @emit.call this, 'kill', signal

    # Send signal to worker in next tick
    process.nextTick =>
      try @instance.kill signal

    return this

  # Send message to worker instance
  __define 'publish', enumerable: yes, value: (event, parameters...) ->
    # Parse parameters array
    if parameters.length is 1 then parameters = parameters[0]

    # Emit 'publish' event
    @emit.call this, 'publish', event, parameters

    # Send message to worker
    try @instance.send { event, parameters }

    return this
