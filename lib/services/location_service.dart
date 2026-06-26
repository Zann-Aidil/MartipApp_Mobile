import 'package:martip_mobile/services/api_service.dart';
import 'package:martip_mobile/models/location_model.dart';
import 'package:martip_mobile/helpers/logger_helper.dart';
import 'package:martip_mobile/constants/app_constants.dart';

class LocationService {
  // DATA DUMMY LOKASI (Bisa diubah/ditambah dari sini oleh Admin/Developer)
  static final List<Location> dummyLocations = [
    Location(
      id: 'loc_1',
      name: 'Kopi Masa Muda Point',
      address: 'Jl. Bhayangkara Medan Pancing',
      latitude: -6.1767,
      longitude: 106.8306,
      phoneNumber: '081234567890',
      email: 'kmuda@martip.id',
      imageUrl: 'assets/images/Kopie Masa Muda.jpg',
      rating: 4.8,
      reviewCount: 250,
      isOpen: true,
      operatingHours: '06:00 - 22:00',
      amenities: ['CCTV 24 Jam', 'Ruang AC', 'Asuransi Kehilangan'],
      pricePerDay: 25000,
    ),
    Location(
      id: 'loc_2',
      name: 'Bandara Kualanamu KNO',
      address: 'Jalan Sultan Serdang, Deli Serdang, Sumatera Utara',
      latitude: -6.1256,
      longitude: 106.6558,
      phoneNumber: '081291265532',
      email: 'kno@martip.id',
      imageUrl: 'assets/images/bandara kno.jpg',
      rating: 5.0,
      reviewCount: 412,
      isOpen: true,
      operatingHours: '24 Jam',
      amenities: ['CCTV 24 Jam', 'Loker Khusus', 'Asuransi Kehilangan', 'Troli'],
      pricePerDay: 50000,
    ),
    Location(
      id: 'loc_3',
      name: 'JNE Medan Area',
      address: 'Jl. aksara No.76, Medan Area',
      latitude: -6.2435,
      longitude: 106.7979,
      phoneNumber: '081255556666',
      email: 'jne@martip.id',
      imageUrl: 'assets/images/1782198568_spx-express-medan-timur-hub-716234qpxbj.jpg',
      rating: 4.7,
      reviewCount: 120,
      isOpen: true,
      operatingHours: '10:00 - 22:00',
      amenities: ['CCTV 24 Jam', 'Asuransi Kehilangan'],
      pricePerDay: 10000,
    ),
  ];

  // Get all locations
  static Future<List<Location>> getLocations({int page = 1}) async {
    try {
      LoggerHelper.info('Fetching locations - page: $page');
      
      // Menggunakan data lokal (Offline First)
      await Future.delayed(const Duration(milliseconds: 300));
      return dummyLocations;
    } catch (e, stackTrace) {
      LoggerHelper.error('Get locations failed: $e', e, stackTrace);
      return dummyLocations; // Fallback to dummy
    }
  }

  // Get location detail
  static Future<Location> getLocationDetail(String locationId) async {
    try {
      LoggerHelper.info('Fetching location detail: $locationId');

      await Future.delayed(const Duration(milliseconds: 200));
      
      final loc = dummyLocations.firstWhere(
        (loc) => loc.id == locationId, 
        orElse: () => throw Exception('Location not found')
      );
      return loc;
    } catch (e, stackTrace) {
      LoggerHelper.error('Get location detail failed: $e', e, stackTrace);
      rethrow;
    }
  }

  // Search locations by name or address
  static Future<List<Location>> searchLocations(String query) async {
    try {
      LoggerHelper.info('Searching locations: $query');

      await Future.delayed(const Duration(milliseconds: 200));
      final lowerQuery = query.toLowerCase();
      return dummyLocations.where((loc) => 
        loc.name.toLowerCase().contains(lowerQuery) || 
        loc.address.toLowerCase().contains(lowerQuery)
      ).toList();
    } catch (e, stackTrace) {
      LoggerHelper.error('Search locations failed: $e', e, stackTrace);
      rethrow;
    }
  }
}
