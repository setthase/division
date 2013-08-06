(function() {
  var Time, color, fs, glue, logger, mode, modes, offset,
    __slice = [].slice;

  fs = require('fs');

  glue = function() {
    var elements;
    elements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return elements.join('');
  };

  offset = function(value, sign, length) {
    var base;
    base = new Array(length + 1).join(sign);
    return (base + value).slice(-length);
  };

  Time = function() {
    var d, day, hour, min, month, ms, sec, year;
    d = new Date();
    day = d.getDate();
    month = 1 + d.getMonth();
    year = d.getFullYear();
    hour = d.getHours();
    min = d.getMinutes();
    sec = d.getSeconds();
    ms = d.getMilliseconds();
    return glue(offset(day, 0, 2), "-", offset(month, 0, 2), "-", year, " ", offset(hour, 0, 2), ":", offset(min, 0, 2), ":", offset(sec, 0, 2), ":", offset(ms, 0, 3));
  };

  module.exports = logger = {};

  modes = {
    error: 31,
    warn: 33,
    info: 36,
    debug: 90
  };

  for (mode in modes) {
    color = modes[mode];
    logger[mode] = (function(color, mode) {
      return function(message, options) {
        var label, time;
        time = Time();
        mode = offset(mode, ' ', 8);
        label = glue(mode, ' [', time, '] ');
        label = glue("\x1b[", color, "m", label, "\x1b[0m");
        message = glue(label, message, "\n");
        if (options.file) {
          fs.writeFile(options.file, message, {
            flag: 'a',
            encoding: 'utf8'
          });
        }
        if (options.console === true) {
          return process.stderr.write(message);
        }
      };
    })(color, mode);
  }

}).call(this);
