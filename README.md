# ClassLoader

[![Build Status](https://drone.io/github.com/MasterLinux/ClassLoader/status.png)](https://drone.io/github.com/MasterLinux/ClassLoader/latest)

#Milestones
###0.0.3
* method, field and metadata optimizations

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

Private class members are hidden by default. Whenever you need to access private members use the `excludePrivateMembers` parameter when calling `load()`.

```dart
await loader.load(excludePrivateMembers: false);
var pm = loader.fields[#_privateMember];
```

###Set or get value (field)
To access a field like `fileName` in the following code snippet

```dart
class AudioFile { 
    String fileName = "example"; 
}
```

you can use `loader.fields` which is a collection that contains all fields of the reflected class.

```dart
// set value
loader.fields[#fileName].set('newFile');

// get value
var name = loader.fields[#fileName].get();
```

###Set or get value (getter & setter)
Whenever you need to access a getter or setter use `loader.getter` and `loader.setter`.

```dart
class AudioFile { 
    String _composer;
        
    String get composer => _composer; 
    set composer(String c) => _composer = c; 
}
```

```dart
// set value
loader.setter[#composer].set('example composer');

// get value
var composer = loader.getter[#composer].get();
```

A setter can also be accessed by using a setter name `composer=`. In this case you have to use `new Symbol()` because the `=` seems not to be allowed when using the `#` syntax.

```dart
// set value
loader.setter[new Symbol('composer=')].set('example composer');
```

###Invoke method
You can also invoke methods. It is possible to pass positional and named parameter. To access methods you have to use the `methods` collection provided by the loader instance.

```dart
class AudioFile { 
    void mute() {}
    AudioFile convert({format: 'mp3'}) {}
    bool incrementVolumeBy(int i) {}
}
```

```dart
// invoke without parameter
loader.methods[#mute].invoke();

// invoke with positional parameter
var isIncremented = loader.methods[#incrementVolumeBy].invoke([10]);

// invoke with named parameter
loader.methods[#convert].invoke([], {
    #format: 'flac'
});
```

###Metadata 
Another useful functionality is the possibility to access the metadata of a class or to query class members by annotations. 
   
```dart
@TrackAuthor('Author Name')
class AudioFile {
  String _fileName;
  
  @AudioVolume
  int volume = 100;

  @FileName
  String get fileName => _fileName;

  @FileName
  set fileName(String name) => _fileName = name;

  @MuteMethod
  void mute() {
    // does nothing
  }
}
```

```dart
// Check whether class has specific annotation 
var hasAuthorAnnotation = loader.metadata.contains(#TrackAuthor);

// Get specific annotation
var authorAnnotation = loader.metadata.firstWhere((name, meta) => name == #TrackAuthor && (meta as TrackAuthor).name == 'Author Name', orElse: () => null);

if(authorAnnotation != null) {
    print((authorAnnotation as TrackAuthor).name);
}


// Get first occurrence of method with specific annotation
var muteMethod = loader.methods.firstWhereMetadata((name, meta) => name == #MuteMethod, orElse: () => null);

if(muteMethod != null) {
    muteMethod.invoke();
}


// Get all setter and getter with specific annotation
var fileNameSetter = loader.setter.whereMetadata((name, annotation) => name == #FileName);
var fileNameGetter = loader.getter.whereMetadata((name, annotation) => name == #FileName);

if(fileNameSetter.isNotEmpty()) {
    fileNameSetter.first.set('test_file_name');
}


// Get first occurrence of field with specific annotation 
var volumeField = loader.fields.firstWhereMetadata((name, meta) => name == #AudioVolume, orElse: () => null);

if(volumeField != null) {
    volumeField.set(50);
}
```
