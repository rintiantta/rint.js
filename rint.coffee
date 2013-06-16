Object.defineProperties Object.prototype,
  define:
    value: (object) ->
      for key, item of object
        Object.defineProperty @prototype, key,
          value: item
  extend:
    value: (object) ->
      for key, item of object
        Object.defineProperty @, key,
          value: item
  combine:
    value: (objects) ->
      output = {}
      objects.forEach () ->
        for key, item of objects
          output[key] = item
      return output

#  ____  _     _           _   
# / __ \| |   (_)         | |  
#| |  | | |__  _  ___  ___| |_ 
#| |  | | '_ \| |/ _ \/ __| __|
#| |__| | |_) | |  __/ (__| |_ 
# \____/|_.__/| |\___|\___|\__|
#            _/ |              
#           |__/               
Object.define
  type: () ->
    return "object"
  size: () ->
    output = 0
    for key, object of @
      output += 1
    return output
  toArray: (key) ->
    output = []
    if key
      for name, item of @
        data = {}
        data[key] = name
        data.value = item
        output.push(data)
    else
      for name, item of @
        output.push(item)
    return output

#  _____ _        _             
# / ____| |      (_)            
#| (___ | |_ _ __ _ _ __   __ _ 
# \___ \| __| '__| | '_ \ / _` |
# ____) | |_| |  | | | | | (_| |
#|_____/ \__|_|  |_|_| |_|\__, |
#                          __/ |
#                         |___/ 
String.define
  type: () ->
    return "string"
  startWith: (string) ->
    return @indexOf(string) is 0
  endWith: (string) ->
    return @lastIndexOf(string) is (@length - string.length)
  contain: (string) ->
    return @indexOf(string) isnt -1
  notContain: (string) ->
    return not @contain(string)
  containAll: (array) ->
    for item in array
      return false if @notContain(item)
    return true
  containSome: (array) ->
    for item in array
      return true if @contain(item)
  eval: () ->
    return eval(@)
  empty: () ->
    return Boolean(this.length)
  notEmpty: () ->
    return not @empty()
  toNumber: () ->
    return Number(@)

String.extend
  nothing: ""
# ____              _                  
#|  _ \            | |                 
#| |_) | ___   ___ | | ___  __ _ _ __  
#|  _ < / _ \ / _ \| |/ _ \/ _` | '_ \ 
#| |_) | (_) | (_) | |  __/ (_| | | | |
#|____/ \___/ \___/|_|\___|\__,_|_| |_|                                  
Boolean.define
  type: () ->
    return "boolean"
  
# _   _                 _               
#| \ | |               | |              
#|  \| |_   _ _ __ ___ | |__   ___ _ __ 
#| . ` | | | | '_ ` _ \| '_ \ / _ \ '__|
#| |\  | |_| | | | | | | |_) |  __/ |   
#|_| \_|\__,_|_| |_| |_|_.__/ \___|_|   
Number.define
  type: () ->
    return "number"
  isFinite: () ->
    return isFinite(@)
  floor: () ->
    return Math.floor(@)
  ceil: () ->
    return Math.ceil(@)
  round: () ->
    return Math.round(@)
  pad: (length) ->
    value = String(@)
    length = if value.length > length then value.length else length
    while value.length < length
      value = "0#{value}"
    return value
Number.extend
  random: (a, b) ->
    if b
      return Math.floor(Rint.randomFloat(a, b))
    else
      return Math.floor(Rint.randomFloat(a))
  randomFloat: (a, b) ->
    if b
      return (Math.random() * (b - a)) + a
    else
      return Math.random() * a

# ______                _   _             
#|  ____|              | | (_)            
#| |__ _   _ _ __   ___| |_ _  ___  _ __  
#|  __| | | | '_ \ / __| __| |/ _ \| '_ \ 
#| |  | |_| | | | | (__| |_| | (_) | | | |
#|_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|
Function.define
  type: () ->
    return "function"
  startAfter: (time, callback) ->
    ms = 0
    if time.type() is "string"
      if time.endWith("s") or time.endWith("sec")
          ms = parseInt(time) * 1000
      else if time.endWith("ms")
          ms = parseInt(time)
      else
        throw "time string error"
    else if time.type() is "number"
      ms = time
    @timerId = [] if not @timerId
    @timerId.push(setTimeout(() =>
      @()
      callback() if callback
    , ms))
  stopAfter: () ->
    @timerId.forEach (id) ->
      clearTimeout(id)
Function.extend
  nothing: () ->
  parallel: (tasks, callback) ->
    completed = 0
    if tasks.type() is "object"
      results = {}
    else if tasks.type() is "array"
      results = []
    else
      throw "Function.parallel()'s parameter must be 'array' or 'object'."
    # Function Call
    for key, item of tasks
      (() -> 
        item (result) ->
          completed += 1
          results[key] = result
          if completed is tasks.size()
            callback(results) if callback
      )(key)
    return
  sequence: (tasks, callback) ->
    completed = 0
    if tasks.type() is "object"
      results = {}
    else if tasks.type() is "array"
      results = []
    else
      throw "Function.parallel()'s parameter must be 'array' or 'object'."
    # Function Call
    tasks = tasks.toArray('key')
    recursion = (task) ->
      task.value (result) ->
        results[task.key] = result
        completed += 1
        if completed is tasks.size()
          callback(results) if callback
        else
          recursion tasks[completed]
    recursion tasks[completed]
    return
  next: (callback) ->
    setTimeout(callback, 0)

