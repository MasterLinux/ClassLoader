part of apetheory.class_loader;

abstract class Collection<T> {

  /// Returns the first result with the given [name]
  T operator [](Symbol name) => firstWhereName(name, orElse: () => null);

  /// Returns all results that satisfies the given [test]
  Iterable<T> where(bool test(Symbol name, T obj));

  /// Returns the first result that satisfies the given [test]
  T firstWhere(bool test(Symbol name, T obj), { T orElse() });

  /// Returns true if the collection contains an object with the given [name]
  bool contains(Symbol name);

  /// Returns all results with the given [name]
  Iterable<T> whereName(Symbol name) {
    return where((objName, obj) => objName == name);
  }

  /// Returns the first result with the given [name]
  T firstWhereName(Symbol name, { T orElse() }) {
    return firstWhere((objName, obj) => objName == name, orElse: orElse);
  }
}

class InstanceMemberCollection<T extends InstanceMember> extends Collection<T> {
  Map<Symbol, T> entries = new Map<Symbol, T>();

  operator []=(Symbol name, T obj) => entries[name] = obj;

  void add(T instanceMember) {
    this[instanceMember.name] = instanceMember;
  }

  @override
  bool contains(Symbol name) => entries.containsKey(name);

  @override
  T firstWhere(bool test(Symbol name, T instanceMember), { T orElse() }) {
    return entries.values.firstWhere((instanceMember) => test(instanceMember.name, instanceMember), orElse: orElse);
  }

  @override
  Iterable<T> where(bool test(Symbol name, T instanceMember)) {
    return entries.values.where((instanceMember) => test(instanceMember.name, instanceMember));
  }

  T firstWhereMetadata(bool test(Symbol name, dynamic annotation), { T orElse() }) {
    return firstWhere((name, instanceMember) => instanceMember.metadata.where(test).isNotEmpty, orElse: orElse);
  }

  Iterable<T> whereMetadata(bool test(Symbol name, dynamic annotation)) {
    return where((name, instanceMember) => instanceMember.metadata.where(test).isNotEmpty);
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

class MethodCollection extends InstanceMemberCollection<Method> {

  /// Invokes each method that satisfies the given [test]
  void invokeWhere(bool test(Symbol name, Method method), [List positionalArguments, Map<Symbol,dynamic> namedArguments]) {  // TODO: return list with results ?
    entries.values.forEach((method) {
      if(test(method)) {
        method.invoke(positionalArguments, namedArguments);
      }
    });
  }

  /// Invokes the first method that satisfies the given [test]
  dynamic invokeFirstWhere(bool test(Symbol name, Method method), [List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    var method = firstWhere(test, orElse: () => null);
    dynamic result = null;

    if(method != null) {
      result = method.invoke(positionalArguments, namedArguments);
    }

    return result;
  }
}