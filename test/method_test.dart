part of apethory.class_loader.test;

class MethodTests implements TestClass {

  @override
  void runTests() {
    group('method tests:', () {
      ClassLoader classLoader;

      setUp(() async {
        classLoader = new ClassLoader(#apethory.class_loader.test, #ArticleMock);
        await classLoader.load();
      });

      test('get method by name', () {
        var isSameMethodUnderTest = classLoader.methods.firstWhere((name, method) => name == #isSame, orElse: () => null);
        var sumMethodUnderTest = classLoader.methods.firstWhereName(#sum);
        var printMethodUnderTest = classLoader.methods[#printNumbers];

        expect(isSameMethodUnderTest, isNotNull);
        expect(isSameMethodUnderTest is Method, isTrue);

        expect(sumMethodUnderTest, isNotNull);
        expect(sumMethodUnderTest is Method, isTrue);

        expect(printMethodUnderTest, isNotNull);
        expect(printMethodUnderTest is Method, isTrue);
      });

      test('invoke method directly', () {
        var printMethodUnderTest = classLoader.methods[#printNumbers];
        var isSameMethodUnderTest = classLoader.methods[#isSame];
        var sumMethodUnderTest = classLoader.methods[#sum];

        var isSame = isSameMethodUnderTest.invoke([2, 3]);
        expect(isSame, isFalse);

        isSame = isSameMethodUnderTest.invoke([2, 2]);
        expect(isSame, isTrue);

        var sum = sumMethodUnderTest.invoke([2, 3]);
        expect(sum, 5);

        // TODO: a void method returns null?
        var voidResult = printMethodUnderTest.invoke([2, 3]);
        expect(voidResult, isNull);
      });

      test('invoke method via collection', () {
        var sumUnderTest = classLoader.methods.invokeFirstWhere((name, method) => name == #sum, [3, 4]);
        expect(sumUnderTest, 7);
      });
    });
  }
}