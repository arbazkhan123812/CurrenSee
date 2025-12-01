import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_project/services/auth_services.dart';
import 'package:my_project/services/storage_service.dart';
import 'package:my_project/utils/helper.dart';
import 'package:my_project/views/ai_chat_screen.dart';
import 'package:my_project/views/login.dart';
import 'package:my_project/views/register.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // image picking and uploading process

  String email = "";
  Uint8List? _image;
  String imageName = "";
  ImagePicker _picker = ImagePicker();
  StorageService _storageService = StorageService();
  AuthServices _auth = AuthServices();

  Future<String?> pickImage(ImageSource source) async {
    var pickedimage = await _picker.pickImage(source: source);

    try {
      if (pickedimage != null) {
        _image = await pickedimage.readAsBytes();
        imageName = pickedimage.name;

        // upload image

        handleUploadImage();
        setState(() {});
      } else {
        throw "something went wrong or user dont gave permission";
      }
    } catch (e) {
      e.toString();
    }
  }

  handleUploadImage() async {
    await _storageService.uploadeProfileImage(_image!, imageName).then(
      (value) {
        showNotificationn("Success", "Image Successfully Uploaded!", context);
      },
    ).catchError((error) {
      showNotificationn("Error", error.toString(), context, isError: true);
    });
  }

  void logoutuser(String email) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Sign Out"),
          content: Text("Are you sure you wants to sign out?"),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await _auth.logout(email).then((value) {}).catchError((v) {
                    showNotificationn("Error", v.toString(), context);
                  });
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                } catch (e) {
                  e.toString();
                }
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _auth.profileuserdata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("No data found"));
            }

            final data = snapshot.data!;
            email = data['email'];

            return Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    _image != null
                        ? CircleAvatar(
                            backgroundColor: Colors.indigo.shade200,
                            backgroundImage: MemoryImage(_image!),
                            radius: 50,
                          )
                        : data['imageUrl'] == null
                            ? CircleAvatar(
                                backgroundColor: Colors.indigo.shade200,
                                radius: 50,
                                child: Text(
                                  data['user_name'][0].toUpperCase(),
                                  // Default letter if null or empty
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.indigo.shade200,
                                backgroundImage:
                                    NetworkImage(data['imageUrl']!),
                                radius: 50,
                              ),
                    GestureDetector(
                      onTap: () {
                        showpictureOptions(context);
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.indigo,
                        radius: 15,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['user_name'] ?? '',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      data['email'] ?? 'noemail@gmail.com',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Column(
                  children: [
                    Card(
                      color: Colors.indigo.shade200,
                      child: const ListTile(
                        leading: Icon(Icons.edit),
                        title: Text("Edit Profile"),
                        trailing: Icon(Icons.chevron_right),
                      ),
                    ),
                    Card(
                      color: Colors.indigo.shade200,
                      child: const ListTile(
                        leading: Icon(Icons.lock),
                        title: Text("Change Password"),
                        trailing: Icon(Icons.chevron_right),
                      ),
                    ),
                    // Profile.dart file mein Card list ke ander ye card add karen:

                    Card(
                      color: Colors.amber.shade100,
                      child: ListTile(
                        leading:
                            Icon(Icons.smart_toy, color: Colors.amber[800]),
                        title: Text("AI Crypto Assistant"),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AIChatScreen()),
                          );
                        },
                      ),
                    ),
                    Card(
                      color: Colors.indigo.shade200,
                      child: const ListTile(
                        leading: Icon(Icons.settings),
                        title: Text("Settings"),
                        trailing: Icon(Icons.chevron_right),
                      ),
                    ),
                    Card(
                      color: Colors.red.shade200,
                      child: ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text("Logout"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          logoutuser(email);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void showpictureOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  var msg = pickImage(ImageSource.camera);
                  print(msg.toString());
                },
                leading: Icon(Icons.camera_alt_outlined),
                title: Text("Capture from camera"),
                trailing: Icon(Icons.chevron_right),
              ),
              ListTile(
                onTap: () {
                  pickImage(ImageSource.gallery);
                },
                leading: Icon(Icons.photo_outlined),
                title: Text("Choose from gallery"),
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ),
        );
      },
    );
  }
}
