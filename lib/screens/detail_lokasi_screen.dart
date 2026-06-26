import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:martip_mobile/constants/app_colors.dart';
import 'package:martip_mobile/models/location_model.dart';
import 'dart:io';

class DetailLokasiScreen extends StatelessWidget {
  const DetailLokasiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Location location = Get.arguments as Location;
    final String? normalizedImageUrl = location.imageUrl?.replaceAll('\\', '/');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Detail Lokasi',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Lokasi
                    normalizedImageUrl != null && normalizedImageUrl.isNotEmpty
                        ? (normalizedImageUrl.startsWith('http')
                            ? Image.network(
                                normalizedImageUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                              )
                            : (normalizedImageUrl.startsWith('assets/')
                                ? Image.asset(
                                    normalizedImageUrl,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                                  )
                                : Image.file(
                                    File(normalizedImageUrl),
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                                  )))
                        : _buildPlaceholder(),

                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location.name,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 24),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  location.address,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${location.rating} (${location.reviewCount} review)',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  'Jam',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  ': ${location.operatingHours}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  'Tarif',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  ': Rp${location.pricePerDay.toInt()}/hari',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Fasilitas',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...location.amenities.map((amenity) {
                            IconData iconData = Icons.check_circle_outline;
                            if (amenity.toLowerCase().contains('cctv')) iconData = Icons.videocam;
                            if (amenity.toLowerCase().contains('loker')) iconData = Icons.lock;
                            if (amenity.toLowerCase().contains('wifi')) iconData = Icons.wifi;
                            if (amenity.toLowerCase().contains('parkir')) iconData = Icons.local_parking;
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _buildFacilityItem(iconData, amenity),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/form');
                },
                child: const Text('PILIH & LANJUT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 200,
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(
          Icons.image,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }
}
