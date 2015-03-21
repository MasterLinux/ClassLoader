library apethory.class_loader.test;

import 'package:unittest/unittest.dart';
import 'package:class_loader/class_loader.dart';

main() {
  group('metadata tests', () {
    ClassLoader classLoader;

    setUp(() {
      classLoader = new ClassLoader(new Symbol("apethory.class_loader.test"), new Symbol("TestClass"));
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
  });
}

const String AuthorName = "Person_1";
const String AnotherAuthorName = "Person_2";

@Test
@Author(AuthorName)
@Author(AnotherAuthorName)
class TestClass {

}

const Object Test = const TestAnnotation();

class TestAnnotation {
  const TestAnnotation();
}

class Author {
  final String name;

  const Author(this.name);
}
