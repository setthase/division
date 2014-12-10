## Require dependencies
fs = require 'fs'

## Define helpers

# Join elements to one string
glue = (elements...) -> elements.join ''

# Change length of `value` by changing string offset by `sign` prefix
offset = (value, sign, length) ->
  base = new Array(length + 1).join sign

  (base + value).slice -length

# Get formatted date and time
Time = ->
  d = new Date()

  day   = do d.getDate
  month = 1 + do d.getMonth
  year  = do d.getFullYear
  hour  = do d.getHours
  min   = do d.getMinutes
  sec   = do d.getSeconds
  ms    = do d.getMilliseconds

  glue offset(day, 0, 2), '-', offset(month, 0, 2), '-', year, ' ', offset(hour, 0, 2), ':', offset(min, 0, 2), ':', offset(sec, 0, 2), ':', offset(ms, 0, 3)

## Export logger
module.exports = logger = {}

modes = { error : 31, warn : 33, info : 36, debug : 90 }

for mode, color of modes
  # Create `mode` logger style
  logger[mode] = do (color, mode) ->
    (message, options) ->

      # Parse some values
      time  = do Time
      mode  = offset mode, ' ', 8

      label = glue mode, ' [', time, '] '
      label = glue '\x1b[', color, 'm', label, '\x1b[0m'

      message = glue label, message, '\n'

      # Write message to file
      if options.file
        fs.writeFile options.file, message, { flag : 'a', encoding: 'utf8' }

      # Write message to console
      if options.console is on
        process.stderr.write message
