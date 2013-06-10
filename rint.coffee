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
    output = true
    for item in array
      break if @notContain(item)
    return output
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

# ____              _                  
#|  _ \            | |                 
#| |_) | ___   ___ | | ___  __ _ _ __  
#|  _ < / _ \ / _ \| |/ _ \/ _` | '_ \ 
#| |_) | (_) | (_) | |  __/ (_| | | | |
#|____/ \___/ \___/|_|\___|\__,_|_| |_|                                  
Boolean.define
  type: () ->
    return "boolean"
  
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

# _   _                 _               
#| \ | |               | |              
#|  \| |_   _ _ __ ___ | |__   ___ _ __ 
#| . ` | | | | '_ ` _ \| '_ \ / _ \ '__|
#| |\  | |_| | | | | | | |_) |  __/ |   
#|_| \_|\__,_|_| |_| |_|_.__/ \___|_|   
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

# _____  _       _   
#|  __ \(_)     | |  
#| |__) |_ _ __ | |_ 
#|  _  /| | '_ \| __|
#| | \ \| | | | | |_ 
#|_|  \_\_|_| |_|\__|
r = R = rint = Rint = {}
Rint.global = null
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
    