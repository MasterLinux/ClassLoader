//part of apetheory.class_loader;

/// Representation of an instance member
abstract class InstanceMember {

  /// Gets the metadata of the instance member
  MetadataCollection get metadata;

  /// Gets the name of the instance member
  Symbol get name;

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

abstract class Collection<T> {

  T operator [](Symbol name) => firstWhereName(name);

  /// Returns each object that satisfies the given [test]
  Iterable<T> where(bool test(Symbol name, T obj));

  /// Returns the first object of type [T] that satisfies the given [test]
  T firstWhere(bool test(Symbol name, T obj), { T orElse() });

  /// Returns true if the collection contains an object with the given [name]
  bool contains(Symbol name);

  Iterable<T> whereName(Symbol name) {
    return where((objName, obj) => objName == name);
  }

  T firstWhereName(Symbol name, { T orElse() }) {
    return firstWhere((objName, obj) => objName == name, orElse: orElse);
  }
}

abstract class InstanceMemberCollection<T extends InstanceMember> extends Collection<T> {
  Map<Symbol, T> entries = new Map<Symbol, T>();

  operator []=(Symbol name, T obj) => entries[name] = obj;

  @override
  bool contains(Symbol name) => entries.containsKey(name);

  T firstWhereMetadata(bool test(Symbol name, dynamic annotation), { T orElse() }) {
    return firstWhere((name, obj) => obj.metadata.where(test).isNotEmpty, orElse: orElse);
  }

  Iterable<T> whereMetadata(bool test(Symbol name, dynamic annotation)) {
    return where((name, obj) => obj.metadata.where(test).isNotEmpty);
  }
}

class MetadataCollection extends Collection<dynamic> {
  DeclarationMirror _mirror;

  MetadataCollection(DeclarationMirror mirror) {
    _mirror = mirror;
  }

  @override
  bool contains(Symbol name) => firstWhereName(name, orElse: () => null) != null;

  @override
  Iterable<dynamic> where(bool test(Symbol name, dynamic annotation)) {
    var metadata = new List();

    _mirror.metadata.forEach((meta) {
      if(test(meta.type.simpleName, meta.reflectee)) {
        metadata.add(meta.reflectee);
      }
    });

    return metadata;
  }

  @override
  dynamic firstWhere(bool test(Symbol name, dynamic annotation), { dynamic orElse() }) {
    var metadata = _mirror.metadata.firstWhere((meta) {
      return test(meta.type.simpleName, meta.reflectee);
    }, orElse: orElse);

    return metadata != null ? metadata.reflectee : null;
  }
}
