library apethory.class_loader.test;

import 'package:unittest/unittest.dart';
import 'package:class_loader/class_loader.dart';
import 'package:class_loader/utilities.dart' as util;

part 'mock/annotations.dart';
part 'mock/test_class.dart';
part 'metadata_test.dart';
part 'method_test.dart';
part 'getter_test.dart';
part 'setter_test.dart';

abstract class TestClass {
  void runTests();
}

main() {
  new MethodTests().runTests();
  new GetterTests().runTests();
  new SetterTests().runTests();
  new MetadataTests().runTests();

  group('utilities tests:', () {

    test('create instance member name', () {
      var expectedName = new Symbol('test');
      var actualName = util.createInstanceMemberName(new Symbol('test='));

      expect(actualName, expectedName);
    });
  });
}
