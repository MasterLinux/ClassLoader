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
There are two ways to load a specific class. So you are able to load a class by its library and name. Let's say we have the following class

```dart
library player.data;

class AudioFile { }
```

Then you can load this class like this

```dart
import 'data/audio_file.dart';

main() async {
    var loader = new ClassLoader<AudioFile>(#player.data, #AudioFile);
    await loader.load();
}
```

Instead of using `#player.data` it is also possible to use `new Symbol('player.data')`. Another way to load a class is by using an instance of it which is useful whenever you need to access the metadata of an already instantiated class.

```dart
import 'data/audio_file.dart';

main() async {
    var audioFile = new AudioFile();
    var loader = new ClassLoader<AudioFile>.fromInstance(audioFile);
    await loader.load();
}
```

###Set or get value (getter & setter)

###Set or get value (field)
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