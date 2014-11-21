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

    describe 'close', ->

      master = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

      it 'should emit `close` event', (next) ->
        worker = master.workers[0]

        worker.once 'close', next
        do worker.close

      it 'should turn on `decreased` flag if second parameter is true', ->
        worker = master.workers[0]
        worker.close null, true

        worker.decreased.should.be.true

    describe 'kill', ->

      master = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

      it 'should emit `kill` event with signal name', (next) ->
        worker = master.workers[0]

        worker.once 'kill', (signal) ->
          signal.should.be.equal 'SIGTERM'
          do next

        do worker.kill

      it 'should change worker status to `dead`', (next) ->
        worker = master.workers[0]
        do worker.kill

        setTimeout ->
          worker.status.should.equal 'dead'
          do next
        , 3000

    describe 'publish', ->

      master = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

      it 'should emit `publish` event', (next) ->
        worker = master.workers[0]

        worker.once 'publish', (event) ->
          event.should.be.equal 'test'
          do next

        worker.publish 'test'

      it 'should pass parameter directly to emitted `publish` event', (next) ->
        worker = master.workers[0]

        worker.once 'publish', (event, param) ->
          event.should.be.equal 'test'

          param.should.not.be.an.Array
          param.should.be.eql 1

          do next

        worker.publish 'test', 1


      it 'should pass parameters as an array to emitted `publish` event', (next) ->
        worker = master.workers[0]

        worker.once 'publish', (event, params) ->
          event.should.be.equal 'test'

          params.should.be.an.Array
          params.should.be.eql [ 1, 2, 3 ]

          do next

        worker.publish 'test', 1, 2, 3


