# Require dependencies
should   = require 'should'
Master   = require  __dirname + '/../lib/master'
division = require  __dirname + '/..'

############################

describe 'Class Master', ->

  ############################
  #
  # Architecture of object check
  #

  describe 'Check architecture consistency', ->

    master = null

    before ->
      cluster = new division({ path: __dirname + '/../example/noop.js' })
      master  = do cluster.run

      # Increase limit of fast-killing workers to 100
      cluster.set 'kills', 100

    after ->
      do master.destroy

    it 'should contain pid attribute', ->
      should.exist master.pid

    it 'should contain startup attribute', ->
      should.exist master.startup

    it 'should contain addSignalListener method', ->
      should.exist master.addSignalListener
      master.addSignalListener.should.be.a.Function

    it 'should contain increase method', ->
      should.exist master.increase
      master.increase.should.be.a.Function

    it 'should contain decrease method', ->
      should.exist master.decrease
      master.decrease.should.be.a.Function

    it 'should contain restart method', ->
      should.exist master.restart
      master.restart.should.be.a.Function

    it 'should contain close method', ->
      should.exist master.close
      master.close.should.be.a.Function

    it 'should contain destroy method', ->
      should.exist master.destroy
      master.destroy.should.be.a.Function

    it 'should contain kill method', ->
      should.exist master.kill
      master.kill.should.be.a.Function

    it 'should contain maintenance method', ->
      should.exist master.maintenance
      master.maintenance.should.be.a.Function

    it 'should contain publish method', ->
      should.exist master.publish
      master.publish.should.be.a.Function

    it 'should contain broadcast method', ->
      should.exist master.broadcast
      master.broadcast.should.be.a.Function

  ############################
  #
  # Functionality of object check
  #

  describe 'Check methods functionality', ->

    describe 'increase', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

      it 'should increase number of workers (default by one)', (next) ->
        size = master.workers.length
        do master.increase

        setTimeout ->
          master.workers.length.should.be.above size
          master.workers.length.should.equal size + 1
          do next
        , 100

      it 'should increase number of workers by passed amount', (next) ->
        size = master.workers.length
        master.increase 5

        setTimeout ->
          master.workers.length.should.be.above size
          master.workers.length.should.equal size + 5
          do next
        , 100

      it 'should emit `increase` event', (next) ->
        master.once 'increase', ->
          do next

        do master.increase

      it 'should send amount of workers created in `increase` event', (next) ->
        master.once 'increase', (amount) ->
          should.exist amount
          amount.should.equal 1

          do next

        do master.increase

      it 'should return Master class for chaining possibility', ->
        master.increase().should.be.instanceof Master

    describe 'decrease', ->

      master  = null

      before (next) ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

        master.increase 5

        setTimeout next, 1000

      after ->
        do master.destroy

      it 'should decrease number of workers (default by one)', (next) ->
        size = master.workers.length
        do master.decrease

        setTimeout ->
          master.workers.length.should.be.below size
          master.workers.length.should.equal size - 1
          do next
        , 5000

      it 'should decrease number of workers by passed amount', (next) ->
        size = master.workers.length
        master.decrease 5

        setTimeout ->
          master.workers.length.should.be.below size
          master.workers.length.should.equal size - 5
          do next
        , 5000

      it 'should emit `decrease` event', (next) ->
        master.once 'decrease', ->
          do next

        do master.decrease

      it 'should send amount of workers removed in `decrease` event', (next) ->
        master.once 'decrease', (amount) ->
          should.exist amount
          amount.should.equal 1

          do next

        do master.decrease

      it 'should return Master class for chaining possibility', ->
        master.decrease().should.be.instanceof Master

    describe 'restart', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after (next) ->
        setTimeout ->
          do master.destroy
          do next
        , 3000

      it 'should emit `restart` event', (next) ->
        master.once 'restart', next
        do master.restart

    describe 'close', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      it 'should emit `close` event', (next) ->
        master.once 'close', next
        do master.close

    describe 'destroy', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      it 'should emit `destroy` event', (next) ->
        master.once 'destroy', next
        do master.destroy

    describe.skip 'kill', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

      it '', ->

    describe.skip 'publish', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

      it '', ->

    describe.skip 'broadcast', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

      it '', ->

  ############################
  #
  # Check private helpers
  #

  describe 'Check private helpers', ->

    describe.skip 'spawn', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

    describe.skip 'registerEvents', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

    describe.skip 'deregisterEvents', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

    describe.skip 'worker', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

    describe.skip 'cleanup', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

    describe 'killed', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

      it 'should does nothing when `state` is set as `graceful`', ->

        count = master.workers.length

        master.state = 'graceful'
        master.killed {}

        master.workers.length.should.be.equal count

      it 'should decrease number of pending kills when `state` is set as `forceful`', ->

        master.pending = 2

        master.state = 'forceful'
        master.killed {}

        master.pending.should.be.equal 1

      it 'should throw when more that 30 workers died in short time', ->

        master.state = ''

        master.__killed   = 30
        master.__incident = do Date.now

        master.killed.bind(master, {}).should.throw()

