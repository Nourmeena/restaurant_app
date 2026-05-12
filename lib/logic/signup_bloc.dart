import 'package:rxdart/rxdart.dart';
import 'dart:async';

class SignupBloc {
  final _name = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _confirmPassword = BehaviorSubject<String>();

  // إضافة البيانات للـ Stream
  Function(String) get changeName => _name.sink.add;
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeConfirmPassword => _confirmPassword.sink.add;

  // التحقق (Validators)
  Stream<String> get nameStream => _name.stream.map((name) {
    if (name.isEmpty) throw "Name is required";
    return name;
  });

  Stream<String> get emailStream => _email.stream.map((email) {
    if (!email.contains('@')) throw "Invalid email structure";
    return email;
  });

  Stream<String> get passwordStream => _password.stream.map((pass) {
    if (pass.length < 8) throw "At least 8 characters required";
    return pass;
  });

  Stream<String> get confirmPasswordStream => CombineLatestStream.combine2(
    passwordStream, _confirmPassword.stream, (p, cp) {
      if (p != cp) throw "Passwords do not match";
      return cp;
    });

  // تفعيل الزر إذا كانت البيانات صحيحة
  Stream<bool> get submitValid => CombineLatestStream.combine4(
    nameStream, emailStream, passwordStream, confirmPasswordStream, 
    (n, e, p, cp) => true
  );

  void dispose() {
    _name.close();
    _email.close();
    _password.close();
    _confirmPassword.close();
  }
}