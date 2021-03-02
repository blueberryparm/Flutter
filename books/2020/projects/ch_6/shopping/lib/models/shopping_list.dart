class ShoppingList {
  int id;
  String name;
  int priority;

  ShoppingList(this.id, this.name, this.priority);

  Map<String, dynamic> toMap() {
    return {
      // when you provide a null value when you insert a new record, the database
      // will automatically assign a new value, with an auto-increment logic
      'id': id == 0 ? null : id,
      'name': name,
      'priority': priority,
    };
  }
}
