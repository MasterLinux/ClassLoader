library apethory.class_loader.test;

import 'package:unittest/unittest.dart';
import 'package:class_loader/class_loader.dart';

main() {
  group('A group of tests', () {
    ClassLoader classLoader;

    setUp(() {
      classLoader = new ClassLoader(new Symbol("apethory.class_loader.test"), new Symbol("TestClass"));
    });

    test('First Test', () {
      //expect(classLoader, isTrue);
    });
  });
}

class TestClass {

}
