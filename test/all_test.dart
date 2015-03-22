library apethory.class_loader.test;

import 'package:unittest/unittest.dart';
import 'package:class_loader/class_loader.dart';

main() {
  group('method tests:', () {
    ClassLoader classLoader;

    setUp(() {
      classLoader = new ClassLoader(#apethory.class_loader.test, #TestClass);
    });

    test('has method with name', () {
      var method = classLoader.methods.firstWhere((method) => method.name == #testMethod, orElse: () => null);

      expect(method, isNotNull);
    });
  });

  group('metadata tests:', () {
    ClassLoader classLoader;

    setUp(() {
      classLoader = new ClassLoader(#apethory.class_loader.test, #TestClass);
    });

    test('get field with annotation', () {
      var field = classLoader.fields.firstWhereMetadata((name, annotation) => name == #TestAnnotation, orElse: () => null);

      expect(field, isNotNull);
    });

    test('class has annotations', () {
      var hasAuthorAnnotation = classLoader.metadata[#Author] != null;
      var hasTestAnnotation = classLoader.metadata[#TestAnnotation] != null;
      var authorAnnotations = classLoader.metadata.whereName(#Author);

      expect(hasAuthorAnnotation, isTrue);
      expect(hasTestAnnotation, isTrue);
      expect(authorAnnotations.length, 2);

      var firstAuthorAnnotation = authorAnnotations.first;
      var secondAuthorAnnotation = classLoader.metadata.where((name, meta) {
        return name == #Author && (meta as Author).name == AnotherAuthorName;
      });

      expect(firstAuthorAnnotation is Author, isTrue);
      expect((firstAuthorAnnotation as Author).name, AuthorName);
      expect((secondAuthorAnnotation.first as Author).name, AnotherAuthorName);
    });

    test('has method with annotation', () {
      var method = classLoader.methods.firstWhereMetadata((name, meta) {
        return name == #Author && (meta as Author).name == AuthorName;
      }, orElse: () => null);

      expect(method, isNotNull);
    });
  });
}

const String AuthorName = "Person_1";
const String AnotherAuthorName = "Person_2";

@Test
@Author(AuthorName)
@Author(AnotherAuthorName)
class TestClass {

  @Test
  @Author(AuthorName)
  @Author(AnotherAuthorName)
  String get title => AuthorName;

  @Test
  @Author(AuthorName)
  @Author(AnotherAuthorName)
  bool testMethod(int x, int y) {
    return x == y;
  }

}

const Object Test = const TestAnnotation();

class TestAnnotation {
  const TestAnnotation();
}

class Author {
  final String name;

  const Author(this.name);
}
