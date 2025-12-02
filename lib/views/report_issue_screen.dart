import 'package:flutter/material.dart';
import 'package:my_project/services/feed_back_service.dart';
// If you want to allow image picking, you'll need these imports
// import 'package:image_picker/image_picker.dart';
// import 'dart:typed_data';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // For simplicity, we'll keep the image attachment logic out for now.
  // XFile? _attachedImage;
  // final ImagePicker _picker = ImagePicker();

void _submitIssue() async { // Make the function async
  if (_formKey.currentState!.validate()) {
    final title = _titleController.text;
    final description = _descriptionController.text;
    FeedbackService fs = FeedbackService();

    try {
      // 2. CALL THE ACTUAL SERVICE METHOD HERE
      await fs.submitIssueReport(title, description);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Issue Reported Successfully! Thank you for your feedback.')),
      );

      Navigator.pop(context);
    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error submitting report: ${e.toString()}')),
      );
    }
  }
}  // Optional: Function to handle image picking
  // Future<void> _pickImage() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _attachedImage = image;
  //   });
  // }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report an Issue 🐛'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const Text(
                'Tell us about the issue you encountered:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),

              // --- Issue Title Field ---
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Subject / Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.subject),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title for the issue.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- Issue Description Field ---
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Detailed Description',
                  hintText: 'Describe the steps to reproduce the issue.',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 80.0), // Align icon to top
                    child: Icon(Icons.description),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a detailed description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- Image Attachment (Optional) ---
              // Uncomment this if you implement the image picking logic:
              /*
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: Text(_attachedImage == null
                    ? 'Attach Screenshot (Optional)'
                    : 'Image Attached: ${_attachedImage!.name}'),
                trailing: _attachedImage != null
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _attachedImage = null),
                      )
                    : const Icon(Icons.photo_library),
                onTap: _pickImage,
                tileColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(height: 30),
              */

              // --- Submit Button ---
              ElevatedButton.icon(
                onPressed: _submitIssue,
                icon: const Icon(Icons.send),
                label: const Text('Submit Issue Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}