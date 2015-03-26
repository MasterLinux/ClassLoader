library apetheory.class_loader.utilities;

import 'dart:mirrors' show MirrorSystem;

Symbol createInstanceMemberName(Symbol symbol) { // TODO: move to SetterCollection?
  var name = MirrorSystem.getName(symbol);
  var isSetter = name.endsWith("=");

  if(isSetter) {
    name = name.substring(0, name.length - 1);
  }

  return isSetter ? new Symbol(name) : symbol;
}

