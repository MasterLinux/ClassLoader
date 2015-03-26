part of apetheory.class_loader;

/// Representation of an instance member
abstract class InstanceMember<T extends DeclarationMirror> {
  final InstanceMirror owner;
  MetadataCollection _metadata;

  /// Gets the metadata of the instance member
  MetadataCollection get metadata => _metadata;

  /// Gets the mirror of the instance member
  final T mirror;

  /// Gets the name of the instance member
  final Symbol name;

  /// Initializes the instance member
  InstanceMember(this.name, this.mirror, this.owner) {
    _metadata = new MetadataCollection(mirror);
  }

  /// Returns true if the [InstanceMember] is annotated with
  /// the metadata annotation with the given [name]
  bool hasMetadata(Symbol name) => this[name] != null;

  /// Returns the first occurrence of the `metadata annotation` with the given [annotationName]
  /// or null if the instance member is not annotated with that annotation
  operator [](Symbol annotationName) {
    return metadata.firstWhere((name, annotation) {
      return name == annotationName;
    }, orElse: () => null);
  }
}

/// Representation of a method.
///
/// Example:
///   // method in reflected class
///   bool isSame(int x, int y) {
///     return x == y;
///   }
///
///   // invoke method
///   var isSame = classLoader.methods[#isSame].invoke([2, 3]);
///
class Method extends InstanceMember<MethodMirror> {

  /// Returns true if method is abstract
  bool get isAbstract => mirror.isAbstract;

  /// Initializes the method
  Method(Symbol name, MethodMirror mirror, InstanceMirror owner) : super(name, mirror, owner);

  /// Invokes the method
  dynamic invoke([List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    positionalArguments = positionalArguments != null ? positionalArguments : [];
    namedArguments = namedArguments != null ? namedArguments : {};

    return owner.invoke(name, positionalArguments, namedArguments).reflectee;
  }
}

/// Representation of a getter.
///
/// Example:
///   // getter in reflected class
///   String get title => "title";
///
///   // get the value of this getter
///   var getterValue = classLoader.getter[#title].get();
///
class Getter extends InstanceMember<MethodMirror> {

  /// Initializes the getter
  Getter(Symbol name, MethodMirror mirror, InstanceMirror owner) : super(name, mirror, owner);

  /// Gets the value
  Object get() => owner.getField(name).reflectee;
}

/// Representation of a setter.
///
/// Example:
///   // setter in reflected class
///   set title(String t) => _title = t;
///
///   // set a new value
///   classLoader.setter[#title].set("new title");
///
class Setter extends InstanceMember<MethodMirror> {

  /// Initializes the setter
  Setter(Symbol name, MethodMirror mirror, InstanceMirror owner) : super(util.createInstanceMemberName(name), mirror, owner);

  /// Sets the given [value]
  set(Object value) => owner.setField(name, value).reflectee;
}

/// Representation of a field. A field has a getter and a setter.
/// These are synthetic and can be accessed by using [Field.get()]
/// and [Field.set()].
///
/// Example:
///   // field in reflected class
///   int length = 2;
///
///   // get the value
///   var len = classLoader.fields[#length].get();
///
///   // set a new value
///   classLoader.fields[#length].set(42);
///
class Field extends InstanceMember<VariableMirror> {

  /// Initializes the field
  Field(Symbol name, VariableMirror mirror, InstanceMirror owner) : super(name, mirror, owner);

  /// Gets the value
  Object get() => owner.getField(name).reflectee;

  /// Sets the given [value]
  set(Object value) => owner.setField(name, value).reflectee;
}

