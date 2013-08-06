(function() {
  var EventEmitter, Worker, cluster,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  cluster = require('cluster');

  EventEmitter = require('events').EventEmitter;

  module.exports = Worker = (function(_super) {
    var __define,
      _this = this;

    __extends(Worker, _super);

    function Worker() {
      var __define;
      var __define,
        _this = this;
      __define = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return Object.defineProperty.apply(null, [].concat(_this, args));
      };
      __define("instance", {
        value: cluster.fork()
      });
      __define("id", {
        enumerable: true,
        value: this.instance.id
      });
      __define("pid", {
        enumerable: true,
        value: this.instance.process.pid
      });
      __define("startup", {
        enumerable: true,
        value: Date.now()
      });
      __define("status", {
        enumerable: true,
        set: (function() {}),
        get: function() {
          return this.instance.state;
        }
      });
    }

    __define = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return Object.defineProperty.apply(null, [].concat(Worker.prototype, args));
    };

    __define("close", {
      enumerable: true,
      value: function(timeout) {
        var _this = this;
        if (timeout == null) {
          timeout = 2000;
        }
        this.instance.disconnect();
        setTimeout(function() {
          if (_this.status === !"dead") {
            return _this.kill("SIGKILL");
          }
        }, timeout);
        return this;
      }
    });

    __define("kill", {
      enumerable: true,
      value: function(signal) {
        var _this = this;
        if (signal == null) {
          signal = "SIGTERM";
        }
        process.nextTick(function() {
          return _this.instance.kill(signal);
        });
        return this;
      }
    });

    __define("publish", {
      enumerable: true,
      value: function() {
        var event, parameters;
        event = arguments[0], parameters = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        if (parameters.length === 1) {
          parameters = parameters[0];
        }
        this.instance.send({
          event: event,
          parameters: parameters
        });
        return this;
      }
    });

    return Worker;

  }).call(this, EventEmitter);

}).call(this);
