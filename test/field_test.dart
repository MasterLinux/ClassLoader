part of apethory.class_loader.test;

class FieldTests implements TestClass {

  @override
  void runTests() {
    group('field tests:', () {
      ClassLoader classLoader;

      setUp(() async {
        classLoader = new ClassLoader(#apethory.class_loader.test, #ArticleMock);
        await classLoader.load();
      });

      test('get field by name', () {
        var dateFieldUnderTest = classLoader.fields[#date];
        var dateFormatFieldUnderTest = classLoader.fields.firstWhereName(#dateFormat, orElse: () => null);
        var isVisibleFieldUnderTest = classLoader.fields.whereName(#isVisible);

        expect(dateFieldUnderTest, isNotNull);
        expect(dateFormatFieldUnderTest, isNotNull);
        expect(isVisibleFieldUnderTest, isNotEmpty);
        expect(isVisibleFieldUnderTest.length, 1);
      });

      test('get value', () {
        var dateFieldUnderTest = classLoader.fields[#date];
        var date = dateFieldUnderTest.get();
        expect(date, ArticleDate);
      });

      test('set value', () {
        var expectedDateFormat = "yyyy";
        var dateFormatFieldUnderTest = classLoader.fields[#dateFormat];

        var date = dateFormatFieldUnderTest.get();
        expect(date, ArticleDateFormat);

        dateFormatFieldUnderTest.set(expectedDateFormat);
        date = dateFormatFieldUnderTest.get();
        expect(date, expectedDateFormat);
      });
    });
  }
}