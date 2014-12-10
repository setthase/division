# Require dependencies
fs   = require 'fs'
path = require 'path'

############################
#
# ~ division watch ~
#
# Extension provide automatic restart of cluster when files are changed
#

module.exports = (files, options = {}) ->

  # Default settings
  __dirname__ = do process.cwd

  if not files then files = __dirname__
  if not Array.isArray files then files = [files]

  ignored    = ['node_modules', 'test', 'bin', '.git'].concat options.ignored
  interval   = options.interval or 100
  extensions = options.extensions or ['.js']

  # Helpers
  resolvePath = (path) ->
    return if '/' is path[0] then path else __dirname__ + '/' + path

  traverse = (file) ->
    file = resolvePath path.normalize file
    fs.stat file, (error, stat) ->
      unless error
        if do stat.isDirectory
          return if ~ ignored.indexOf path.basename file
          fs.readdir file, (err, files) ->
            files.map( (f) -> file + '/' + f ).forEach traverse
        else
          watch file unless file is process.argv[1]

  watch = (file) =>
    return unless ~ extensions.indexOf path.extname file

    fs.watchFile file, { interval, persistent : no }, (curr, prev) =>
      if curr.mtime > prev.mtime
        @emit 'filechange', file
        do @restart

  # Traverse on each path in files and set watcher
  files.forEach traverse
