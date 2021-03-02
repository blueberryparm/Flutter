class ListItem {
  int id;
  int idList;
  String name;
  String quantity;
  String note;

  ListItem(this.id, this.idList, this.name, this.quantity, this.note);

  Map<String, dynamic> toMap() {
    return {
      // when you provide a null value when you insert a new record, the database
      // will automatically assign a new value, with an auto-increment logic
      'id': id == 0 ? null : id,
      'idList': idList,
      'name': name,
      'quantity': quantity,
      'note': note,
    };
  }
}
