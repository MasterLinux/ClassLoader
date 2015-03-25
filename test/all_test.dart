library apethory.class_loader.test;

import 'package:unittest/unittest.dart';
import 'package:class_loader/class_loader.dart';

main() {

  group('Field tests:', () {
    ClassLoader classLoader;

    setUp(() {
      classLoader = new ClassLoader(#apethory.class_loader.test, #ArticleMock);
    });

    test('create field name', () {
      var expectedName = new Symbol('test');
      var actualName = Field.createFieldName(new Symbol('test='));

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

  group('metadata tests:', () {
    ClassLoader classLoader;

    setUp(() {
      classLoader = new ClassLoader(#apethory.class_loader.test, #ArticleMock);
    });

    test('find first getter with specific annotation', () {
      var getterUnderTest = classLoader.getter.firstWhereMetadata((name, annotation) => name == #MockGetterAnnotation, orElse: () => null);
      var orElseResult = classLoader.getter.firstWhereMetadata((name, annotation) => false, orElse: () => null);

      expect(getterUnderTest, isNotNull);
      expect(getterUnderTest is Getter, isTrue);
      expect(orElseResult, isNull);
    });

    test('find all getter with specific annotation', () {
      var setterUnderTest = classLoader.getter.whereMetadata((name, annotation) => name == #MockGetterAnnotation);

      expect(setterUnderTest, isNotEmpty);
      expect(setterUnderTest.length, 2);
    });

    test('find first setter with specific annotation', () {
      var setterUnderTest = classLoader.setter.firstWhereMetadata((name, annotation) => name == #MockSetterAnnotation, orElse: () => null);
      var orElseResult = classLoader.setter.firstWhereMetadata((name, annotation) => false, orElse: () => null);

      expect(setterUnderTest, isNotNull);
      expect(setterUnderTest is Setter, isTrue);
      expect(orElseResult, isNull);
    });

    test('find all setter with specific annotation', () {
      var setterUnderTest = classLoader.setter.whereMetadata((name, annotation) => name == #MockSetterAnnotation);

      expect(setterUnderTest, isNotEmpty);
      expect(setterUnderTest.length, 2);
    });

    test('find first method with specific annotation', () {
      var methodUnderTest = classLoader.methods.firstWhereMetadata((name, meta) => name == #MockMethodAnnotation, orElse: () => null);
      var orElseResult = classLoader.methods.firstWhereMetadata((name, meta) => false, orElse: () => null);

      expect(methodUnderTest, isNotNull);
      expect(methodUnderTest is Method, isTrue);
      expect(orElseResult, isNull);
    });

    /*
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
    */


  });
}

const String AuthorName = "Person_1";
const String AnotherAuthorName = "Person_2";

@Mock
@Author(AuthorName)
@Author(AnotherAuthorName)
class ArticleMock {
  String _title;
  String _subtitle;
  List<String> _authors = <String>[];

  int date = 42;

  @MockGetter
  String get title => _title;

  @MockSetter
  set title(String str) => _title = title;


  @MockGetter
  String get subtitle => _subtitle;

  @MockSetter
  set subtitle(String subtitle) => _subtitle = subtitle;


  List<String> get authors => _authors;

  set authors(List<String> authors) => _authors = authors;


  @MockMethod
  bool testMethod(int x, int y) {
    return x == y;
  }
}

const Object Mock = const MockAnnotation();

class MockAnnotation {
  const MockAnnotation();
}

const Object MockSetter = const MockSetterAnnotation();

class MockSetterAnnotation {
  const MockSetterAnnotation();
}

const Object MockGetter = const MockGetterAnnotation();

class MockGetterAnnotation {
  const MockGetterAnnotation();
}

const Object MockMethod = const MockMethodAnnotation();

class MockMethodAnnotation {
  const MockMethodAnnotation();
}

class Author {
  final String name;

  const Author(this.name);
}
