import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loannova_mobile_app/notification_service.dart';

class KycUploadScreen extends StatefulWidget {
  const KycUploadScreen({super.key});

  @override
  State<KycUploadScreen> createState() => _KycUploadScreenState();
}

class _KycUploadScreenState extends State<KycUploadScreen> {
  final ImagePicker _picker = ImagePicker();

  File? panImage;
  File? aadhaarImage;
  File? salaryImage;

  Future<void> _pickImage(String docType) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (docType == 'PAN') panImage = File(pickedFile.path);
        if (docType == 'Aadhaar') aadhaarImage = File(pickedFile.path);
        if (docType == 'Salary') salaryImage = File(pickedFile.path);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$docType image selected successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool canSubmit = panImage != null && aadhaarImage != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital KYC & Documents'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Upload Verification Documents',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Select photos of your documents from your device gallery to verify your account.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // PAN Card Tile
          _buildDocCard(
            title: 'PAN Card',
            subtitle: 'Required for tax & credit verification',
            selectedImage: panImage,
            onTap: () => _pickImage('PAN'),
          ),

          // Aadhaar Card Tile
          _buildDocCard(
            title: 'Aadhaar Card (Identity Proof)',
            subtitle: 'Front and back copy required',
            selectedImage: aadhaarImage,
            onTap: () => _pickImage('Aadhaar'),
          ),

          // Salary Slip Tile
          _buildDocCard(
            title: 'Salary Slip / Income Proof',
            subtitle: 'Last 3 months statements (Optional)',
            selectedImage: salaryImage,
            onTap: () => _pickImage('Salary'),
          ),

          const SizedBox(height: 30),

          // Submit KYC Button
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: canSubmit
                  ? () {
                // ---> ADD THE NOTIFICATION HERE <---
                NotificationService().addNotification(
                  title: 'KYC Documents Submitted',
                  message: 'Your PAN and identity proofs have been securely uploaded for review.',
                  icon: Icons.verified_user,
                  color: Colors.blue,
                );
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('KYC Submitted!'),
                    content: const Text('Your documents have been securely attached and submitted for review.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Return home
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                );
              }
                  : null, // Disabled until PAN and Aadhaar are picked
              child: const Text('Submit KYC Documents', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocCard({
    required String title,
    required String subtitle,
    required File? selectedImage,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: selectedImage != null
            ? Image.file(selectedImage, width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.insert_drive_file, size: 40, color: Colors.indigo),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(subtitle, style: const TextStyle(fontSize: 12)),
        ),
        trailing: ElevatedButton(
          onPressed: onTap,
          child: Text(selectedImage == null ? 'Upload' : 'Change'),
        ),
      ),
    );
  }
}