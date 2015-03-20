# ClassLoader

#How to use
###Load class
```dart
var loader = new ClassLoader(new Symbol('my.lib'), new Symbol('ClassName'));
```

###Set or get value (getter \& setter)
```dart
// set value
loader.fields[new Symbol('setterName')].set("val");

// get value
var val = loader.fields[new Symbol('setterName')].get();
```

###Invoke method
```dart
// invoke without parameter
loader.methods[new Symbol('methodName')].invoke();

// invoke with positional parameter
loader.methods[new Symbol('methodName')].invoke(["val_1", 2]);

// invoke with named parameter
loader.methods[new Symbol('methodName')].invoke([], {
    #params: []
});
```