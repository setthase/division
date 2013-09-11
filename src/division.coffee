# Require dependencies
fs             = require 'fs'
Master         = require './master'
cluster        = require 'cluster'
{EventEmitter} = require 'events'

# Wrapper around cluster API
module.exports = class Division extends EventEmitter

  ############################
  #
  # Constructor
  #
  constructor: (settings) ->

    # Helper providing definer of values (added to instance)
    `var __define`
    __define = (args...) => Object.defineProperty.apply null, [].concat this, args

    # Public constants
    __define "version",     enumerable: yes, value: require(__dirname + '/../package.json').version
    __define "environment", enumerable: yes, value: process.env.NODE_ENV || 'development'

    # Public variables
    __define "settings", enumerable: yes, set: (->), get: -> @__settings

    # Private constants
    __define "master",  value: new Master()

    # Private variables
    __define "running",    writable: yes, value: off
    __define "__settings", writable: yes, value: { extensions : [], size : Math.max 2, require('os').cpus().length }

    # Apply user defined settings
    @extend @__settings, settings

  ############################
  #
  # Define public methods
  #

  # Helper providing definer of methods (added to prototype)
  __define = (args...) => Object.defineProperty.apply null, [].concat Division.prototype, args

  # Configure callback for zero or more environments
  __define "configure", enumerable: yes, value: (environments..., fn)->
    # Skip configuration if there is no callback defined
    return this if not fn or typeof fn isnt 'function'

    # Check if this.environment is in environments list
    if environments.length is 0 or ~ environments.indexOf @environment then fn.call this

    return this

  # Assign `setting` in settings to `value`
  __define "set", enumerable: yes, value: (setting, value)->
    @__settings[setting] = value
    return this

  # Return value of `setting`
  __define "get", enumerable: yes, value: (setting)->
    return @__settings[setting]

  # Enable `setting`
  __define "enable", enumerable: yes, value: (setting)->
    return @set setting, on

  # Check if `setting` is enabled (truthy)
  __define "enabled", enumerable: yes, value: (setting)->
    return !!@__settings[setting]

  # Disable `setting`
  __define "disable", enumerable: yes, value: (setting)->
    return @set setting, off

  # Check if `setting` is disabled (truthy)
  __define "disabled", enumerable: yes, value: (setting)->
    return !@__settings[setting]

  # Use the given `extension`
  __define "use", enumerable: yes, value: (extension, parameters...) ->
    return this if not extension

    if typeof extension is "string"
      @__settings.extensions.push extension

      try
        extension = require @resolve extension
      catch
        extension = ->

    extension.apply @master, parameters

    return this

  # Start cluster process
  __define "run", enumerable: yes, value: (fn) ->

    if cluster.isWorker
      message = "You cannot run cluster in worker process!\n"

      if ~ @__settings.extensions.indexOf 'debug'
        @emit.call this, "error", "\n#{message}"

      else
        process.stderr.write message

      return process.exit 3

    if not @running
      @master.configure @__settings

      # Start master process
      process.nextTick =>
        counter = 0
        do @master.spawn while counter++ < @__settings.size

        fn.call @master, @master if typeof fn is 'function'

    @running = yes

    return @master

  ############################
  #
  # Define private methods
  #

  # Check if `path` is plain Object
  __define "resolve", value: do ->
    extensions = fs.readdirSync(__dirname + '/extensions').map (file) -> file.split(".")[0]

    return (extension) ->
      if ~ extensions.indexOf extension
        return __dirname + '/extensions/' + extension
      else
        return extension

  # Deeply extend object
  __define "extend", value : (target, source) ->
    if typeof target isnt "object" and typeof target isnt 'function'
      target = {}

    for own key, copy of source
      # Prevent never-ending loop
      continue if target is copy

      # Recursive call if we're merging plain objects or arrays
      if copy and ( @__object(copy) or (array = @__array(copy)) )
        src = target[key]

        if array
          clone = if src and @__array(src) then src else []
          array = no

        else
          clone = if src and @__object(src) then src else {}

        # Never move original objects, clone them
        target[key] = @extend clone, copy

      # Don't bring in undefined values
      else if copy isnt undefined
        target[key] = copy

    return target

  # Check if `obj` is plain Object
  __define "__object", value: (obj) ->
    return no if typeof obj isnt "object" or obj.nodeType

    # The try/catch suppresses exceptions thrown when attempting to access the "constructor" property of certain host objects
    try
        return no if obj.constructor and not Object.hasOwnProperty.call obj.constructor.prototype, "isPrototypeOf"
    catch
        return no

    return yes

  # Check if `array` is an Array
  __define "__array", value: (array) ->
    return Array.isArray.call array
