#rint.js
##define() and extend()
###Object.define()
Create properties and methods to it's prototype.
###Object.extend()
Create properties and methods to it.
###Object.combine(object...)
Combine object and return new object.

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
###function.startAfter(time)
###function.startAfter(time, callback)
`1sec` == `1000ms` == `1000`
###function.stopAfter()
###function.stopAfter(id)

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

##Date
###Date.mask
- normal: "ddd mmm dd yyyy HH:MM:ss"
- shortDate: "m/d/yy"
- mediumDate: "mmm d, yyyy"
- longDate: "mmmm d, yyyy"
- fullDate: "dddd, mmmm d, yyyy"
- shortTime: "h:MM TT"
- mediumTime: "h:MM:ss TT"
- longTime: "h:MM:ss TT Z"
- isoDate: "yyyy-mm-dd"
- isoTime: "HH:MM:ss"
- isoDateTime: "yyyy-mm-dd'T'HH:MM:ss"

###date.format(format, isUTC)

##Rint, rint, R, r
###r.global
if node.js => global
if browser => window
###r.sys
if node.js => process.env.os
if browser => `internet explorer`, `chrome`, `safari`, `firefox`, `opera`
###r.isNode()
###r.isBrowser()
###r.isInternetExplorer()
###r.isIE()
###r.isChrome()
###r.isSafari()
###r.isFirefox()
###r.isFF()
###r.isOpera()

##Other
###log()
same with `console.log()`
