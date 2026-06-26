import 'package:get/get.dart';
import 'package:martip_mobile/services/location_service.dart';
import 'package:martip_mobile/models/location_model.dart';
import 'package:martip_mobile/helpers/logger_helper.dart';

class LocationController extends GetxController {
  static LocationController get to => Get.find();

  final locations = <Location>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedLocation = Rx<Location?>(null);
  final searchResults = <Location>[].obs;
  final searchQuery = ''.obs;

  // Pagination
  final currentPage = 1.obs;
  final hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    getLocations();
  }

  // Get all locations
  Future<void> getLocations({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        locations.clear();
        hasMoreData.value = true;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final newLocations = await LocationService.getLocations(
        page: currentPage.value,
      );

      if (newLocations.isEmpty) {
        hasMoreData.value = false;
      } else {
        if (refresh) {
          locations.value = newLocations;
        } else {
          locations.addAll(newLocations);
        }
        currentPage.value++;
      }

      LoggerHelper.info('Loaded ${newLocations.length} locations');
    } catch (e, stackTrace) {
      errorMessage.value = 'Gagal memuat lokasi: $e';
      LoggerHelper.error('Get locations error: $e', e, stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  // Get location detail
  Future<void> getLocationDetail(String locationId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final location = await LocationService.getLocationDetail(locationId);
      selectedLocation.value = location;

      LoggerHelper.info('Loaded location: ${location.name}');
    } catch (e, stackTrace) {
      errorMessage.value = 'Gagal memuat detail lokasi: $e';
      LoggerHelper.error('Get location detail error: $e', e, stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  // Search locations
  Future<void> searchLocations(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      searchQuery.value = '';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await LocationService.searchLocations(query);
      searchResults.value = results;
      searchQuery.value = query;

      LoggerHelper.info('Search found ${results.length} locations for: $query');
    } catch (e, stackTrace) {
      errorMessage.value = 'Gagal mencari lokasi: $e';
      LoggerHelper.error('Search locations error: $e', e, stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  // Clear search
  void clearSearch() {
    searchResults.clear();
    searchQuery.value = '';
    errorMessage.value = '';
  }

  void clearError() {
    errorMessage.value = '';
  }

  // Add new location
  Future<bool> addLocation({
    required String name,
    required String address,
    required String phone,
    required String email,
    required double pricePerDay,
    required String openTime,
    required String closeTime,
    required List<String> amenities,
    double latitude = 0.0,
    double longitude = 0.0,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Create new location object
      final newLocation = Location(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        address: address,
        latitude: latitude,
        longitude: longitude,
        phoneNumber: phone,
        email: email,
        imageUrl: 'https://via.placeholder.com/300x200?text=$name',
        rating: 5.0,
        reviewCount: 0,
        isOpen: true,
        operatingHours: '$openTime - $closeTime',
        amenities: amenities,
        pricePerDay: pricePerDay,
      );

      // Add to local list
      locations.insert(0, newLocation);

      LoggerHelper.info('New location added: $name');
      return true;
    } catch (e, stackTrace) {
      errorMessage.value = 'Gagal menambahkan lokasi: $e';
      LoggerHelper.error('Add location error: $e', e, stackTrace);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
