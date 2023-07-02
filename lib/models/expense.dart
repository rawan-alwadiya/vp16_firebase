class Expense {
  late String id;
  late String title;
  late double value;

  Expense();

  Expense.fromMap(Map<String, dynamic> json) {
    title = json['title'];
    value = json['value'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['value'] = value;
    return data;
  }
}

/**
 * {
 * "title":"Title",
 * "value":99.5
 * }
 */