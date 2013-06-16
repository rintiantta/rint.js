var R, Rint, log, r, rint, window;

Object.defineProperties(Object.prototype, {
  define: {
    value: function(object) {
      var item, key, _results;
      _results = [];
      for (key in object) {
        item = object[key];
        _results.push(Object.defineProperty(this.prototype, key, {
          value: item
        }));
      }
      return _results;
    }
  },
  extend: {
    value: function(object) {
      var item, key, _results;
      _results = [];
      for (key in object) {
        item = object[key];
        _results.push(Object.defineProperty(this, key, {
          value: item
        }));
      }
      return _results;
    }
  },
  combine: {
    value: function(objects) {
      var output;
      output = {};
      objects.forEach(function() {
        var item, key, _results;
        _results = [];
        for (key in objects) {
          item = objects[key];
          _results.push(output[key] = item);
        }
        return _results;
      });
      return output;
    }
  }
});

Object.define({
  type: function() {
    return "object";
  },
  size: function() {
    var key, object, output;
    output = 0;
    for (key in this) {
      object = this[key];
      output += 1;
    }
    return output;
  },
  toArray: function(key) {
    var data, item, name, output;
    output = [];
    if (key) {
      for (name in this) {
        item = this[name];
        data = {};
        data[key] = name;
        data.value = item;
        output.push(data);
      }
    } else {
      for (name in this) {
        item = this[name];
        output.push(item);
      }
    }
    return output;
  }
});

String.define({
  type: function() {
    return "string";
  },
  startWith: function(string) {
    return this.indexOf(string) === 0;
  },
  endWith: function(string) {
    return this.lastIndexOf(string) === (this.length - string.length);
  },
  contain: function(string) {
    return this.indexOf(string) !== -1;
  },
  notContain: function(string) {
    return !this.contain(string);
  },
  containAll: function(array) {
    var item, _i, _len;
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      item = array[_i];
      if (this.notContain(item)) {
        return false;
      }
    }
    return true;
  },
  containSome: function(array) {
    var item, _i, _len;
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      item = array[_i];
      if (this.contain(item)) {
        return true;
      }
    }
  },
  "eval": function() {
    return eval(this);
  },
  empty: function() {
    return Boolean(this.length);
  },
  notEmpty: function() {
    return !this.empty();
  },
  toNumber: function() {
    return Number(this);
  }
});

String.extend({
  nothing: ""
});

Boolean.define({
  type: function() {
    return "boolean";
  }
});

Number.define({
  type: function() {
    return "number";
  },
  isFinite: function() {
    return isFinite(this);
  },
  floor: function() {
    return Math.floor(this);
  },
  ceil: function() {
    return Math.ceil(this);
  },
  round: function() {
    return Math.round(this);
  },
  pad: function(length) {
    var value;
    value = String(this);
    length = value.length > length ? value.length : length;
    while (value.length < length) {
      value = "0" + value;
    }
    return value;
  }
});

Number.extend({
  random: function(a, b) {
    if (b) {
      return Math.floor(Rint.randomFloat(a, b));
    } else {
      return Math.floor(Rint.randomFloat(a));
    }
  },
  randomFloat: function(a, b) {
    if (b) {
      return (Math.random() * (b - a)) + a;
    } else {
      return Math.random() * a;
    }
  }
});

Function.define({
  type: function() {
    return "function";
  },
  startAfter: function(time, callback) {
    var ms,
      _this = this;
    ms = 0;
    if (time.type() === "string") {
      if (time.endWith("s") || time.endWith("sec")) {
        ms = parseInt(time) * 1000;
      } else if (time.endWith("ms")) {
        ms = parseInt(time);
      } else {
        throw "time string error";
      }
    } else if (time.type() === "number") {
      ms = time;
    }
    if (!this.timerId) {
      this.timerId = [];
    }
    return this.timerId.push(setTimeout(function() {
      _this();
      if (callback) {
        return callback();
      }
    }, ms));
  },
  stopAfter: function() {
    return this.timerId.forEach(function(id) {
      return clearTimeout(id);
    });
  }
});

Function.extend({
  nothing: function() {},
  parallel: function(tasks, callback) {
    var completed, item, key, results, _fn;
    completed = 0;
    if (tasks.type() === "object") {
      results = {};
    } else if (tasks.type() === "array") {
      results = [];
    } else {
      throw "Function.parallel()'s parameter must be 'array' or 'object'.";
    }
    _fn = function() {
      return item(function(result) {
        completed += 1;
        results[key] = result;
        if (completed === tasks.size()) {
          if (callback) {
            return callback(results);
          }
        }
      });
    };
    for (key in tasks) {
      item = tasks[key];
      _fn(key);
    }
  },
  sequence: function(tasks, callback) {
    var completed, recursion, results;
    completed = 0;
    if (tasks.type() === "object") {
      results = {};
    } else if (tasks.type() === "array") {
      results = [];
    } else {
      throw "Function.parallel()'s parameter must be 'array' or 'object'.";
    }
    tasks = tasks.toArray('key');
    recursion = function(task) {
      return task.value(function(result) {
        results[task.key] = result;
        completed += 1;
        if (completed === tasks.size()) {
          if (callback) {
            return callback(results);
          }
        } else {
          return recursion(tasks[completed]);
        }
      });
    };
    recursion(tasks[completed]);
  },
  next: function(callback) {
    return setTimeout(callback, 0);
  }
});

