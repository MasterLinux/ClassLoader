part of apethory.class_loader.test;

const String AuthorName = "Person_1";
const String AnotherAuthorName = "Person_2";
const String ArticleTitle = "Title";
const String ArticleSubtitle = "Subtitle";

@Mock
@MockAuthor(AuthorName)
@MockAuthor(AnotherAuthorName)
class ArticleMock {
  String _title = ArticleTitle;
  String _subtitle = ArticleSubtitle;
  List<String> _authors = <String>[];

  @MockField
  int date = 42435345345345345;

  @MockField
  String dateFormat = "dd-MM-yy";

  bool isVisible = false;


  @MockGetter
  String get title => _title;

  @MockSetter
  set title(String title) => _title = title;


  @MockGetter
  String get subtitle => _subtitle;

  @MockSetter
  set subtitle(String subtitle) => _subtitle = subtitle;


  // instance member without annotations
  List<String> get authors => _authors;
  set authors(List<String> authors) => _authors = authors;


  @MockMethod(AuthorName)
  bool isSame(int x, int y) {
    return x == y;
  }

  @MockMethod(AnotherAuthorName)
  @MockAuthor(AnotherAuthorName)
  int sum(int x, int y) {
    return x + y;
  }

  // method without annotations
  void printNumbers(int x, int y) {
    print("x: $x - y: $y");
  }
}