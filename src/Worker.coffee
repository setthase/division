cluster      = require 'cluster'
EventEmitter = require('events').EventEmitter

# Wrapper around worker process of cluster
class Worker extends EventEmitter
  constructor: (@original) ->
    @id  = original.id
    @pid = original.pid
    @env = process.env.NODE_ENV || 'development'

    @startup = new Date

  ######
  # Helper for adding properties to prototype
  __define = (args...) => Object.defineProperty.apply null, [Worker.prototype].concat args

  ######
  # Define public API

  ######
  # Define private methods

