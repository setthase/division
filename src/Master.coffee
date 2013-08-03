Worker         = require './Worker'
cluster        = require 'cluster'
{EventEmitter} = require 'events'

############################
#
# Master
# Wrapper around master process of cluster
#

module.exports = class Master extends EventEmitter
  constructor: ->
    @pid = process.pid

    @startup = new Date
    @workers = []

  ############################

  ## Helper for adding properties to prototype
  __define = (args...) => Object.defineProperty.apply null, [].concat Master.prototype, args

  ############################
  #
  # Define public methods
  #

  # Register signal
  __define "addSignalListener", enumerable: yes, value: (signal, callback) ->
    process.on signal, callback.call this

  ## Runtime

  # Spawn new worker
  __define "increase", enumerable: yes, value: (n = 1) ->
    @workers.push new Worker while n--
    return this

  # Close one of workers
  __define "decrease", enumerable: yes, value: (n = 1, signal = "SIGQUIT") ->

    # Limit `n` to proper value
    n = 1 if n <= 0
    n = limit if n > (limit = @workers.length)

    @workers.pop().kill signal while n--

    return this

  # Restart all workers
  __define "restart", enumerable: yes, value: ->

    return this

  # Graceful shutdown cluster
  __define "close", enumerable: yes, value: ->
    @state = 'graceful shutdown'
    @kill 'SIGQUIT'
    @pendingDeaths = @workers.length

    return this

  # Hard shutdown cluster
  __define "destroy", enumerable: yes, value: ->
    @state = 'hard shutdown'
    @kill 'SIGKILL'
    do @_destroy

    return this

  # Kill worker
  __define "kill", enumerable: yes, value: (signal = "SIGTERM") ->
    @workers.forEach (worker) ->
      worker.kill signal

    return this

  ## Communication

  # Send message to worker with `id`
  __define "publish", enumerable: yes, value: (id, event, arguments...) ->
    @findWorker(id)?.publish event, arguments

    return this

  # Send message to all workers
  __define "broadcast", enumerable: yes, value: (event, arguments...) ->
    @workers.forEach (worker) ->
      worker.publish event, arguments

    return this

  ############################
  #
  # Define private methods
  #

  # Configure cluster master process
  __define "configure", enumerable: yes, value: (settings) ->

    # TODO: Some options and functions here

    # Allow to add cluster events to Master instance
    do @mapEvents

    # Set cluster runtime environment
    cluster.setupMaster { exec : settings.path, args : settings.args, silent : settings.silent }

  # Map cluster events to Master events
  __define "mapEvents", value: ->

    cluster.on "fork", (worker) =>
      @emit "fork", @findWorker worker.id

    cluster.on "online", (worker) =>
      @emit "online", @findWorker worker.id

    cluster.on "listening", (worker) =>
      @emit "listening", @findWorker worker.id

    cluster.on "disconnect", (worker) =>
      @emit "disconnect", @findWorker worker.id

    cluster.on "exit", (worker) =>
      @emit "exit", @findWorker worker.id

  # Return worker with specified `id`
  __define "findWorker", value: (id) ->
    for worker in @workers
      return worker if worker.id is id

    return null

  ############################
  #
  # Define private events
  #

  # @.on "", ->
