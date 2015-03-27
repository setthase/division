# Require dependencies
should   = require 'should'
cluster  = require 'cluster'
Master   = require  __dirname + '/../lib/master'
Division = require  __dirname + '/..'
division = new Division({ path: __dirname + '/../examples/noop.js', size : 1 })

############################

describe 'Class Division', ->

  ############################
  #
  # Architecture of object check
  #

  describe 'Check architecture consistency', ->

    it 'should contain version attribute', ->
      should.exist division.version

    it 'should contain environment attribute', ->
      should.exist division.environment

    it 'should default to `development` environment', ->
      division.environment.should.equal 'development'

    it 'should contain settings attribute', ->
      should.exist division.settings

    it 'should have default values in settings attribute', ->
      division.settings.should.be.an.Object
      division.settings.should.containEql { extensions : [], size : 1 }

    it 'should contain configure method', ->
      should.exist division.configure
      division.configure.should.be.a.Function

    it 'should contain set method', ->
      should.exist division.set
      division.set.should.be.a.Function

    it 'should contain get method', ->
      should.exist division.get
      division.get.should.be.a.Function

    it 'should contain enable method', ->
      should.exist division.enable
      division.enable.should.be.a.Function

    it 'should contain enabled method', ->
      should.exist division.enabled
      division.enabled.should.be.a.Function

    it 'should contain disable method', ->
      should.exist division.disable
      division.disable.should.be.a.Function

    it 'should contain disabled method', ->
      should.exist division.disabled
      division.disabled.should.be.a.Function

    it 'should contain use method', ->
      should.exist division.use
      division.use.should.be.a.Function

    it 'should contain run method', ->
      should.exist division.run
      division.run.should.be.a.Function

  ############################
  #
  # Functionality of object check
  #

  describe 'Check methods functionality', ->

    describe 'configure', ->

      it 'should run callback function when `environment` parameter is not set', (next) ->
        division.configure next

      it 'should run callback function when environments match', (next) ->
        division.configure 'development', next

      it 'should not run callback function when environments not match', (next) ->
        division.configure 'production', ->
          throw Error 'unwanted callback called'

        # We assume that if callback is not called in 300ms it will be never called
        setTimeout next, 300

      it 'should return Division class for chaining possibility', ->
        division.configure().should.be.an.instanceof Division

    describe 'set', ->

      it 'should set `value` into `setting` key', ->
        division.set 'test_key', 'test_value'
        division.settings.should.containEql { test_key : 'test_value' }

      it 'should return Division class for chaining possibility', ->
        division.set().should.be.an.instanceof Division

    describe 'get', ->

      it 'should return `value` from `setting` key', ->
        division.get('test_key').should.equal 'test_value'

    describe 'enable', ->

      it 'should set `value` to true for `setting` key', ->
        division.enable 'test_key'
        division.settings.test_key.should.be.true

      it 'should return Division class for chaining possibility', ->
        division.enable().should.be.an.instanceof Division

    describe 'enabled', ->

      it 'should return true if `value` for `setting` key is truthy', ->
        division.enabled('test_key').should.be.true

      it 'should return false if `value` for `setting` key is falsy', ->
        division.enabled('unknown').should.be.false

    describe 'disable', ->

      it 'should set `value` to false for `setting` key', ->
        division.disable 'test_key'
        division.settings.test_key.should.be.false

      it 'should return Division class for chaining possibility', ->
        division.disable().should.be.an.instanceof Division

    describe 'disabled', ->

      it 'should return true if `value` for `setting` key is falsy', ->
        division.disabled('test_key').should.be.true

      it 'should return false if `value` for `setting` key is truthy', ->
        division.disabled('size').should.be.false

    describe 'use', ->

      it 'should add extension to list on enabled extensions when `extension` is string', ->
        division.use 'signals'
        division.settings.extensions.should.containEql 'signals'

      it 'should not break when cannot require an extension', ->
        division.use 'unknown'

      it 'should run custom extension function', (next) ->
        division.use next

      it 'should return Division class for chaining possibility', ->
        division.use().should.be.an.instanceof Division

    describe 'run', ->

      it 'should return Master class', ->
        master = do division.run

        division.running.should.be.true
        master.should.be.an.instanceof Master

        do master.destroy

      it 'should skip configuration if called second time', ->
        master = do division.run

        # This should does nothing
        do division.run

        master.workers.length.should.be.equal 1

        do master.destroy

      it 'should not run in worker context', (next) ->

        noop = ->

        cluster.isWorker = true

        division.run.bind(division).should.throw /You cannot run cluster in worker process/

        division.use 'debug', null, { error : noop, debug : noop }
        division.on 'error', (error) ->

          error.should.containEql 'You cannot run cluster in worker process'

          cluster.isWorker = false

          do next

        do division.run

  ############################
  #
  # Check private helpers
  #

  describe 'Check private helpers', ->

    describe 'extend', ->

      it 'should extend standard object', ->
        source = { a : 1 }
        target = {}
        clone  = division.extend target, source

        clone.should.be.eql source

      it 'should extend standard function', ->
        source = { a : 1 }
        target = ->
        clone  = division.extend target, source

        should.exist clone.a
        clone.a.should.be.eql source.a

      it 'should return copy of object if target isn\'t object or function', ->
        source = { a : 1 }
        target = 'some string'
        clone  = division.extend target, source

        clone.should.be.eql source

      it 'should do nothing if target is a part of source', ->
        source = { a : { b : 1 } }
        target = source.a
        clone  = division.extend target, source

        clone.should.be.equal target

      it 'should extend deeply', ->
        source = { a : { b : { c :[1] } } }
        target = {}
        clone  = division.extend target, source

        clone.should.eql source

      it 'should not extend from prototype', ->
        class x
          constructor : (@a) ->

        x.prototype.b = { c : 3 }

        source = new x(2)
        target = {}
        clone  = division.extend target, source

        clone.should.eql source

        should.exist source.b
        should.not.exist clone.b

      it 'should skip undefined properties', ->
        source = { a : null, b : undefined }
        target = {}
        clone  = division.extend target, source

        source.hasOwnProperty('b').should.be.true
        clone.hasOwnProperty('b').should.be.false

    describe '__object', ->

      it 'should return true if object is passed', ->
        division.__object({}).should.be.true
        division.__object({ a : 1 }).should.be.true

      it 'should return false if other types are passed', ->
        division.__object([]).should.be.false
        division.__object(false).should.be.false
        division.__object(12354).should.be.false
        division.__object('{}').should.be.false

    describe '__array', ->

      it 'should return true if array is passed', ->
        division.__array([]).should.be.true
        division.__array([ 1, 2, 3 ]).should.be.true

      it 'should return false if other types are passed', ->
        division.__array({}).should.be.false
        division.__array(false).should.be.false
        division.__array(12354).should.be.false
        division.__array('[]').should.be.false

