############################
#
# ~ division signals ~
#
# Extension adding ability to control cluster by POSIX signals
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
