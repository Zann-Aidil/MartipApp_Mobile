import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MartipApp/constants/app_colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bantuan', style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text(
            'Pusat Bantuan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Temukan jawaban atas pertanyaan Anda atau hubungi layanan pelanggan kami.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          _buildFaqItem(
            'Bagaimana cara menitipkan barang?',
            'Anda dapat menitipkan barang dengan mencari lokasi penitipan terdekat di Beranda, lalu klik "Titip Barang" dan isi formulir yang tersedia.',
          ),
          const Divider(),
          _buildFaqItem(
            'Apa itu pembayaran OnoPay?',
            'OnoPay adalah sistem pembayaran digital resmi kami. Anda bisa mengisi saldo atau menggunakan QR Code dari web untuk memotong saldo secara otomatis.',
          ),
          const Divider(),
          _buildFaqItem(
            'Bagaimana jika barang saya hilang?',
            'Semua barang yang dititipkan melalui Martip dilindungi asuransi dasar. Jika terjadi kehilangan, segera laporkan ke pihak mitra dan customer service kami.',
          ),
          const SizedBox(height: 32),
          const Text(
            'Hubungi Kami',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.email, color: AppColors.primary),
            title: const Text('Email Support'),
            subtitle: const Text('support@martip.com'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: AppColors.primary),
            title: const Text('Call Center'),
            subtitle: const Text('1500-123'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w500)),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(answer, style: const TextStyle(color: Colors.grey)),
        )
      ],
    );
  }
}
