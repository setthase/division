fs   = require 'fs'
path = require 'path'
{exec, spawn} = require 'child_process'

option "-r", "--reporter [REPORTER]", "reporter type for tests"

#############################
compiled = no

task "all", "Compile source files and then run test on compiled library", ->
  # Compile source
  process.stdout.write "\n\x1b[36m  Compiling sources...\x1b[0m\n"
  invoke "compile"

  # Run tests
  test = ->
    if compiled
      clearInterval wait
      process.stdout.write "\x1b[36m  Running test suite...\x1b[0m"
      invoke "test"

  # Wait for compilation
  wait = setInterval test, 100

task "compile", "Compile files from '/src' directory into '/lib' directory", ->
  __start = Date.now()

  exec "rm -rf ./lib && mkdir lib", (error, stdout, stderr) ->
    if error
      process.stderr.write "\n\x1b[31m  Compilation failed\n  Error:\x1b[0m #{stderr}\n"
      process.exit 1

    exec "./node_modules/.bin/coffee -b -c -o lib/ src/", (error, stdout, stderr) ->
      if error
        process.stderr.write "\n\x1b[31m  Compilation failed\n  Error:\x1b[0m #{stderr}\n"
        process.exit 1

      compiled = yes
      process.stdout.write "\n\x1b[32m  Compilation successful\x1b[90m (#{Date.now() - __start} ms)\x1b[0m\n\n"

task "test", "Run `mocha` test suite", (options) ->

  do process.stdin.resume

  files   = []
  results = []

  # Helpers
  forEachSeries = (arr, iterator, callback) ->
    callback = callback or ->
    return do callback unless arr.length

    completed = 0
    iterate = ->
      iterator arr[completed], (err) ->
        if err
          callback err
          callback = ->
        else
          completed += 1
          if completed >= arr.length
            callback null
          else
            do iterate
    do iterate

  resolvePath = (path) ->
    return if '/' is path[0] then path else __dirname + '/test/' + path

  traverse = (file, next) ->
    file = resolvePath path.normalize file
    fs.stat file, (error, stat) ->
      throw new Error error if error
      if do stat.isDirectory
        fs.readdir file, (err, files) ->
          forEachSeries files.map( (f) -> file + '/' + f ), traverse, next
      else
        files.push file
        do next

  test = (file, next) ->
    if ".coffee" isnt path.extname file

      results.push 0
      do next

    else

      parameters = [file]

      if options.reporter
        parameters = parameters.concat "--reporter", options.reporter

      mocha = spawn "./node_modules/.bin/mocha", parameters

      mocha.stdout.on 'data', (data) -> do process.stdout.write data.toString
      mocha.stderr.on 'data', (data) -> do process.stderr.write data.toString

      mocha.on "exit", (code) ->
        results.push code
        do next

  #############################

  # Read test
  fs.readdir "test", (e, f) ->
    forEachSeries f, traverse, ->
      forEachSeries files, test, ->
        process.exit if results.some((result) -> result isnt 0) then 1 else 0

