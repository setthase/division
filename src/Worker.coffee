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
    `var __define`
    __define = (args...) => Object.defineProperty.apply null, [].concat this, args

    # Private constants
    __define "instance", value: do cluster.fork

    # Public constants
    __define "id",  enumerable: yes, value: @instance.id
    __define "pid", enumerable: yes, value: @instance.process.pid

    __define "startup", enumerable: yes, value: do Date.now
    __define "status",  enumerable: yes, set: (->), get : ->
      return @instance.state

  ############################
  #
  # Define public methods
  #

  # Helper providing definer of methods (added to prototype)
  __define = (args...) => Object.defineProperty.apply null, [].concat Worker.prototype, args

  # Gracefully close worker - if worker doesn't close within `timeout`, then it would be forcefully killed
  __define "close", enumerable: yes, value: (timeout = 2000) ->
    do @instance.disconnect
    setTimeout =>
      @kill "SIGKILL" if @status is not "dead"
    , timeout

    return this

  # Send `signal` to worker - if `signal` is not specified then send `SIGTERM`
  __define "kill", enumerable: yes, value: (signal = "SIGTERM") ->
    process.nextTick =>
      @instance.kill signal

    return this

  # Send message to worker instance
  __define "publish", enumerable: yes, value: (event, parameters...) ->
    if parameters.length is 1 then parameters = parameters[0]

    @instance.send { event, parameters }

    return this
