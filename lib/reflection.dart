part of apetheory.class_loader;

abstract class _Reflector {
  InstanceMirror get instanceMirror;
  ClassMirror get classMirror;

  Future load();
}

class _InstanceReflector<T> implements _Reflector {
  InstanceMirror _instanceMirror;
  ClassMirror _classMirror;
  T _reflectee;

  _InstanceReflector(T reflectee) {
    _reflectee = reflectee;
  }

  @override
  InstanceMirror get instanceMirror => _instanceMirror;

  @override
  ClassMirror get classMirror => _classMirror;

  @override
  Future load() async {
    _instanceMirror = reflect(_reflectee);
    _classMirror = _instanceMirror.type;
  }
}

class _ConstructorReflector<T> implements _Reflector {
  InstanceMirror _instanceMirror;
  ClassMirror _classMirror;
  Symbol _libraryName;
  Symbol _className;
  Symbol _constructorName;
  List _positionalArguments;
  Map<Symbol,dynamic> _namedArguments;

  _ConstructorReflector(Symbol libraryName, Symbol className, [Symbol constructorName, List positionalArguments, Map<Symbol,dynamic> namedArguments]) {
    _libraryName = libraryName;
    _className = className;

    _constructorName = constructorName != null ? constructorName : const Symbol('');
    _positionalArguments = positionalArguments != null ? positionalArguments : [];
    _namedArguments = namedArguments != null ? namedArguments : {};
  }

  @override
  InstanceMirror get instanceMirror => _instanceMirror;

  @override
  ClassMirror get classMirror => _classMirror;

  @override
  Future load() async {
    _classMirror = _getClassMirror(_libraryName, _className);

    _instanceMirror = _classMirror.newInstance(
        _constructorName,
        _positionalArguments,
        _namedArguments
    );
  }

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