# Require dependencies
{exec}   = require 'child_process'
should   = require 'should'
division = new (require __dirname + '/../..')({ path: __dirname + '/../../example/noop.js' })

############################

describe '~ division watch ~', ->

  master = null

  before (next) ->
    division.use 'watch', [__dirname + '/../../example/noop.js', process.argv[1]], { extensions: ['.js', ''] }
    master = do division.run

    setTimeout next, 1000

  after ->
    do master.destroy

  it 'should restart cluster when file was changed', (next) ->
    pid = master.workers[0].pid

    exec 'touch ' + __dirname + '/../../example/noop.js', (error) ->
      if error then next error

      setTimeout ->
        master.workers[0].pid.should.not.equal pid
        do next
      , 5000

  it 'should not restart cluster when main file was changed', (next) ->
    pid = master.workers[0].pid

    exec 'touch ' + process.argv[1], (error) ->
      if error then next error

      setTimeout ->
        master.workers[0].pid.should.equal pid
        do next
      , 5000
