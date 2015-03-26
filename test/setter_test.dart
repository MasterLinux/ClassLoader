part of apethory.class_loader.test;

class SetterTests implements TestClass {

  @override
  void runTests() {
    group('setter tests:', () {
      ClassLoader classLoader;

      setUp(() async {
        classLoader = new ClassLoader(#apethory.class_loader.test, #ArticleMock);
        await classLoader.load();
      });

      test('get setter by name', () {
        var titleSetterUnderTest = classLoader.setter[#title];
        var titleSetterUnderTest2 = classLoader.setter[new Symbol('title=')];
        var subtitleSetterUnderTest = classLoader.setter.firstWhereName(#subtitle, orElse: () => null);
        var authorsSetterUnderTest = classLoader.setter.whereName(#authors);

        expect(titleSetterUnderTest, isNotNull);
        expect(titleSetterUnderTest2, isNotNull);

        // should be the same because "title" and "title=" are the same
        expect(titleSetterUnderTest, titleSetterUnderTest2);

        expect(subtitleSetterUnderTest, isNotNull);
        expect(authorsSetterUnderTest, isNotEmpty);
        expect(authorsSetterUnderTest.length, 1);
      });

      test('set value', () {
        final expectedTitle = "newTitle";
        var titleSetterUnderTest = classLoader.setter[#title];
        var titleGetterUnderTest = classLoader.getter[#title];

        expect(titleSetterUnderTest, isNotNull);

        // test whether original value is set
        var title = titleGetterUnderTest.get();
        expect(title, ArticleTitle);

        // test whether value is changed
        titleSetterUnderTest.set(expectedTitle);
        title = titleGetterUnderTest.get();
        expect(title, expectedTitle);
      });
    });
  }
}