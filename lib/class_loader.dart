library apetheory.class_loader;

import 'dart:mirrors';

import 'utilities.dart' as util;

part 'collection.dart';
part 'instance_member.dart';

///
class ClassLoader<T> {
  MetadataCollection _metadata;
  InstanceMirror _instanceMirror;
  ClassMirror _classMirror;

  /// Gets all methods of the reflected class
  final MethodCollection methods = new MethodCollection();

  /// Gets all getter of the reflected class
  final InstanceMemberCollection<Getter> getter = new InstanceMemberCollection<Getter>();

  /// Gets all setter of the reflected class
  final InstanceMemberCollection<Setter> setter = new InstanceMemberCollection<Setter>();

  final InstanceMemberCollection<Field> fields = new InstanceMemberCollection<Field>();

  /// Initializes the loader with the help of the [libraryName]
  /// and [className] of the required class to load. The [constructorName]
  /// can be used to use a specific constructor for initialization
  ClassLoader(Symbol libraryName, Symbol className, {Symbol constructorName, List positionalArguments, Map<Symbol,dynamic> namedArguments, bool excludePrivateMembers: true}) {
    _classMirror = _getClassMirror(libraryName, className);

    constructorName = constructorName != null ? constructorName : const Symbol('');
    positionalArguments = positionalArguments != null ? positionalArguments : [];
    namedArguments = namedArguments != null ? namedArguments : {};

    _instanceMirror = _classMirror.newInstance(constructorName, positionalArguments, namedArguments);

    _load(_classMirror, _instanceMirror, excludePrivateMembers);
  }

  /// Initializes the loader with the help of an instance
  ClassLoader.fromInstance(T reflectee, {excludePrivateMembers: true}) {
    _instanceMirror = reflect(reflectee);
    _classMirror = _instanceMirror.type;

    _load(_classMirror, _instanceMirror, excludePrivateMembers);
  }

  void _load(ClassMirror classMirror, InstanceMirror instanceMirror, bool excludePrivateMembers) {
    _metadata = new MetadataCollection(classMirror);

    instanceMirror.type.declarations.forEach((name, mirror) {

      if(!mirror.isPrivate || !excludePrivateMembers) {
        if(mirror is MethodMirror) {
          // add method
          if(mirror.isRegularMethod && !mirror.isSetter && !mirror.isGetter && !mirror.isConstructor) {
            methods.add(new Method(name, mirror, instanceMirror));
          }

          // add getter
          else if(mirror.isGetter && !mirror.isSynthetic) {
            getter.add(new Getter(name, mirror, instanceMirror));
          }

          // add setter
          else if(mirror.isSetter && !mirror.isSynthetic) {
            setter.add(new Setter(name, mirror, instanceMirror));
          }
        }

        // add field
        else if(mirror is VariableMirror) {
          fields.add(new Field(name, mirror, instanceMirror));
        }
      }
    });
  }

  /// Gets the instance of the loaded class
  T get instance => _instanceMirror.reflectee as T;

  MetadataCollection get metadata => _metadata;

  /// Returns true if class contains a [Getter] with the given [name]
  bool hasGetter(Symbol name) => getter.contains(name);

  /// Returns true if class contains a [Setter] with the given [name]
  bool hasSetter(Symbol name) => setter.contains(name);

  /// Returns true if class contains a [Method] with the given [name]
  bool hasMethod(Symbol name) => methods.contains(name);

  /**
   * Gets the mirror of a specific class with the help of
   * its [libraryName] and [className].
   */
  ClassMirror _getClassMirror(Symbol libraryName, Symbol className) {
    ClassMirror reflectedClass;

    var mirrorSystem = currentMirrorSystem();
    var library = mirrorSystem.findLibrary(libraryName);

    if((reflectedClass = library.declarations[className]) != null) {
      return reflectedClass;
    } else {
      throw new MissingClassException(className.toString());
    }
  }
}

