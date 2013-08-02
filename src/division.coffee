cluster      = require 'cluster'
EventEmitter = require('events').EventEmitter

Master = require './Master'
Worker = require './Worker'

# Wrapper around cluster API
class Division extends EventEmitter
  constructor: (exec, args, silent) ->
