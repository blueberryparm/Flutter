class Calculation {
  final RegExp regExp = RegExp('[+\\-x÷]');
  List<String> a = [];

  // Display the concatenation of the strings in the List
  String getString() {
    String str = '';
    a.forEach((String el) => str += el);
    return str;
  }

  double getResult() {
    // Consider the case in which a user accidentally ends the expression wih an operator
    if (regExp.hasMatch(a.last)) a.removeLast();
    // Check whether the string ends with . and that will require us to check whether a dot is left
    if (a.last.lastIndexOf('.') == a.last.length - 1)
      a.last = a.last.substring(0, a.length - 1);

    // Now we need to parse the calculation and compute its result
    // Check if the List contains multiplications or divisions
    for (int i = 0; i < a.length; i++) {
      if (a[i] == 'x') {
        a[i - 1] = '${double.parse(a[i - 1]) * double.parse(a[i + 1])}';
        a.removeAt(i);
        a.removeAt(i);
        i--;
      } else if (a[i] == '÷') {
        a[i - 1] = '${double.parse(a[i - 1]) * double.parse(a[i + 1])}';
        a.removeAt(i);
        a.removeAt(i);
        i--;
      }
    }

    // Check for additions or subtractions
    for (int i = 0; i < a.length; i++) {
      if (a[i] == '+') {
        a[i - 1] = '${double.parse(a[i - 1]) * double.parse(a[i + 1])}';
        a.removeAt(i);
        a.removeAt(i);
        i--;
      } else if (a[i] == '-') {
        a[i - 1] = '${double.parse(a[i - 1]) * double.parse(a[i + 1])}';
        a.removeAt(i);
        a.removeAt(i);
        i--;
      }
    }

    if (a.length != 1) throw Error();

    // The List should contain just one String containing
    // the result of the whole expression
    return double.parse(a[0]);
  }

  void add(String added) {
    // only add character if it's not an operator when the list is empty
    if (a.isEmpty) if (!regExp.hasMatch(added))
      a.add(added);
    // if it's not empty, we need to check whether the previous element was an operator.
    // We need to do the same thing we did for the first element. We can't add another
    // operator or a dot, but we can add a digit and it has to go into a separate List element
    else if (regExp.hasMatch(a.last)) if (!RegExp('[+\\-x÷.]').hasMatch(added))
      a.add(added);
    else if (regExp.hasMatch(added)) {
      if (!RegExp('.').hasMatch(a.last)) a.last += '.0';
      a.add(added);
      // The previous element was a number, we can add anything but we need to differentiate
      // between operators and digits
      // An operator will have to go into its own separate List element
      // A digit will have to be appended to the current last List element
    } else
      a.last += added;
  }

  void deleteOne() {
    // 1. Check if the List is empty, in that case we'll do nothing
    if (a.length > 0) {
      // 2. Check if the last element of the List is longer than one character,
      // in that case we'll delete the last character of that string
      if (a.last.length > 1) {
        a.last = a.last.substring(0, a.last.length - 1);
      } else
        // 3. If the last element is just one character, we'll delete it completely
        a.removeLast();
    }
  }

  // To delete everything we just need to reset the List to its initial state
  void deleteAll() => a = [];
}
