part of apethory.class_loader.test;

class GetterTests implements TestClass {

  @override
  void runTests() {
    group('getter tests:', () {
      ClassLoader classLoader;

      setUp(() {
        classLoader = new ClassLoader(#apethory.class_loader.test, #ArticleMock);
      });

      test('get getter by name', () {
        var titleGetterUnderTest = classLoader.getter[#title];
        var subtitleGetterUnderTest = classLoader.getter.firstWhereName(#subtitle, orElse: () => null);
        var authorsGetterUnderTest = classLoader.getter.whereName(#authors);

        expect(titleGetterUnderTest, isNotNull);
        expect(subtitleGetterUnderTest, isNotNull);
        expect(authorsGetterUnderTest, isNotEmpty);
        expect(authorsGetterUnderTest.length, 1);
      });

      test('get value', () {
        var titleGetterUnderTest = classLoader.getter[#title];
        expect(titleGetterUnderTest, isNotNull);

        var title = titleGetterUnderTest.get();
        expect(title, ArticleTitle);
      });
    });
  }
}