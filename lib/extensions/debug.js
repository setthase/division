(function() {
  var logger;

  logger = require('./helpers/logger');

  module.exports = function(options) {
    options = options || {
      console: true
    };
    this.on("error", function(error) {
      return logger.error(error, options);
    });
    this.on("increase", function() {
      return logger.info("Number of workers increased", options);
    });
    this.on("decrease", function() {
      return logger.info("Number of workers decreased", options);
    });
    this.on("restart", function() {
      return logger.info("Worker processes restarted", options);
    });
    this.on("close", function() {
      return logger.info("Gracefully closing cluster process", options);
    });
    this.on("destroy", function() {
      return logger.warn("Forcefully closing (killing) cluster process", options);
    });
    this.on("fork", function(worker) {
      return logger.debug("New worker forked", options);
    });
    this.on("online", function(worker) {
      return logger.debug("Worker #" + worker.id + " (PID: " + worker.pid + ") is online", options);
    });
    this.on("listening", function(worker, address) {
      return logger.debug("Worker #" + worker.id + " (PID: " + worker.pid + ") is listening", options);
    });
    this.on("disconnect", function(worker) {
      return logger.debug("Worker #" + worker.id + " (PID: " + worker.pid + ") is disconnected", options);
    });
    this.on("exit", function(worker, code, signal) {
      if (worker.instance.suicide) {
        return logger.debug("Worker #" + worker.id + " (PID: " + worker.pid + ") is exited", options);
      } else {
        return logger.error("Worker #" + worker.id + " (PID: " + worker.pid + ") is exited unexpectedly (code: " + code + ", signal: " + signal + ")", options);
      }
    });
    process.on("uncaughtException", function(error) {
      logger.error(error, options);
      return process.exit(1);
    });
    process.on("exit", function() {
      return logger.debug("Cluster process exited", options);
    });
    return this;
  };

}).call(this);
