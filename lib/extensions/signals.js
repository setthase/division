(function() {
  module.exports = function() {
    this.addSignalListener('SIGQUIT', this.close);
    this.addSignalListener('SIGINT', this.destroy);
    this.addSignalListener('SIGTERM', this.destroy);
    this.addSignalListener('SIGUSR2', this.restart);
    this.addSignalListener('SIGTTIN', this.increase);
    this.addSignalListener('SIGTTOU', this.decrease);
    return this.addSignalListener('SIGCHLD', this.maintenance);
  };

}).call(this);
