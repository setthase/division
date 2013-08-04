Master         = require './Master'
{EventEmitter} = require 'events'

# Wrapper around cluster API
module.exports = class Division extends EventEmitter
  constructor: (settings) ->
    @environment = process.env.NODE_ENV || 'development'

    @master  = new Master()
    @version = "0.1.0"

    # Default settings
    @settings =
      size : Math.max 2, require('os').cpus().length

    # Apply user defined settings
    @extend @settings, settings

    # Status of Division
    @running = no

  ############################

  ## Helper for adding properties to prototype
  __define = (args...) => Object.defineProperty.apply null, [].concat Division.prototype, args

  ############################
  #
  # Define public methods
  #

  # Configure callback for zero or more environments
  __define "configure", enumerable: yes, value: (environments..., fn)->
    # Skip configuration if there is no callback defined
    return this if not fn or typeof fn isnt 'function'

    # Check if this.environment is in environments list
    if environments.length is 0 or ~environments.indexOf @environment then fn.call this

    return this

  # Assign `setting` in settings to `value`
  __define "set", enumerable: yes, value: (setting, value)->
    @settings[setting] = value
    return this

  # Return value of `setting`
  __define "get", enumerable: yes, value: (setting)->
    return @settings[setting]

  # Enable `setting`
  __define "enable", enumerable: yes, value: (setting)->
    return @set setting, on

  # Check if `setting` is enabled (truthy)
  __define "enabled", enumerable: yes, value: (setting)->
    return !!@settings[setting]

  # Disable `setting`
  __define "disable", enumerable: yes, value: (setting)->
    return @set setting, off

  # Check if `setting` is disabled (truthy)
  __define "disabled", enumerable: yes, value: (setting)->
    return !@settings[setting]

  # Add extensions
  # __define "use"

  # Start cluster process
  __define "run", enumerable: yes, value: ->
    if not @running
      @master.configure @settings

      # Start master process
      process.nextTick =>
        counter = 0
        do @master.increase while counter++ <= @settings.size

      @running = yes

    return @master

  ############################
  #
  # Define private methods
  #

  # Check if `obj` is plain Object
  __define "isPlainObject", value: (obj) ->
    return no if typeof obj isnt "object" or obj.nodeType

    # The try/catch suppresses exceptions thrown when attempting to access the "constructor" property of certain host objects
    try
        return no if obj.constructor and not Object.hasOwnProperty.call obj.constructor.prototype, "isPrototypeOf"
    catch
        return no

    return yes

  # Check if `array` is Array
  __define "isArray", value: (array) ->
    return Array.isArray.call array

  # Deeply extend object
  __define "extend", value : (target, source) ->
    if typeof target isnt "object" and typeof target isnt 'function'
      target = {}

    for own key, copy of source
      # Prevent never-ending loop
      continue if target is copy

      # Recursive call if we're merging plain objects or arrays
      if copy and ( @isPlainObject(copy) or (isArray = @isArray(copy)) )
        src = target[key]

        if isArray
          clone   = if src and @isArray(src) then src else []
          isArray = no

        else
          clone = if src and @isPlainObject(src) then src else {}

        # Never move original objects, clone them
        target[key] = @extend clone, copy

      # Don't bring in undefined values
      else if copy isnt undefined
        target[key] = copy

    return target
