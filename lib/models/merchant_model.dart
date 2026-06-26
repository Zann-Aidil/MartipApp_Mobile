class MerchantModel {
  final int id;
  final String name;
  final String? description;
  final String? logoUrl;
  final String? phone;
  final String? address;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String? openingTime;
  final String? closingTime;
  final bool isOpen24h;
  final String? facilities;
  final double? rating;
  final int reviewCount;
  final double? commissionRate;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;

  MerchantModel({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    this.phone,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.openingTime,
    this.closingTime,
    this.isOpen24h = false,
    this.facilities,
    this.rating,
    this.reviewCount = 0,
    this.commissionRate,
    this.status = 'approved',
    this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'logo_url': logoUrl,
    'phone': phone,
    'address': address,
    'city': city,
    'latitude': latitude,
    'longitude': longitude,
    'opening_time': openingTime,
    'closing_time': closingTime,
    'is_open_24h': isOpen24h ? 1 : 0,
    'facilities': facilities,
    'rating': rating,
    'review_count': reviewCount,
    'commission_rate': commissionRate,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'synced_at': syncedAt?.toIso8601String(),
  };

  factory MerchantModel.fromJson(Map<String, dynamic> json) => MerchantModel(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    logoUrl: json['logo_url'],
    phone: json['phone'],
    address: json['address'],
    city: json['city'],
    latitude: json['latitude']?.toDouble(),
    longitude: json['longitude']?.toDouble(),
    openingTime: json['opening_time'],
    closingTime: json['closing_time'],
    isOpen24h: (json['is_open_24h'] ?? 0) == 1,
    facilities: json['facilities'],
    rating: json['rating']?.toDouble(),
    reviewCount: json['review_count'] ?? 0,
    commissionRate: json['commission_rate']?.toDouble(),
    status: json['status'] ?? 'approved',
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    syncedAt: json['synced_at'] != null ? DateTime.parse(json['synced_at']) : null,
  );
}
