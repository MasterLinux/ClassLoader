part of apetheory.class_loader;

/// Representation of an instance member
abstract class InstanceMember {
  final InstanceMirror owner;
  MetadataCollection _metadata;
  DeclarationMirror _mirror;

  /// Gets the metadata of the instance member
  MetadataCollection get metadata => _metadata;

  /// Gets the mirror of the instance member
  DeclarationMirror get mirror => _mirror;

  /// Gets the name of the instance member
  final Symbol name;

  InstanceMember(this.name, this.owner) {
    _mirror = owner.type.instanceMembers[name];
    _metadata = new MetadataCollection(mirror);
  }

  /// Returns true if the [InstanceMember] is annotated with
  /// the metadata annotation with the given [name]
  bool hasMetadata(Symbol name) => this[name] != null;

  /// Returns the first occurrence of the `metadata annotation` with the given [annotationName]
  /// or null if the instance member is not annotated with that annotation
  operator [](Symbol annotationName) {
    var meta = metadata.firstWhere((name, annotation) {
      return name == annotationName;
    }, orElse: () => null);

    return meta != null ? meta.reflectee : null;
  }
}

class Method extends InstanceMember {

  /// Returns true if method is abstract
  bool get isAbstract => _methodMirror.isAbstract;

  /// Initializes the method
  Method(Symbol name, InstanceMirror owner) : super(name, owner);

  /// Invokes the method
  void invoke([List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    positionalArguments = positionalArguments != null ? positionalArguments : [];
    namedArguments = namedArguments != null ? namedArguments : {};

    owner.invoke(name, positionalArguments, namedArguments);
  }
}

class Getter extends InstanceMember {

  /// Initializes the field
  Getter(Symbol name, InstanceMirror owner) : super(name, owner);

  /// Gets the value
  Object get() => owner.getField(name).reflectee;
}

class Setter extends InstanceMember {

  /// Initializes the field
  Setter(Symbol name, InstanceMirror owner) : super(name, owner);

  /// Sets the given [value]
  set(Object value) => owner.setField(name, value).reflectee;
}

class Field extends InstanceMember {

  Field(Symbol name, InstanceMirror owner) : super(util.createInstanceMemberName(name), owner) {
    // TODO: refactor field class to avoid multiple instantiation of _metadata
    var field = owner.type.declarations[name];

    if(field is VariableMirror) {
      _metadata = new MetadataCollection(field);
    }
  }

  /// Gets the value
  Object get() => owner.getField(name).reflectee;

  /// Sets the given [value]
  set(Object value) => owner.setField(name, value).reflectee;

  bool equals(Field other) { // TODO
    return name == util.createInstanceMemberName(other.name);
  }
}

