library apethory.class_loader.test;

import 'package:unittest/unittest.dart';
import 'package:class_loader/class_loader.dart';
import 'package:class_loader/utilities.dart' as util;

part 'mock/annotations.dart';
part 'mock/test_class.dart';
part 'metadata_test.dart';

abstract class TestClass {
  void runTests();
}

main() {

  new MetadataTest().runTests();

  group('utilities tests:', () {

    test('create instance member name', () {
      var expectedName = new Symbol('test');
      var actualName = util.createInstanceMemberName(new Symbol('test='));

      expect(actualName, expectedName);
    });
  });

  group('method tests:', () {
    ClassLoader classLoader;

    setUp(() {
      classLoader = new ClassLoader(#apethory.class_loader.test, #ArticleMock);
    });

    test('has method with name', () {
      var methodUnderTest = classLoader.methods.firstWhere((name, method) => name == #testMethod, orElse: () => null);

      expect(methodUnderTest, isNotNull);
    });
  });
}