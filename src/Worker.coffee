cluster        = require 'cluster'
{EventEmitter} = require 'events'

############################
#
# Worker
# Wrapper around worker process of cluster
#
module.exports = class Worker extends EventEmitter
  constructor: () ->
    @instance = do cluster.fork

    @id  = @instance.id
    @pid = @instance.process.pid

    @status  = "configuring"
    @startup = new Date

    # Watch worker status change
    do @watchStatus

  ############################

  ## Helper for adding properties to prototype
  __define = (args...) => Object.defineProperty.apply null, [].concat Worker.prototype, args

  ############################
  #
  # Define public methods
  #

  ## Management of Worker process methods

  # Disconnect

  # Destroy

  ## Communication methods

  # Send message to worker instance
  __define "publish", enumerable: yes, value: (event, parameters...) ->


  ############################
  #
  # Define private methods
  #

  ## Configure helpers

  # Listen for worker events and change status to proper one
  __define "watchStatus", value: ->

    @instance.on "online", =>
      @status = "created"

    @instance.on "listening", =>
      @status = "listening"

    @instance.on "disconnect", =>
      @status = "disconnected"
