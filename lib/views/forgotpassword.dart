import 'package:flutter/material.dart';
import 'package:my_project/services/auth_services.dart';
import 'package:my_project/utils/validations.dart';
import 'package:my_project/views/register.dart';

class Forgotpassword extends StatefulWidget {
  Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  List<String> _gender = ["Male", "Female"];

  bool isseen = true;

  final TextEditingController emailController = TextEditingController();

  final AuthServices _authservice = AuthServices();

  var _isloader = false;
  get isloader => _isloader;

  Future<String> forgotpassword() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isloader = true;
      });
      try {
        setState(() {
          _isloader = false;
          
        });
        await _authservice.forgotpassword(emailController.text);
        return "Password reset email has been sent";
      } catch (e) {
        setState(() {
          _isloader = false;
          
        });
        return e.toString();
      }
    } else {
      setState(() {
          _isloader = false;
          
        });
      return "";
    }
  }

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 13,
          children: [
            // heading
            Text(
              "Send Password",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Form(
              key: _formkey,
              child: Column(
                spacing: 15,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                    controller: emailController,
                    validator: FormValidations.validateEmail,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                var res = await forgotpassword();

                  if (res == "Password reset email has been sent") {
                    // success snackbar
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(res)));

                   
                  } else {
                    // error snackbar (invalid email, wrong password, etc.)
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(res)));
                  }
                },
                child: isloader ? CircularProgressIndicator() : Text("Forgot Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