/*
class MetadataCollection {
  DeclarationMirror _mirror;

  MetadataCollection(DeclarationMirror mirror) {
    _mirror = mirror;
  }

  operator [](Symbol name) {
    return firstWhereName(name);
  }

  Iterable<dynamic> where(bool test(Symbol name, dynamic annotation)) {
    test = test != null ? test : (meta) => true;
    var metadata = new List();

    _mirror.metadata.forEach((meta) {
      if(test(meta.type.simpleName, meta.reflectee)) {
        metadata.add(meta.reflectee);
      }
    });

    return metadata;
  }

  dynamic firstWhere(bool test(Symbol name, dynamic annotation)) {
    var metadata = _mirror.metadata.firstWhere((meta) {
      return test(meta.type.simpleName, meta.reflectee);
    }, orElse: () => null);

    return metadata != null ? metadata.reflectee : null;
  }

  Iterable<dynamic> whereName(Symbol name) {
    return where((annotationName, annotation) => annotationName == name);
  }

  dynamic firstWhereName(Symbol name) {
    return firstWhere((annotationName, annotation) => annotationName == name);
  }
}

/// Collection for methods
class MethodCollection {
  Map<Symbol, Method> _methods = new Map<Symbol, Method>();
  InstanceMirror _instanceMirror;

  /// Initializes the collection
  MethodCollection(InstanceMirror instanceMirror) {
    _instanceMirror = instanceMirror;

    // get all methods
    instanceMirror.type.instanceMembers.forEach((name, mirror) {
      if(mirror.isRegularMethod && !mirror.isSetter && !mirror.isGetter && !mirror.isConstructor) {
        _methods[name] = new Method(name, mirror, _instanceMirror);
      }
    });
  }

  /// Returns true if the collection contains a method with the given [name]
  bool contains(Symbol name) => _methods.containsKey(name);

  /// Returns the [Method] for the given [name] or null if [name] is not in the collection
  Method operator [](Symbol name) => _methods[name];

  /// Returns the first method that satisfies the given [test]
  Method firstWhere(bool test(Method method), { Method orElse() }) {
    return _methods.values.firstWhere(test, orElse: orElse);
  }

  /// Returns each method that satisfies the given [test]
  Iterable<Method> where(bool test(Method method)) {
    return _methods.values.where(test);
  }

  Method firstWhereMetadata(bool test(Symbol name, dynamic annotation), { Method orElse() }) {
    return firstWhere((method) => method.metaData.where(test).isNotEmpty, orElse: orElse);
  }

  Iterable<Method> whereMetadata(bool test(Symbol name, dynamic annotation)) {
    return where((method) => method.metaData.where(test).isNotEmpty);
  }

  /// Invokes each method that satisfies the given [test]
  void invokeWhere(bool test(Method method), [List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    _methods.values.forEach((method) {
      if(test(method)) {
        method.invoke(positionalArguments, namedArguments);
      }
    });
  }

  /// Invokes the first method that satisfies the given [test]
  void invokeFirstWhere(bool test(Method method), [List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    var method = firstWhere(test, orElse: () => null);

    if(method != null) {
      method.invoke(positionalArguments, namedArguments);
    }
  }
}

/// Represents a method
class Method {
  MetadataCollection _metadata;
  InstanceMirror _instanceMirror;
  MethodMirror _methodMirror;
  final Symbol name;

  /// Initializes the method
  Method(this.name, MethodMirror methodMirror, InstanceMirror instanceMirror) {
    _instanceMirror = instanceMirror;
    _methodMirror = methodMirror;

    _metadata = new MetadataCollection(_methodMirror);
  }

  /// Invokes the method
  void invoke([List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    positionalArguments = positionalArguments != null ? positionalArguments : [];
    namedArguments = namedArguments != null ? namedArguments : {};

    _instanceMirror.invoke(name, positionalArguments, namedArguments);
  }

  MetadataCollection get metaData => _metadata;

  /// Returns true if method is abstract
  bool get isAbstract => _methodMirror.isAbstract;

  /// Returns the 'metadata annotation' for the given [annotationName]
  /// or null if method is not annotated with the annotation with the given name
  operator [](Symbol annotationName) {
    var metadata = _methodMirror.metadata.firstWhere((meta) {
      return meta.type.simpleName == annotationName;
    }, orElse: () => null);

    return metadata != null ? metadata.reflectee : null;
  }

  /// Returns true if the method is annotated with
  /// the metadata annotation with the given [name]
  bool hasMetadata(Symbol name) => this[name] != null;
}

/// Collection for getter and setter
class FieldCollection {
  Map<Symbol, Field> _fields = new Map<Symbol, Field>();
  InstanceMirror _instanceMirror;

  /// Initializes the collection
  FieldCollection(InstanceMirror instanceMirror) {
    _instanceMirror = instanceMirror;

    // get all fields
    instanceMirror.type.instanceMembers.forEach((name, mirror) {
      if(mirror.isSetter || mirror.isGetter) {
        _fields[name] = new Field(name, _instanceMirror);
      }
    });
  }

  /// Returns the [Field] for the given [name] or null if [name] is not in the collection
  Field operator [](Symbol name) {
    return _fields[name];
  }

  /// Associates the [Field] with the given [name] with the given [value]
  operator []=(Symbol name, Object value) => _instanceMirror.setField(name, value);

  /// Returns the first method that satisfies the given [test]
  Field firstWhere(bool test(Field method), { Field orElse() }) {
    return _fields.values.firstWhere(test, orElse: orElse);
  }

  /// Returns each method that satisfies the given [test]
  Iterable<Field> where(bool test(Field method)) {
    return _fields.values.where(test);
  }

  Field firstWhereMetadata(bool test(Symbol name, dynamic annotation), { Field orElse() }) {
    return firstWhere((field) => field.metadata.where(test).isNotEmpty, orElse: orElse);
  }

  Iterable<Field> whereMetadata(bool test(Symbol name, dynamic annotation)) {
    return where((field) => field.metadata.where(test).isNotEmpty);
  }

  /// Returns true if the collection contains a [Field] with the given [name]
  bool contains(Symbol name) => _fields.containsKey(name);
}

/// Representation of a getter or setter
class Field {
  MetadataCollection _metadata;
  InstanceMirror _instanceMirror;
  MethodMirror _methodMirror;
  final Symbol name;

  /// Initializes the field
  Field(this.name, InstanceMirror instanceMirror) {
    _methodMirror = instanceMirror.type.instanceMembers[name];
    _instanceMirror = instanceMirror;

    _metadata = new MetadataCollection(_methodMirror);
  }

  MetadataCollection get metadata => _metadata;

  /// Sets the given [value]
  set(Object value) => _instanceMirror.setField(name, value);

  /// Gets the value of the [Field]
  Object get() => _instanceMirror.getField(name);

  /// Returns true if [Field] is a setter
  bool get isSetter => _methodMirror.isSetter;

  /// Returns true if [Field] is a getter
  bool get isGetter => _methodMirror.isGetter;
}
*/

class MissingClassException implements Exception {
  final String className;

  MissingClassException(this.className);

  String toString() {
    return "Class [$className] is missing";
  }
}

