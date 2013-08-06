(function() {
  module.exports = function() {
    this.addSignalListener('SIGQUIT', this.close);
    this.addSignalListener('SIGINT', this.destroy);
    this.addSignalListener('SIGTERM', this.destroy);
    this.addSignalListener('SIGUSR2', this.restart);
    this.addSignalListener('SIGTTIN', this.increase);
    this.addSignalListener('SIGTTOU', this.decrease);
    this.addSignalListener('SIGCHLD', this.maintenance);
    return this;
  };

}).call(this);
