#rint.js
##define() and extend()
###Object.define()
Create properties and methods to it's prototype.
###Object.extend()
Create properties and methods to it.

##Object
###object.type()
return "object"
###object.size()
###object.toArray(key)
```javascript
{
    a: 10,
    b: 20,
}.toArray() // [10, 20]

{
    a: 10,
    b: 20
}.toArray('key') // [{ key: "a", value: 10 }, { key: "b", value: 20 }]
```
##String
###string.type()
return "string"
###string.startWith(string)
###string.endWith(string)
###string.contain(string)
###string.notContain(string)
###string.containAll(array)
###string.containSome(array)
###string.eval()
###string.empty()
###string.notEmpty()
###string.toNumber()

##Boolean
###boolean.type()
return "boolean"

##Number
###Number.random(max)
###Number.random(min, max)
###Number.randomFloat(max)
###Number.randomFloat(min, max)
###number.type()
return "number"

##Function
###Function.nothing()
###Function.parallel(tasks, callback)
###Function.sequence(tasks, callback)
###function.type()
return "function"

##Array
###Array.create(any...)
###Array.union(array...)
###array.type()
return "array"
###array.empty()
###array.notEmpty()
###array.random()
###array.remove(item)
###array.removeAt(index)
###array.first()
###array.last()
###array.lastIndex()
###array.compact()
###array.contain(any)
###array.size()