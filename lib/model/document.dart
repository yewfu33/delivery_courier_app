class Document {
  String name;
  String document;
  String documentName;

  Map toMap() {
    return {
      'name': name,
      'document': document,
      'document_name': documentName,
    };
  }
}
