import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_project/services/auth_services.dart';
import 'package:my_project/utils/helper.dart';
import 'package:my_project/utils/validations.dart';
import 'package:my_project/views/Admin/admin_dashboard.dart';
import 'package:my_project/views/Admin/admin_navigation.dart';
import 'package:my_project/views/forgotpassword.dart';
import 'package:my_project/views/home_page.dart';
import 'package:my_project/views/navigation.dart';
import 'package:my_project/views/profile.dart';
import 'package:my_project/views/register.dart';

// --- COLOR AND DECORATION CONSTANTS (FOR ENHANCEMENT) ---
const Color kPurpleColor = Color.fromARGB(255, 56, 18, 123);
const Color kLightPurpleColor = Color.fromARGB(255, 179, 157, 219);

InputDecoration kFormFieldDecoration(
    {String? labelText, IconData? icon, Widget? suffixIcon}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: kPurpleColor),
    prefixIcon: icon != null ? Icon(icon, color: kPurpleColor) : null,
    suffixIcon: suffixIcon, // Add suffixIcon support
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: kPurpleColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: kPurpleColor, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: kLightPurpleColor),
    ),
  );
}
// --------------------------------------------------------

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Unused state variables kept as per instructions
  List<String> _gender = ["Male", "Female"];
  final TextEditingController nameController = TextEditingController();
  String gender = "";
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();

  // Core state variables
  bool isseen = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final AuthServices _authservice = AuthServices();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var _isloader = false;
  get isloader => _isloader;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Moved Future function inside build for access to context,
    // though defining it inside the State class is often cleaner.
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
      // --- ENHANCEMENT: AppBar style for purple theme ---
      appBar: AppBar(
        title: const Text("Login", style: TextStyle(color: Colors.white)),
        backgroundColor: kPurpleColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0, // Removed shadow
      ),

      // Used SingleChildScrollView to prevent overflow on small devices
      body: SingleChildScrollView(
        // Increased padding for better visual spacing
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Replaced custom spacing (13) with standard SizedBox
            children: [
              // --- ENHANCEMENT: Logo/Icon Space (Optional) ---
             
              Container(
                margin: EdgeInsets.only(bottom: 30, top: 20),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: kPurpleColor, width: 2),
                      ),
                    ),
                  ],
                ),
              ),
              // heading
              const Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32, // Larger heading
                  fontWeight: FontWeight.bold,
                  color: kPurpleColor, // Purple heading
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign in to continue to your account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),

              Form(
                key: _formkey,
                child: Column(
                  // Replaced custom spacing (15) with standard SizedBox
                  children: [
                    TextFormField(
                      // --- ENHANCEMENT: Applied kFormFieldDecoration ---
                      decoration: kFormFieldDecoration(
                        labelText: "Email",
                        icon: Icons.email,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: FormValidations.validateEmail,
                    ),
                    const SizedBox(height: 20), // Increased spacing

                    TextFormField(
                      obscureText: isseen,
                      // --- ENHANCEMENT: Applied kFormFieldDecoration and styled suffixIcon ---
                      decoration: kFormFieldDecoration(
                        labelText: "Password",
                        icon: Icons.lock,
                        suffixIcon: GestureDetector(
                          child: Icon(
                            isseen ? Icons.visibility : Icons.visibility_off,
                            color: kPurpleColor, // Icon color
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
              const SizedBox(height: 10),

              // --- ENHANCEMENT: Forgot Password Button Alignment/Styling ---
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Removed Padding widget from inside the Row child
                  GestureDetector(
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: kPurpleColor, // Purple link color
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Forgotpassword()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),

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
                  // --- ENHANCEMENT: Button Style for Purple Theme ---
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurpleColor, // Button color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: isloader
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white, // Loader color
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              // --- ENHANCEMENT: Register Link Styling ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    child: const Text(
                      "Register Now",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kPurpleColor, // Purple link color
                      ),
                    ),
                    onTap: () {
                      // Note: Assuming 'goto' is a helper function you defined
                      goto(RegisterScreen(), context);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
