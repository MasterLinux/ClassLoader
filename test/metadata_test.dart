part of apethory.class_loader.test;

class MetadataTests implements TestClass {

  @override
  void runTests() {
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

      test('find first field with specific annotation', () {
        var fieldUnderTest = classLoader.fields.firstWhereMetadata((name, meta) => name == #MockFieldAnnotation, orElse: () => null);
        var orElseResult = classLoader.fields.firstWhereMetadata((name, annotation) => false, orElse: () => null);

        expect(fieldUnderTest, isNotNull);
        expect(fieldUnderTest is Field, isTrue);
        expect(orElseResult, isNull);
      });

      test('find all fields with specific annotation', () {
        var fieldsUnderTest = classLoader.fields.whereMetadata((name, annotation) => name == #MockFieldAnnotation);

        expect(fieldsUnderTest, isNotEmpty);
        expect(fieldsUnderTest.length, 2);
      });

      test('find first method with specific annotation', () {
        var methodUnderTest = classLoader.methods.firstWhereMetadata((name, meta) => name == #MockMethod, orElse: () => null);
        var orElseResult = classLoader.methods.firstWhereMetadata((name, meta) => false, orElse: () => null);

        expect(methodUnderTest, isNotNull);
        expect(methodUnderTest is Method, isTrue);
        expect(orElseResult, isNull);
      });

      test('find all methods with specific annotation', () {
        var methodsUnderTest = classLoader.methods.whereMetadata((name, meta) => name == #MockMethod);
        var otherMethodsUnderTest = classLoader.methods.whereMetadata((name, meta) => name == #MockMethod && (meta as MockMethod).author == AuthorName);

        expect(methodsUnderTest, isNotNull);
        expect(methodsUnderTest, isNotEmpty);
        expect(methodsUnderTest.length, 2);

        expect(otherMethodsUnderTest, isNotNull);
        expect(otherMethodsUnderTest, isNotEmpty);
        expect(otherMethodsUnderTest.length, 1);
      });

      test('get metadata from method via indexer', () {
        var annotationUnderTest = classLoader.methods[#sum][#MockAuthor];

        expect(annotationUnderTest, isNotNull);
        expect(annotationUnderTest is MockAuthor, isTrue);
      });

      test('method has metadata', () {
        var hasMetadata = classLoader.methods[#sum].hasMetadata(#MockMethod);
        expect(hasMetadata, isTrue);

        hasMetadata = classLoader.methods[#sum].hasMetadata(#Undefined);
        expect(hasMetadata, isFalse);
      });

      test('get metadata from class via indexer', () {
        var authorAnnotationUnderTest = classLoader.metadata[#MockAuthor];
        var anotherAnnotationUnderTest = classLoader.metadata.firstWhereName(#MockAuthor);

        expect(authorAnnotationUnderTest, isNotNull);
        expect(authorAnnotationUnderTest is MockAuthor, isTrue);

        // must be the same annotation
        expect(authorAnnotationUnderTest, anotherAnnotationUnderTest);
        expect((authorAnnotationUnderTest as MockAuthor).name, (anotherAnnotationUnderTest as MockAuthor).name);
      });

      test('get all metadata from class with specific name', () {
        var authorAnnotationsUnderTest = classLoader.metadata.whereName(#MockAuthor);

        expect(authorAnnotationsUnderTest, isNotEmpty);
        expect(authorAnnotationsUnderTest.length, 2);
      });

      test('class has metadata with specific name', () {
        var hasAnnotation = classLoader.metadata.contains(#MockAnnotation);
        expect(hasAnnotation, isTrue);

        hasAnnotation = classLoader.metadata.contains(#Unavailable);
        expect(hasAnnotation, isFalse);
      });

      test('get metadata of class by querying', () {
        var annotationUnderTest = classLoader.metadata.firstWhere((name, meta) => name == #MockAuthor && (meta as MockAuthor).name == AnotherAuthorName, orElse: () => null);
        var anotherAnnotationUnderTest = classLoader.metadata.where((name, meta) => name == #MockAuthor && (meta as MockAuthor).name == AuthorName);

        expect(annotationUnderTest, isNotNull);
        expect(annotationUnderTest is MockAuthor, isTrue);
        expect((annotationUnderTest as MockAuthor).name, AnotherAuthorName);

        expect(anotherAnnotationUnderTest, isNotEmpty);
        expect(anotherAnnotationUnderTest.length, 1);
        expect((anotherAnnotationUnderTest.elementAt(0) as MockAuthor).name, AuthorName);
      });

    });
  }
}