# Require dependencies
should   = require 'should'
Worker   = require  __dirname + '/../lib/worker'
division = require  __dirname + '/..'

############################

describe 'Class Worker', ->

  ############################
  #
  # Architecture of object check
  #

  describe 'Check architecture consistency', ->

    master = null
    worker = null

    before ->
      cluster = new division({ path: __dirname + '/../example/noop.js', size : 1 })
      master  = cluster.run ->
        worker  = @workers[0]

    after ->
      do master.destroy

    it 'should contain id attribute', ->
      should.exist worker.id

    it 'should contain pid attribute', ->
      should.exist worker.pid

    it 'should contain startup attribute', ->
      should.exist worker.startup

    it 'should contain status attribute', ->
      should.exist worker.status

    it 'should contain close method', ->
      should.exist worker.close
      worker.close.should.be.a.Function

    it 'should contain kill method', ->
      should.exist worker.kill
      worker.kill.should.be.a.Function

    it 'should contain publish method', ->
      should.exist worker.publish
      worker.publish.should.be.a.Function

  ############################
  #
  # Functionality of object check
  #

  describe 'Check methods functionality', ->

    describe 'increase', ->