Array.define({
  type: function() {
    return "array";
  },
  empty: function() {
    return Boolean(this.length);
  },
  notEmpty: function() {
    return !this.empty();
  },
  random: function() {
    if (this.notEmpty()) {
      return this[Rint.random(0, this.lastIndex() - 1)];
    }
  },
  remove: function(item) {
    return this.splice(this.indexOf(item), 1);
  },
  removeAt: function(index) {
    return this.splice(index, 1);
  },
  first: function() {
    if (this[0]) {
      return this[0];
    }
  },
  last: function() {
    if (this.notEmpty()) {
      return this[this.lastIndex()];
    }
  },
  lastIndex: function() {
    if (this.notEmpty()) {
      return this.length - 1;
    }
  },
  compact: function() {
    return this.filter(function(item) {
      return Boolean(item);
    });
  },
  contain: function(any) {
    var i, item, _i, _len;
    for (item = _i = 0, _len = this.length; _i < _len; item = ++_i) {
      i = this[item];
      if (item === any) {
        return true;
      }
    }
  },
  size: function() {
    return this.length;
  }
});

Array.extend({
  create: function() {
    var item, output, _i, _len;
    output = [];
    for (_i = 0, _len = arguments.length; _i < _len; _i++) {
      item = arguments[_i];
      output.push(item);
    }
    return output;
  },
  union: function() {
    var array, item, output, _i, _j, _len, _len1;
    output = [];
    for (_i = 0, _len = arguments.length; _i < _len; _i++) {
      array = arguments[_i];
      for (_j = 0, _len1 = array.length; _j < _len1; _j++) {
        item = array[_j];
        output.push(item);
      }
    }
    return output;
  }
});

Date.define({
  format: function(mask, utc) {
    var D, H, L, M, d, dayNames, flags, m, monthNames, o, s, y, _;
    if (mask == null) {
      mask = Date.mask.normal;
    }
    _ = utc ? "getUTC" : "get";
    d = this[_ + "Date"]();
    D = this[_ + "Day"]();
    m = this[_ + "Month"]() + 1;
    y = this[_ + "FullYear"]();
    H = this[_ + "Hours"]();
    M = this[_ + "Minutes"]();
    s = this[_ + "Seconds"]();
    L = this[_ + "Milliseconds"]();
    o = utc ? 0 : this.getTimezoneOffset();
    if (o.type() !== "number") {
      o = o[0];
    }
    dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    flags = {
      d: d,
      dd: d.pad(2),
      ddd: dayNames[D],
      dddd: dayNames[D + 7],
      m: m,
      mm: m.pad(2),
      mmm: monthNames[m - 1],
      mmmm: monthNames[m + 11],
      yy: y.toString().slice(this),
      yyyy: y,
      h: H % 12 || 12,
      hh: (H % 12 || 12).pad(2),
      H: H,
      HH: H.pad(2),
      M: M,
      MM: M.pad(2),
      s: s,
      ss: s.pad(2),
      l: L.pad(3),
      L: L > 99 ? Math.round(L / 10) : L,
      t: H < 12 ? "a" : "p",
      tt: H < 12 ? "am" : "pm",
      T: H < 12 ? "A" : "P",
      TT: H < 12 ? "AM" : "PM",
      Z: utc ? "UTC" : (String(this).match(/\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g) || [""]).pop().replace(/[^-+\dA-Z]/g, ""),
      o: (o > 0 ? "-" : "+") + (Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60).pad(4),
      S: ["th", "st", "nd", "rd"][d % 10 > 3 ? 0 : (d % 100 - d % 10 !== 10) * d % 10]
    };
    return mask.replace(/d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g, function($0) {
      if (flags) {
        return flags[$0];
      } else {
        return $0.slice(1, $0.length - 1);
      }
    });
  }
});

Date.extend({
  mask: {
    normal: "ddd mmm dd yyyy HH:MM:ss",
    shortDate: "m/d/yy",
    mediumDate: "mmm d, yyyy",
    longDate: "mmmm d, yyyy",
    fullDate: "dddd, mmmm d, yyyy",
    shortTime: "h:MM TT",
    mediumTime: "h:MM:ss TT",
    longTime: "h:MM:ss TT Z",
    isoDate: "yyyy-mm-dd",
    isoTime: "HH:MM:ss",
    isoDateTime: "yyyy-mm-dd'T'HH:MM:ss"
  }
});

r = R = rint = Rint = {};

Rint.global = null;

window = window || null;

Rint.env = window ? "browser" : "node";

Rint.sys = (function() {
  if (Rint.env === "node") {
    Rint.global = global;
    return process.env.os;
  } else {
    Rint.global = window;
    if (navigator.userAgent.contain("MSIE")) {
      return "internet explorer";
    } else if (window.chrome) {
      return "chrome";
    } else if (navigator.userAgent.contain("Safari")) {
      return "safari";
    } else if (navigator.userAgent.contain("Firefox")) {
      return "firefox";
    } else if (navigator.userAgent.contain("Opera")) {
      return "opera";
    }
  }
})();

Rint.isNode = function() {
  if (Rint.env === "node") {
    return true;
  } else {
    return false;
  }
};

Rint.isBrowser = function() {
  return !Rint.isNode();
};

Rint.isInternetExplorer = function() {
  if (Rint.sys === "internet explorer") {
    return true;
  } else {
    return false;
  }
};

Rint.isIE = function() {
  return Rint.isInternetExplorer();
};

Rint.isChrome = function() {
  if (Rint.sys === "chrome") {
    return true;
  } else {
    return false;
  }
};

Rint.isSafari = function() {
  if (Rint.sys === "safari") {
    return true;
  } else {
    return false;
  }
};

Rint.isFirefox = function() {
  if (Rint.sys === "firefox") {
    return true;
  } else {
    return false;
  }
};

Rint.isFF = function() {
  return Rint.isFirefox();
};

Rint.isOpera = function() {
  if (Rint.sys === "opera") {
    return true;
  } else {
    return false;
  }
};

log = console.log;