#    /\                         
#   /  \   _ __ _ __ __ _ _   _ 
#  / /\ \ | '__| '__/ _` | | | |
# / ____ \| |  | | | (_| | |_| |
#/_/    \_\_|  |_|  \__,_|\__, |
#                          __/ |
#                         |___/ 
Array.define
  type: () ->
    return "array"
  empty: () ->
    return Boolean(this.length)
  notEmpty: () ->
    return not @empty()
  random: () ->
    return @[Rint.random(0, @lastIndex() - 1)] if @notEmpty()
  remove: (item) ->
    @splice(@indexOf(item), 1)
  removeAt: (index) ->
    @splice index, 1
  first: () ->
    return @[0] if @[0]
  last: () ->
    return @[@lastIndex()] if @notEmpty()
  lastIndex: () ->
    return this.length - 1 if @notEmpty()
  compact: () ->
    return @filter (item) ->
      return Boolean(item)
  contain: (any) ->
    for i, item in this
      if item is any
        return true
  size: () ->
    return @length
Array.extend
  create: () ->
    output = []
    for item in arguments
      output.push(item)
    return output
  union: () ->
    output = []
    for array in arguments
      for item in array
        output.push item
    return output
#  _____        _       
# |  __ \      | |      
# | |  | | __ _| |_ ___ 
# | |  | |/ _` | __/ _ \
# | |__| | (_| | ||  __/
# |_____/ \__,_|\__\___|                   
Date.define
  format: (mask = Date.mask.normal, utc) ->
    _ = if utc then "getUTC" else "get"
    d = @[_ + "Date"]()
    D = @[_ + "Day"]()
    m = @[_ + "Month"]() + 1
    y = @[_ + "FullYear"]()
    H = @[_ + "Hours"]()
    M = @[_ + "Minutes"]()
    s = @[_ + "Seconds"]()
    L = @[_ + "Milliseconds"]()
    o = if utc then 0 else @.getTimezoneOffset()
    if o.type() isnt "number"
      o = o[0]
    dayNames = [
      "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
      "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    ]
    monthNames = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
      "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
    ]
    flags = 
      d: d
      dd: d.pad(2)
      ddd: dayNames[D]
      dddd: dayNames[D + 7]
      m: m
      mm: m.pad(2)
      mmm: monthNames[m - 1]
      mmmm: monthNames[m + 11]
      yy: y.toString().slice(@)
      yyyy: y
      h: H % 12 or 12
      hh: (H % 12 or 12).pad(2)
      H: H
      HH: H.pad(2)
      M: M
      MM: M.pad(2)
      s: s
      ss: s.pad(2)
      l: L.pad(3)
      L: if L > 99 then Math.round(L / 10) else L
      t: if H < 12 then "a" else "p"
      tt: if H < 12 then "am" else "pm"
      T: if H < 12 then "A" else "P"
      TT: if H < 12 then "AM" else "PM"
      Z: if utc then "UTC" else (String(@).match(/\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g) or [""]).pop().replace(/[^-+\dA-Z]/g, "")
      o: (if o > 0 then "-" else "+") + (Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60).pad(4)
      S: ["th", "st", "nd", "rd"][if d % 10 > 3 then 0 else (d % 100 - d % 10 != 10) * d % 10]
    return mask.replace /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g, ($0) ->
      return if flags then flags[$0] else $0.slice(1, $0.length - 1)
Date.extend
  mask:
    normal: "ddd mmm dd yyyy HH:MM:ss"
    shortDate: "m/d/yy",
    mediumDate: "mmm d, yyyy",
    longDate: "mmmm d, yyyy",
  	fullDate: "dddd, mmmm d, yyyy",
  	shortTime: "h:MM TT",
  	mediumTime: "h:MM:ss TT",
  	longTime: "h:MM:ss TT Z",
  	isoDate: "yyyy-mm-dd",
  	isoTime: "HH:MM:ss",
  	isoDateTime: "yyyy-mm-dd'T'HH:MM:ss",

# _____  _       _   
#|  __ \(_)     | |  
#| |__) |_ _ __ | |_ 
#|  _  /| | '_ \| __|
#| | \ \| | | | | |_ 
#|_|  \_\_|_| |_|\__|
r = R = rint = Rint = {}
Rint.global = null

window = window or null
Rint.env = if window then "browser" else "node"
Rint.sys = (() ->
  if Rint.env is "node"
    Rint.global = global
    return process.env.os
  else
    Rint.global = window
    if navigator.userAgent.contain("MSIE")
      return "internet explorer"
    else if window.chrome
      return "chrome"
    else if  navigator.userAgent.contain("Safari")
      return "safari"
    else if  navigator.userAgent.contain("Firefox")
      return "firefox"
    else if  navigator.userAgent.contain("Opera")
      return "opera"
)()
Rint.isNode = () ->
  return if Rint.env is "node" then true else false
Rint.isBrowser = () ->
  return !Rint.isNode()
Rint.isInternetExplorer = () ->
  return if Rint.sys is "internet explorer" then true else false
Rint.isIE = () ->
  return Rint.isInternetExplorer()
Rint.isChrome = () ->
  return if Rint.sys is "chrome" then true else false
Rint.isSafari = () ->
  return if Rint.sys is "safari" then true else false
Rint.isFirefox = () ->
  return if Rint.sys is "firefox" then true else false
Rint.isFF = () ->
  return Rint.isFirefox()
Rint.isOpera = () ->    
  return if Rint.sys is "opera" then true else false

#   ____  _   _               
#  / __ \| | | |              
# | |  | | |_| |__   ___ _ __ 
# | |  | | __| '_ \ / _ \ '__|
# | |__| | |_| | | |  __/ |   
#  \____/ \__|_| |_|\___|_|   
log = console.log
