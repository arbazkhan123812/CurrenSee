import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_project/services/storage_service.dart';
import 'package:my_project/utils/helper.dart';
import 'package:my_project/views/Admin/view_products.dart';

class EditProducts extends StatefulWidget {
  var data;
  var docId;
  EditProducts({super.key, required this.docId, required this.data});
  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  ImagePicker _picker = ImagePicker();
  StorageService _storageService = StorageService();
  TextEditingController titleController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController priceController = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool is_loading = false;
  Uint8List? _image;
  String? edit_image;
  String? imageName;

  Future<String?> pickImage(ImageSource source) async {
    // Function to pick image from gallery or camera
    try {
      var picked_image = await _picker.pickImage(source: source);

      if (picked_image != null) {
        _image = await picked_image.readAsBytes();
        imageName = picked_image.name;
        setState(() {});
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  void handleProductUpdate() async {
    if (!(_formkey.currentState?.validate() ?? false)) return;
    try {
      final double price = double.tryParse(priceController.text.trim()) ?? 0;
      final int stock = int.tryParse(stockController.text.trim()) ?? 0;

      var res = await _storageService.updateProductData(
        widget.docId,
        titleController.text,
        price,
        stock,
        descriptioncontroller.text,
        imageName,
        _image,
      );

          
     
    } catch (e) {

      e.toString();
    }
  }

  @override
  void initState() {
    titleController.text = widget.data['product_title'] ?? '0';
    stockController.text = widget.data['product_stock']?.toString() ?? '';
    descriptioncontroller.text = widget.data['product_description'] ?? '';
    priceController.text = widget.data['product_price']?.toString() ?? '';
    edit_image = widget.data['imageUrl'];
    print(widget.data);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Text("Please enter product details here.")),
              SizedBox(height: 20),
              Form(
                key: _formkey,
                child: Column(
                  spacing: 15,
                  children: [
                    InkWell(
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black12,
                          image: _image != null
                              ? DecorationImage(
                                  image: MemoryImage(_image!),
                                  fit: BoxFit.contain,
                                )
                              : (edit_image != null
                                  ? DecorationImage(
                                      image: NetworkImage(edit_image!),
                                      fit: BoxFit.contain,
                                    )
                                  : null), // no image
                        ),
                        child: (_image == null || edit_image == null ) 
                            ? Center(
                                child: Text(
                                  "Upload Image",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              )
                            : null,
                      ),
                      onTap: () {
                        bottomsheet(context);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Please enter product title",
                        prefixIcon: Icon(Icons.add_box),
                      ),
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Product title is required";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Please enter product stock",
                        prefixIcon: Icon(Icons.add_box),
                      ),
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Stock is required";
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return "Please enter a valid number";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Please enter product description",
                        prefixIcon: Icon(Icons.add_box),
                      ),
                      controller: descriptioncontroller,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Description is required";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Please enter product price",
                        prefixIcon: Icon(Icons.add_box),
                      ),
                      controller: priceController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Price is required";
                        }
                        if (double.tryParse(value.trim()) == null) {
                          return "Please enter a valid price";
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        handleProductUpdate();
                      },
                      child: is_loading
                          ? SizedBox(
                              height: 20, // Height kam kiya
                              width: 20, // Width kam kiya
                              child: CircularProgressIndicator(
                                strokeWidth:
                                    3, // Indicator ki thickness kam ki, taaki chota dikhe
                                valueColor: AlwaysStoppedAnimation<Color>(Colors
                                    .white), // Agar default color visible na ho toh
                              ),
                            )
                          : Text("Submit"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          goto(ViewProducts(), context);
        },
        label: Icon(
          Iconsax.shop,
          color: Colors.white,
        ),
      ),
    );
  }

  void bottomsheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt_outlined),
                iconColor: Colors.black,
                title: Text("Select from camera"),
                onTap: () {
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_outlined),
                iconColor: Colors.black,
                title: Text("Select from gallery"),
                onTap: () {
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
