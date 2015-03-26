part of apethory.class_loader.test;

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

const Object MockField = const MockFieldAnnotation();

class MockFieldAnnotation {
  const MockFieldAnnotation();
}

class MockMethod {
  final String author;

  const MockMethod(this.author);
}

class MockAuthor {
  final String name;

  const MockAuthor(this.name);
}
