import 'package:flutter/material.dart';
import 'package:my_project/services/auth_services.dart';
import 'package:my_project/utils/validations.dart';
import 'package:my_project/views/login.dart';

// --- COLOR AND DECORATION CONSTANTS (FOR ENHANCEMENT) ---
const Color kPurpleColor = Color.fromARGB(255, 56, 18, 123);
const Color kLightPurpleColor = Color.fromARGB(255, 179, 157, 219);

InputDecoration kFormFieldDecoration({String? labelText, IconData? icon}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: kPurpleColor),
    prefixIcon: icon != null ? Icon(icon, color: kPurpleColor) : null,
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
      // --- ENHANCEMENT: AppBar color set to purple ---
      appBar: AppBar(
        title: const Text("Register", style: TextStyle(color: Colors.white)),
        backgroundColor: kPurpleColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        // Increased padding for better visual spacing
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            // Replaced custom spacing with standard SizedBox
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // heading
              const Text(
                "Create Your account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28, // Slightly larger font
                  fontWeight: FontWeight.bold,
                  color: kPurpleColor, // Set heading color to purple
                ),
              ),
              const SizedBox(height: 25), // Spacing after heading

              Form(
                key: _formkey,
                child: Column(
                  // Replaced custom spacing with standard SizedBox
                  children: [
                    TextFormField(
                      // --- ENHANCEMENT: Applied kFormFieldDecoration ---
                      decoration: kFormFieldDecoration(
                        labelText: "Name",
                        icon: Icons.person,
                      ),
                      controller: nameController,
                      validator: FormValidations.validateName,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: kFormFieldDecoration(
                        labelText: "Email",
                        icon: Icons.email,
                      ),
                      controller: emailController,
                      validator: FormValidations.validateEmail,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: kFormFieldDecoration(
                        labelText: "Phone",
                        icon: Icons.phone,
                      ),
                      controller: phoneController,
                      validator: FormValidations.validatePhone,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField(
                      // --- ENHANCEMENT: Applied kFormFieldDecoration ---
                      decoration: kFormFieldDecoration(
                        icon: Icons.male,
                        labelText: "Gender",
                      ),
                      dropdownColor: Colors.white, // Ensure dropdown background is white
                      onChanged: (value) {
                        setState(() { // Added setState to reflect selected gender immediately if needed
                          gender = value!;
                        });
                        print(gender);
                      },
                      items: _gender.map((gender) {
                        return DropdownMenuItem(
                          child: Text(gender),
                          value: gender,
                        );
                      }).toList(),
                      validator: FormValidations.validateGender,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: kFormFieldDecoration(
                        labelText: "Address",
                        icon: Icons.location_city,
                      ),
                      validator: FormValidations.validateaddress,
                      controller: addressController,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      // Added obscureText for password fields
                      obscureText: true,
                      decoration: kFormFieldDecoration(
                        labelText: "Password",
                        icon: Icons.lock,
                      ),
                      controller: passController,
                      validator: FormValidations.validatePassword,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      // Added obscureText for password fields
                      obscureText: true,
                      decoration: kFormFieldDecoration(
                        labelText: "Confirm Password",
                        icon: Icons.lock,
                      ),
                      controller: confirmpassController,
                      validator: (value) {
                        return FormValidations.confirmPassword(
                          value,
                          passController.text,
                        );
                      },
                    ),
                    const SizedBox(height: 25), // Spacing before the button
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
                        const SnackBar(content: Text("user not registered")),
                      );
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
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Spacing after the button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Replaced custom spacing with standard SizedBox
                children: [
                  const Text(
                    "Already Registered?",
                    style: TextStyle(fontSize: 15, color: Colors.black54), // Subtle text color
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    child: const Text(
                      "Login Now",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kPurpleColor, // Link color set to purple
                      ),
                    ),
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
      ),
    );
  }
}