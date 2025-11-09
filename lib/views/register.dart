import 'package:flutter/material.dart';
import 'package:my_project/services/auth_services.dart';
import 'package:my_project/utils/validations.dart';
import 'package:my_project/views/login.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<String> _gender = ["Male", "Female"];

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  // TextEditingController genderController = TextEditingController();
  String gender = "";

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  final TextEditingController confirmpassController = TextEditingController();

  String error = "";

  String success = "";

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Future<String> handleregisterpress() async {
    if (_formkey.currentState!.validate()) {
      try {
        await AuthServices().registeruser(
          nameController.text,
          emailController.text,
          phoneController.text,
          passController.text,
          addressController.text,
          gender,
        );
        return "User Registered Successfully";
      } catch (e) {
        return e.toString();
      }
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 13,
          children: [
            // heading
            Text(
              "Create Your account",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Form(
              key: _formkey,
              child: Column(
                spacing: 15,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(Icons.person),
                    ),
                    controller: nameController,
                    validator: FormValidations.validateName,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                    controller: emailController,
                    // validator: FormValidations.validateEmail,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Phone",
                      prefixIcon: Icon(Icons.phone),
                    ),
                    controller: phoneController,
                    // validator: FormValidations.validatePhone,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.male),
                      labelText: "Gender",
                    ),
                    onChanged: (value) {
                      gender = value!;
                      print(gender);
                    },
                    items:
                        _gender.map((gender) {
                          return DropdownMenuItem(
                            child: Text(gender),
                            value: gender,
                          );
                        }).toList(),
                    validator: FormValidations.validateGender,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Address",
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    validator: FormValidations.validateaddress,
                    controller: addressController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    controller: passController,
                    validator: FormValidations.validatePassword,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                    controller: confirmpassController,
                    validator: (value) {
                      return FormValidations.confirmPassword(
                        value,
                        passController.text,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  var res = await handleregisterpress();

                  if (res.isNotEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(res.toString())));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("user not registered")),
                    );
                  }
                },
                child: Text("Register"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                Text("Already Registered?", style: TextStyle(fontSize: 15)),
                GestureDetector(
                  child: Text("Login Now"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
