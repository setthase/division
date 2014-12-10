############################
#
# ~ division debug ~
#
# Extension enable verbose debugging informations
#

module.exports =  (options, logger) ->

  # Require dependencies
  logger ?= require './helpers/logger'

  # Default settings
  options = options or { console : on }

  # Log master events
  @on 'error', (error) ->
    logger.error error, options

  @on 'increase', (amount) ->
    logger.info "Number of workers increased by #{amount}", options

  @on 'decrease', (amount) ->
    logger.info "Number of workers decreased by #{amount}", options

  @on 'restart', ->
    logger.info 'Worker processes restarted', options

  @on 'close', ->
    logger.info 'Gracefully closing cluster process', options

  @on 'destroy', ->
    logger.warn 'Forcefully closing (killing) cluster process', options

  # Log cluster events
  @on 'fork', (worker) ->
    logger.debug 'New worker forked', options

  @on 'online', (worker) ->
    logger.debug "Worker no. #{worker?.id or "?"} (PID: #{worker?.pid or "unknown"}) is online", options

  @on 'listening', (worker, address) ->
    logger.debug "Worker no. #{worker?.id or "?"} (PID: #{worker?.pid or "unknown"}) is listening", options

  @on 'disconnect', (worker) ->
    logger.debug "Worker no. #{worker?.id or "?"} (PID: #{worker?.pid or "unknown"}) is disconnected", options

  @on 'exit', (worker, code, signal) ->
    if worker?.instance?.suicide
      logger.debug "Worker no. #{worker?.id or "?"} (PID: #{worker?.pid or "unknown"}) is exited", options
    else
      logger.error "Worker no. #{worker?.id or "?"} (PID: #{worker?.pid or "unknown"}) is exited unexpectedly (code: #{code}, signal: #{signal})", options

  # Log process events
  process.on 'uncaughtException', (error) ->
    logger.error error.stack, options
    process.exit 1

  process.on 'exit', ->
    logger.debug 'Cluster process exited', options

  # Log extensions events
  @on 'filechange', (file) ->
    logger.debug "#{file} was changed", options

  return this
