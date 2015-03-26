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

class Method extends InstanceMember<MethodMirror> {

  /// Returns true if method is abstract
  bool get isAbstract => _methodMirror.isAbstract;

  /// Initializes the method
  Method(Symbol name, MethodMirror mirror, InstanceMirror owner) : super(name, mirror, owner);

  /// Invokes the method
  dynamic invoke([List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    positionalArguments = positionalArguments != null ? positionalArguments : [];
    namedArguments = namedArguments != null ? namedArguments : {};

    return owner.invoke(name, positionalArguments, namedArguments).reflectee;
  }
}

class Getter extends InstanceMember<MethodMirror> {

  /// Initializes the field
  Getter(Symbol name, MethodMirror mirror, InstanceMirror owner) : super(name, mirror, owner);

  /// Gets the value
  Object get() => owner.getField(name).reflectee;
}

class Setter extends InstanceMember<MethodMirror> {

  /// Initializes the field
  Setter(Symbol name, MethodMirror mirror, InstanceMirror owner) : super(util.createInstanceMemberName(name), mirror, owner);

  /// Sets the given [value]
  set(Object value) => owner.setField(name, value).reflectee;
}

class Field extends InstanceMember<VariableMirror> {

  Field(Symbol name, VariableMirror mirror, InstanceMirror owner) : super(name, mirror, owner);

  /// Gets the value
  Object get() => owner.getField(name).reflectee;

  /// Sets the given [value]
  set(Object value) => owner.setField(name, value).reflectee;
}

