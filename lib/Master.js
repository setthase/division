(function() {
  var EventEmitter, Master, Worker, cluster,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  Worker = require('./Worker');

  cluster = require('cluster');

  EventEmitter = require('events').EventEmitter;

  module.exports = Master = (function(_super) {
    var __define,
      _this = this;

    __extends(Master, _super);

    function Master() {
      var __define;
      var __define,
        _this = this;
      __define = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return Object.defineProperty.apply(null, [].concat(_this, args));
      };
      __define("pid", {
        enumerable: true,
        value: process.pid
      });
      __define("startup", {
        enumerable: true,
        value: Date.now()
      });
      __define("workers", {
        writable: true,
        value: []
      });
      __define("state", {
        writable: true,
        value: ''
      });
      __define("pending", {
        writable: true,
        value: 0
      });
      __define("__killed", {
        writable: true,
        value: 0
      });
    }

    __define = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return Object.defineProperty.apply(null, [].concat(Master.prototype, args));
    };

    __define("addSignalListener", {
      enumerable: true,
      value: function(signal, callback) {
        process.on(signal, callback.call(this));
        return this;
      }
    });

    __define("increase", {
      enumerable: true,
      value: function(n) {
        if (n == null) {
          n = 1;
        }
        while (n--) {
          this.workers.push(new Worker());
        }
        return this;
      }
    });

    __define("decrease", {
      enumerable: true,
      value: function(n) {
        var limit;
        if (n == null) {
          n = 1;
        }
        if (n <= 0) {
          n = 1;
        }
        if (n > (limit = this.workers.length)) {
          n = limit;
        }
        while (n--) {
          this.workers.pop().close();
        }
        return this;
      }
    });

    __define("restart", {
      enumerable: true,
      value: function() {
        this.workers.forEach(function(worker) {
          return worker.close();
        });
        return this;
      }
    });

    __define("close", {
      enumerable: true,
      value: function() {
        this.state = 'graceful';
        this.pending = this.workers.length;
        this.workers.forEach(function(worker) {
          return worker.close();
        });
        return this;
      }
    });

    __define("destroy", {
      enumerable: true,
      value: function() {
        this.state = 'forceful';
        this.kill('SIGKILL');
        return this;
      }
    });

    __define("kill", {
      enumerable: true,
      value: function(signal) {
        if (signal == null) {
          signal = "SIGTERM";
        }
        this.workers.forEach(function(worker) {
          return worker.kill(signal);
        });
        return this;
      }
    });

    __define("publish", {
      enumerable: true,
      value: function() {
        var event, id, parameters, _ref;
        id = arguments[0], event = arguments[1], parameters = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
        if ((_ref = this.worker(id)) != null) {
          _ref.publish(event, parameters);
        }
        return this;
      }
    });

    __define("broadcast", {
      enumerable: true,
      value: function() {
        var event, parameters;
        event = arguments[0], parameters = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        this.workers.forEach(function(worker) {
          return worker.publish(event, parameters);
        });
        return this;
      }
    });

    __define("configure", {
      enumerable: true,
      value: function(settings) {
        this.settings = settings;
        this.registerEvents();
        return cluster.setupMaster({
          exec: this.settings.path,
          args: this.settings.args,
          silent: this.settings.silent
        });
      }
    });

    __define("registerEvents", {
      value: function() {
        var _this = this;
        if (!this.registered) {
          cluster.on("fork", function(worker) {
            worker = _this.worker(worker.id);
            return _this.emit("fork", worker);
          });
          cluster.on("online", function(worker) {
            worker = _this.worker(worker.id);
            return _this.emit("online", worker);
          });
          cluster.on("listening", function(worker, address) {
            worker = _this.worker(worker.id);
            return _this.emit("listening", worker, address);
          });
          cluster.on("disconnect", function(worker) {
            worker = _this.worker(worker.id);
            return _this.emit("disconnect", worker);
          });
          cluster.on("exit", function(worker, code, signal) {
            worker = _this.worker(worker.id);
            _this.emit("exit", worker, code, signal);
            return _this.killed(worker);
          });
        }
        this.registered = true;
        return this;
      }
    });

    __define("worker", {
      value: function(id) {
        var worker, _i, _len, _ref;
        if (id) {
          _ref = this.workers;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            worker = _ref[_i];
            if ((worker != null ? worker.id : void 0) === id) {
              return worker;
            }
          }
        }
        return null;
      }
    });

    __define("maintenance", {
      value: function() {
        this.workers.forEach(function(worker) {
          if (worker.status === "dead") {
            return this.killed(worker);
          }
        });
        return this;
      }
    });

    __define("cleanup", {
      value: function(id) {
        var worker, _i, _len, _ref;
        if (id) {
          _ref = this.workers;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            worker = _ref[_i];
            if ((worker != null ? worker.id : void 0) === id) {
              this.workers.splice(_i, 1);
            }
          }
        }
        return this;
      }
    });

    __define("killed", {
      value: function(worker) {
        if (Date.now() - this.startup < 20000) {
          if (++this.__killed === 20) {
            console.error("\nDetected over 20 worker deaths in the first 20 seconds of life,\nthere is most likely a serious issue with your server.\n\nAborting!\n");
            return process.exit(1);
          }
        }
        this.cleanup(worker.id);
        switch (this.state) {
          case 'graceful':
            break;
          case 'forceful':
            --this.pending || process.nextTick(process.exit);
            break;
          default:
            this.increase();
        }
        return this;
      }
    });

    return Master;

  }).call(this, EventEmitter);

}).call(this);
