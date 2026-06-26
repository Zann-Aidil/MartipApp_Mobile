class Location {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? phoneNumber;
  final String? email;
  final String? imageUrl;
  final double rating;
  final int reviewCount;
  final bool isOpen;
  final String operatingHours;
  final List<String> amenities;
  final double pricePerDay;

  Location({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phoneNumber,
    this.email,
    this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.isOpen,
    required this.operatingHours,
    required this.amenities,
    required this.pricePerDay,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      imageUrl: json['imageUrl'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int? ?? 0,
      isOpen: json['isOpen'] as bool? ?? true,
      operatingHours: json['operatingHours'] as String? ?? '24 Jam',
      amenities: List<String>.from(json['amenities'] as List? ?? []),
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'email': email,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'isOpen': isOpen,
      'operatingHours': operatingHours,
      'amenities': amenities,
      'pricePerDay': pricePerDay,
    };
  }

  @override
  String toString() => 'Location(id: $id, name: $name, address: $address)';
}
