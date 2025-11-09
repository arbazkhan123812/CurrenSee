import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_project/services/auth_services.dart';
import 'package:my_project/utils/validations.dart';
import 'package:my_project/views/Admin/admin_dashboard.dart';
import 'package:my_project/views/Admin/admin_navigation.dart';
import 'package:my_project/views/forgotpassword.dart';
import 'package:my_project/views/home_page.dart';
import 'package:my_project/views/navigation.dart';
import 'package:my_project/views/profile.dart';
import 'package:my_project/views/register.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> _gender = ["Male", "Female"];

  final TextEditingController nameController = TextEditingController();

  bool isseen = true;

  final TextEditingController emailController = TextEditingController();

  // TextEditingController genderController = TextEditingController();
  String gender = "";

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  final AuthServices _authservice = AuthServices();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final TextEditingController confirmpassController = TextEditingController();

  var _isloader = false;
  get isloader => _isloader;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Future<String> handleloginpress() async {
      if (_formkey.currentState!.validate()) {
        setState(() {
          _isloader = true;
        });

        try {
          await _authservice.loginuser(
            emailController.text,
            passController.text,
          );
          setState(() {
            _isloader = false;
          });
          return "User Logged In Successfully";
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

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 13,
          children: [
            // heading
            Text(
              "Login To Your Account",
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
                  TextFormField(
                    obscureText: isseen,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        child: Icon(
                          isseen ? Icons.visibility : Icons.visibility_off,
                        ),
                        onTap: () {
                          setState(() {
                            isseen = !isseen;
                          });
                        },
                      ),
                    ),
                    controller: passController,
                    validator: FormValidations.validatePassword,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 5,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Text("Forgot Password"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Forgotpassword()),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  var res = await handleloginpress();

                  if (res == "User Logged In Successfully") {
                    // success snackbar
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(res)));

                    // wait before redirect
                    // await Future.delayed(Duration(seconds: 1));
                    var data = await _authservice.profileuserdata();
                    data['is_admin'] == 1
                        ? Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminNavigation()),
                            (route) => false,
                          )
                        :
                        // navigate to dashboard
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavigationPage()),
                            (route) => false,
                          );
                  } else {
                    // error snackbar (invalid email, wrong password, etc.)
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(res)));
                  }
                },
                child: isloader ? CircularProgressIndicator() : Text("Login"),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Create New Account", style: TextStyle(fontSize: 15)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
