class MyConstants {
  static const String TABLE_NAME = "Messages"; // Переменная в которой будем хранить название таблицы
  static const String ID = "id"; // Поле с идетификатором
  static const String CONTENT = "content"; // Поле с тестом сообщения

  // Структура таблицы
  static const String TABLE_STRUCTURE = "CREATE TABLE $TABLE_NAME ( "
      "$ID INTEGER PRIMARY KEY, "
      "$CONTENT TEXT )";

  // Удаление таблицы
  static const String DROP_TABLE = "DROP TABLE IF EXISTS $TABLE_NAME";
}