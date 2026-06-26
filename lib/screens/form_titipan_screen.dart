import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:martip_mobile/constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FormTitipanScreen extends StatefulWidget {
  const FormTitipanScreen({Key? key}) : super(key: key);

  @override
  State<FormTitipanScreen> createState() => _FormTitipanScreenState();
}

class _FormTitipanScreenState extends State<FormTitipanScreen> {
  final TextEditingController _jenisBarangController = TextEditingController();
  final TextEditingController _durasiController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  
  String _satuanDurasi = 'Hari';
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _jenisBarangController.dispose();
    _durasiController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_jenisBarangController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Jenis barang wajib diisi', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (_durasiController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Durasi titip wajib diisi', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    
    // We can pass the input data to the konfirmasi screen using arguments.
    // Ensure you also pass the location arguments if they were passed to this screen.
    final args = Get.arguments; // Could be Location or null depending on navigation flow
    
    final formData = {
      'jenisBarang': _jenisBarangController.text.trim(),
      'durasiValue': int.tryParse(_durasiController.text.trim()) ?? 1,
      'durasiUnit': _satuanDurasi,
      'catatan': _catatanController.text.trim(),
      'imagePath': _imageFile?.path,
      'location': args,
    };
    
    Get.toNamed('/konfirmasi', arguments: formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Form Titipan', style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Jenis Barang',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _jenisBarangController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.inventory),
                  hintText: 'Contoh: Koper Besar, Tas Ransel',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Durasi Titip',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _durasiController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.schedule),
                        hintText: 'Durasi',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
                      ),
                      child: const Text('Hari', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Catatan (optional)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _catatanController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Tulis pesan untuk petugas...',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Foto Barang',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _imageFile!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, color: AppColors.primary, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              'Pilih dari Galeri',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('AJUKAN TITIP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
