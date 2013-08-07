{exec, spawn} = require 'child_process'

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

task "test", "Run `mocha` test suite", ->
  mocha = spawn "./node_modules/.bin/mocha"

  mocha.stdout.on 'data', (data) -> process.stdout.write data.toString()
  mocha.stderr.on 'data', (data) -> process.stderr.write data.toString()

  mocha.on "exit", (code) ->
    process.exit code
