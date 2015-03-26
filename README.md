# ClassLoader

[![Build Status](https://drone.io/github.com/MasterLinux/ClassLoader/status.png)](https://drone.io/github.com/MasterLinux/ClassLoader/latest)

#Milestones
###0.0.2
* initial metadata implementation
* more testing
 * unit tests & performance benchmarking

###0.0.3
* method, field and metadata optimizations like
 * access to all available info

###0.0.4
* class schema for validation
 * similar to JSON schema?

###0.0.5
* performance optimizations

#How to use
###Load class
```dart
var loader = new ClassLoader(new Symbol('my.lib'), new Symbol('ClassName'));
```

###Set or get value (getter & setter)
```dart
// set value
loader.fields[new Symbol('setterName')].set('val');

// get value
var val = loader.fields[new Symbol('setterName')].get();
```

###Invoke method
```dart
// invoke without parameter
loader.methods[new Symbol('methodName')].invoke();

// invoke with positional parameter
loader.methods[new Symbol('methodName')].invoke(['val_1', 2]);

// invoke with named parameter
loader.methods[new Symbol('methodName')].invoke([], {
    #params: []
});
```