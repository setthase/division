# Require dependencies
should   = require 'should'
Master   = require  __dirname + '/../lib/master'
Division = require  __dirname + '/..'
division = new Division({ path: __dirname + '/../example/noop.js' })

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
      division.settings.should.be.a 'object'
      division.settings.should.include { extensions : [], size : Math.max 2, require('os').cpus().length }

    it 'should contain configure method', ->
      should.exist division.configure
      division.configure.should.be.a 'function'

    it 'should contain set method', ->
      should.exist division.set
      division.set.should.be.a 'function'

    it 'should contain get method', ->
      should.exist division.get
      division.get.should.be.a 'function'

    it 'should contain enable method', ->
      should.exist division.enable
      division.enable.should.be.a 'function'

    it 'should contain enabled method', ->
      should.exist division.enabled
      division.enabled.should.be.a 'function'

    it 'should contain disable method', ->
      should.exist division.disable
      division.disable.should.be.a 'function'

    it 'should contain disabled method', ->
      should.exist division.disabled
      division.disabled.should.be.a 'function'

    it 'should contain use method', ->
      should.exist division.use
      division.use.should.be.a 'function'

    it 'should contain run method', ->
      should.exist division.run
      division.run.should.be.a 'function'

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
        division.settings.should.include { test_key : 'test_value' }

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
        division.settings.extensions.should.include 'signals'

      it 'should not break when cannot require an extension', ->
        division.use 'unknown'

      it 'should run custom extension function', (next) ->
        division.use next

      it 'should return Division class for chaining possibility', ->
        division.use().should.be.an.instanceof Division

    describe 'run', ->

      it 'should return Master class', ->
        master = do division.run
        master.should.be.an.instanceof Master

        do master.destroy
