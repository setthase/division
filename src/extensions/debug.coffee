# Libraries
logger = require './helpers/logger'

############################
#
# ~ division debug ~
#
# Extension enable verbose debugging output
#

module.exports =  (options) ->

  # Default settings
  options = options or { console : on }

  # Log master events
  @on "error", (error) ->
    logger.error error, options

  @on "increase", ->
    logger.info "Number of workers increased", options

  @on "decrease", ->
    logger.info "Number of workers decreased", options

  @on "restart", ->
    logger.info "Worker processes restarted", options

  @on "close", ->
    logger.info "Gracefully closing cluster process", options

  @on "destroy", ->
    logger.warn "Forcefully closing (killing) cluster process", options

  # Log cluster events
  @on "fork", (worker) ->
    logger.debug "New worker forked", options

  @on "online", (worker) ->
    logger.debug "Worker ##{worker.id} (PID: #{worker.pid}) is online", options

  @on "listening", (worker, address) ->
    logger.debug "Worker ##{worker.id} (PID: #{worker.pid}) is listening", options

  @on "disconnect", (worker) ->
    logger.debug "Worker ##{worker.id} (PID: #{worker.pid}) is disconnected", options

  @on "exit", (worker, code, signal) ->
    if worker.instance.suicide
      logger.debug "Worker ##{worker.id} (PID: #{worker.pid}) is exited", options
    else
      logger.error "Worker ##{worker.id} (PID: #{worker.pid}) is exited unexpectedly (code: #{code}, signal: #{signal})", options

  # Log process events
  process.on "uncaughtException", (error) ->
    logger.error error, options
    process.exit 1

  process.on "exit", ->
    logger.debug "Cluster process exited", options

  return this
