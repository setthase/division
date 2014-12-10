# Require dependencies
should = require 'should'
sinon  = require 'sinon'
debug  = require  __dirname + '/../../lib/extensions/debug.js'

{EventEmitter} = require 'events'

############################

describe '~ division debug ~', ->

  # Prepare test helpers
  emitter = new EventEmitter()
  logger  = {
    debug : sinon.spy()
    error : sinon.spy()
    warn  : sinon.spy()
    info  : sinon.spy()
  }

  debuger = debug.apply emitter, [ null, logger ]

  ############

  it 'should register event listeners on the scope', ->
    emitter.listeners('error').length.should.be.equal 1
    emitter.listeners('increase').length.should.be.equal 1
    emitter.listeners('decrease').length.should.be.equal 1
    emitter.listeners('restart').length.should.be.equal 1
    emitter.listeners('close').length.should.be.equal 1
    emitter.listeners('destroy').length.should.be.equal 1
    emitter.listeners('fork').length.should.be.equal 1
    emitter.listeners('online').length.should.be.equal 1
    emitter.listeners('listening').length.should.be.equal 1
    emitter.listeners('disconnect').length.should.be.equal 1
    emitter.listeners('exit').length.should.be.equal 1
    emitter.listeners('filechange').length.should.be.equal 1

  it 'should log information after emitted event', ->

    # emit different types of events
    emitter.emit 'error'
    emitter.emit 'increase'
    emitter.emit 'decrease'
    emitter.emit 'restart'
    emitter.emit 'close'
    emitter.emit 'destroy'
    emitter.emit 'fork'
    emitter.emit 'online'
    emitter.emit 'listening'
    emitter.emit 'disconnect'
    emitter.emit 'exit'
    emitter.emit 'filechange'

    # check if logger methods was called
    logger.debug.called.should.be.true
    logger.error.called.should.be.true
    logger.warn.called.should.be.true
    logger.info.called.should.be.true

