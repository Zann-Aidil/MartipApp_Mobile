class UserModel {
  final int? id;
  final String name;
  final String? email;
  final String phone;
  final String password;
  final bool phoneVerified;
  final String? identityType;
  final String? identityNumber;
  final bool identityVerified;
  final String? profilePhotoPath;
  final String? address;
  final String? city;
  final String? province;
  final String? postalCode;
  final String? onopayPhone;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    this.id,
    required this.name,
    this.email,
    required this.phone,
    required this.password,
    this.phoneVerified = false,
    this.identityType,
    this.identityNumber,
    this.identityVerified = false,
    this.profilePhotoPath,
    this.address,
    this.city,
    this.province,
    this.postalCode,
    this.onopayPhone,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'password': password,
    'phone_verified': phoneVerified ? 1 : 0,
    'identity_type': identityType,
    'identity_number': identityNumber,
    'identity_verified': identityVerified ? 1 : 0,
    'profile_photo_path': profilePhotoPath,
    'address': address,
    'city': city,
    'province': province,
    'postal_code': postalCode,
    'onopay_phone': onopayPhone,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    password: json['password'],
    phoneVerified: (json['phone_verified'] ?? 0) == 1,
    identityType: json['identity_type'],
    identityNumber: json['identity_number'],
    identityVerified: (json['identity_verified'] ?? 0) == 1,
    profilePhotoPath: json['profile_photo_path'],
    address: json['address'],
    city: json['city'],
    province: json['province'],
    postalCode: json['postal_code'],
    onopayPhone: json['onopay_phone'],
    status: json['status'] ?? 'active',
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}
