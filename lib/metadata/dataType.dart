enum DataType { text, int, real, blob }

class DataTypeRepr {
  static of(DataType type) {
    switch (type) {
      case DataType.text:
        return "TEXT"; //String
      case DataType.int:
        return "INTEGER"; //int
      case DataType.real:
        return "REAL"; //num
      case DataType.blob:
        return "BLOB"; //Uint8List
      default:
    }
  }
}
