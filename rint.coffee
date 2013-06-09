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

String.define
  type: () ->
    return "string"
  startWith: (string) ->
    return @indexOf(string) is 0
  endWith: (string) ->
    return @lastIndexOf(string) is @length - 1
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

Function.define
  type: () ->
    return "function"
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