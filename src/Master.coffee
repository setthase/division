# Libraries
Worker         = require './Worker'
cluster        = require 'cluster'
{EventEmitter} = require 'events'

############################
#
# Master
# Wrapper around master process of cluster
#

module.exports = class Master extends EventEmitter

  ############################
  #
  # Constructor
  #
  constructor: ->

    # Helper providing definer of values (added to instance)
    `var __define`
    __define = (args...) => Object.defineProperty.apply null, [].concat this, args

    # Public constants
    __define "pid",     enumerable: yes, value: process.pid
    __define "startup", enumerable: yes, value: do Date.now

    # Private variables
    __define "workers",  writable: yes, value: []

    __define "state",    writable: yes, value: ''
    __define "pending",  writable: yes, value: 0

    __define "__killed", writable: yes, value: 0

  ############################
  #
  # Define public methods
  #

  # Helper providing definer of methods (added to prototype)
  __define = (args...) => Object.defineProperty.apply null, [].concat Master.prototype, args

  # Register signal
  __define "addSignalListener", enumerable: yes, value: (signal, callback) ->
    process.on signal, callback.bind this
    return this

  ## Runtime

  # Spawn new worker
  __define "increase", enumerable: yes, value: (n = 1) ->
    # Emit 'increase' event
    @emit.call this, "increase"

    # Increase size in settings
    @settings.size += n

    # Spawn missing workers
    do @spawn while n--

    return this

  # Close one of workers
  __define "decrease", enumerable: yes, value: (n = 1) ->
    # Emit 'decrease' event
    @emit.call this, "decrease"

    # Limit `n` to proper value
    n = 1 if n <= 0
    n = limit if n > (limit = @workers.length)

    # Decrease size in settings
    @settings.size -= n

    # Set index for workers
    index = limit - n

    # Close oversized workers
    while n--
      do @workers[index].close
      index++

    return this

  # Restart all workers
  __define "restart", enumerable: yes, value: ->
    # Emit 'restart' event
    @emit.call this, "restart"

    @workers.forEach (worker) ->
      do worker.close

    return this

  # Graceful shutdown cluster
  __define "close", enumerable: yes, value: ->
    # Emit 'close' event
    @emit.call this, "close"

    @state   = 'graceful'
    @pending = @workers.length

    @workers.forEach (worker) ->
      do worker.close

    return this

  # Forceful shutdown cluster
  __define "destroy", enumerable: yes, value: ->
    # Emit 'destroy' event
    @emit.call this, "destroy"

    @state = 'forceful'
    @kill 'SIGKILL'

    return this

  # Send `signal` to all workers, if no `signal` is specified `SIGTERM` is send
  __define "kill", enumerable: yes, value: (signal = "SIGTERM") ->
    @workers.forEach (worker) ->
      worker.kill signal

    return this

  # Maintain worker count, re-spawning if necessary
  __define "maintenance", enumerable: yes, value: ->
    @workers.forEach (worker) ->
      @killed worker if worker.status is "dead"

    return this

  ## Communication

  # Send message to worker with `id`
  __define "publish", enumerable: yes, value: (id, event, parameters...) ->
    @worker(id)?.publish event, parameters

    return this

  # Send message to all workers
  __define "broadcast", enumerable: yes, value: (event, parameters...) ->
    @workers.forEach (worker) ->
      worker.publish event, parameters

    return this

  ############################
  #
  # Define private methods
  #

  # Configure cluster master process
  __define "configure", enumerable: yes, value: (@settings) ->

    # TODO: Some options and functions here

    # Allow to add cluster events to Master instance
    do @registerEvents

    # Set cluster runtime environment
    cluster.setupMaster { exec : @settings.path, args : @settings.args, silent : @settings.silent }

  # Spawn another worker if workers count is below size in settings
  __define "spawn", value: ->
    @workers.push new Worker() if @workers.length < @settings.size
    return this

  # Register cluster events and map them to EventEmitter events
  __define "registerEvents", value: ->
    unless @registered

      cluster.on "fork", (worker) =>
        worker = @worker worker.id
        @emit.call this, "fork", worker


      cluster.on "online", (worker) =>
        worker = @worker worker.id
        @emit.call this, "online", worker


      cluster.on "listening", (worker, address) =>
        worker = @worker worker.id
        @emit.call this, "listening", worker, address


      cluster.on "disconnect", (worker) =>
        worker = @worker worker.id
        @emit.call this, "disconnect", worker


      cluster.on "exit", (worker, code, signal) =>
        worker = @worker worker.id
        @emit.call this, "exit", worker, code, signal

        @killed worker

    @registered = yes

    return this

  # Return worker with specified `id`
  __define "worker", value: (id) ->
    if id
      for worker in @workers
        return worker if worker?.id is id

    return null

  # Remove worker with `id` from `workers` list
  __define "cleanup", value: (id) ->
    if id
      for worker in @workers
        @workers.splice(_i, 1) if worker?.id is id

    return this

  __define "killed", value: (worker) ->
    # if we have many failing workers at boot
    # then we likely have a serious issue
    if Date.now() - @startup < 20000
      if ++@__killed is 20

        message = """

                    Detected over 20 worker deaths in the first 20 seconds of life,
                    there is most likely a serious issue with your server.

                    Aborting!

                  """

        if @settings.extensions.indexOf('debug') > -1
          @emit.call this, "error", "\n#{message}"

        else
          console.error message

        return process.exit 1

    @cleanup worker?.id

    # state specifics
    switch @state
      when 'graceful' then break
      when 'forceful' then --@pending or process.nextTick process.exit
      else do @spawn

    return this
