############################
#
# ~ division signals ~
#
# Extension add ability to control cluster with POSIX signals
#

module.exports =  ->

  # Graceful shutdown of cluster
  @addSignalListener 'SIGQUIT', @close

  # Forceful shutdown of cluster
  @addSignalListener 'SIGINT',  @destroy
  @addSignalListener 'SIGTERM', @destroy

  # Restart all workers
  @addSignalListener 'SIGUSR2', @restart

  # Increase number of workers
  @addSignalListener 'SIGTTIN', @increase

  # Decrease number of workers
  @addSignalListener 'SIGTTOU', @decrease

  # Check for consistency of workers count
  @addSignalListener 'SIGCHLD', @maintenance

  return this
