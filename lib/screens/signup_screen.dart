import 'package:flutter/material.dart';
import '../logic/signup_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final bloc = SignupBloc();
  String? _gender;
  String? _level;

  // دالة مساعدة لتنسيق الحقول (لتقليل تكرار الكود)
  InputDecoration _inputStyle(String label, IconData icon, String? errorText) {
    return InputDecoration(
      labelText: label,
      errorText: errorText,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            children: [
              const Text(
                "Join Us Fatimah!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 30),

              // حقل الاسم
              StreamBuilder(
                stream: bloc.nameStream,
                builder: (context, snapshot) => TextField(
                  onChanged: bloc.changeName,
                  decoration: _inputStyle('Full Name *', Icons.person_outline, snapshot.error?.toString()),
                ),
              ),
              const SizedBox(height: 15),

              // حقل النوع (في Card ليعطي شكلاً أفضل)
              Card(
                elevation: 0,
                color: Colors.grey[50],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[400]!)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.wc, color: Colors.grey),
                      const SizedBox(width: 10),
                      const Text("Gender:"),
                      Radio(value: "Male", groupValue: _gender, onChanged: (v) => setState(() => _gender = v as String?)),
                      const Text("Male"),
                      Radio(value: "Female", groupValue: _gender, onChanged: (v) => setState(() => _gender = v as String?)),
                      const Text("Female"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // حقل الإيميل
              StreamBuilder(
                stream: bloc.emailStream,
                builder: (context, snapshot) => TextField(
                  onChanged: bloc.changeEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputStyle('Email Address *', Icons.email_outlined, snapshot.error?.toString()),
                ),
              ),
              const SizedBox(height: 15),

              // حقل المستوى
              DropdownButtonFormField(
                decoration: _inputStyle('Academic Level', Icons.school_outlined, null),
                hint: const Text("Select Level"),
                items: ['1', '2', '3', '4'].map((l) => DropdownMenuItem(value: l, child: Text("Level $l"))).toList(),
                onChanged: (v) => setState(() => _level = v as String?),
              ),
              const SizedBox(height: 15),

              // حقل كلمة السر
              StreamBuilder(
                stream: bloc.passwordStream,
                builder: (context, snapshot) => TextField(
                  onChanged: bloc.changePassword,
                  obscureText: true,
                  decoration: _inputStyle('Password *', Icons.lock_outline, snapshot.error?.toString()),
                ),
              ),
              const SizedBox(height: 15),

              // تأكيد كلمة السر
              StreamBuilder(
                stream: bloc.confirmPasswordStream,
                builder: (context, snapshot) => TextField(
                  onChanged: bloc.changeConfirmPassword,
                  obscureText: true,
                  decoration: _inputStyle('Confirm Password *', Icons.lock_reset, snapshot.error?.toString()),
                ),
              ),
              const SizedBox(height: 30),

              // زر التسجيل
              StreamBuilder(
                stream: bloc.submitValid,
                builder: (context, snapshot) => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: snapshot.hasData ? () => Navigator.pushNamed(context, '/login') : null,
                    child: const Text('SIGN UP', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}