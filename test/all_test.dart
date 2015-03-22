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

    test('get first field with specific annotation', () {
      var field = classLoader.fields.firstWhereMetadata((name, annotation) => name == #MockAnnotation, orElse: () => null);
      expect(field, isNotNull);

      // test orElse
      var missingField = classLoader.fields.firstWhereMetadata((name, annotation) => false, orElse: () => null);
      expect(missingField, isNull);
    });

    test('get all fields with specific annotation', () {
      var fields = classLoader.fields.whereMetadata((name, annotation) => name == #MockAnnotation);
      var emptyFields = classLoader.fields.whereMetadata((name, annotation) => false);

      expect(fields, isNotEmpty);
      expect(fields.length, 2);
      expect(emptyFields, isEmpty);
    });

    test('', () {

    });

    test('class has annotations', () {
      var hasAuthorAnnotation = classLoader.metadata[#Author] != null;
      var hasTestAnnotation = classLoader.metadata[#MockAnnotation] != null;
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

@Mock
@Author(AuthorName)
@Author(AnotherAuthorName)
class TestClass {

  @Mock
  int number = 42;

  @Mock
  @Author(AuthorName)
  @Author(AnotherAuthorName)
  String get title => AuthorName;

  @Mock
  @Author(AuthorName)
  @Author(AnotherAuthorName)
  bool testMethod(int x, int y) {
    return x == y;
  }

}

const Object Mock = const MockAnnotation();

class MockAnnotation {
  const MockAnnotation();
}

class Author {
  final String name;

  const Author(this.name);
}
