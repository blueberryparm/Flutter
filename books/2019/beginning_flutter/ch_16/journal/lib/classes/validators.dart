/*
    Responsible for validating the email and password values.

    Uses the StreamTransformer to validate whether the email is in the correct format
    by using at least one @ sign and a period. The password validator checks for a
    minimum of six characters entered.

    The StreamTransformer transforms a Stream that is used to validate and process values
    inside a Stream. The incoming date is a Stream, and the outgoing date after processing
    is a Stream.
 */

import 'dart:async';

class Validators {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (email.contains('@') && email.contains('.'))
        sink.add(email);
      else if (email.length > 0) sink.addError('Enter a valid email');
    },
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length >= 6)
        sink.add(password);
      else if (password.length > 0)
        sink.addError('Password needs to be at least 6 characters');
    },
  );
}
