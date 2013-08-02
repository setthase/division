cluster      = require 'cluster'
EventEmitter = require('events').EventEmitter

# Wrapper around master process of cluster
class Master extends EventEmitter
  constructor: (exec, args, silent) ->
    @pid = process.pid
    @env = process.env.NODE_ENV || 'development'

    @startup = new Date

    # Prepare cluster master
    cluster.setupMaster { exec, args, silent }

  ######
  # Helper for adding properties to prototype
  __define = (args...) => Object.defineProperty.apply null, [Master.prototype].concat args

  ######
  # Define public API

  ######
  # Define private methods

