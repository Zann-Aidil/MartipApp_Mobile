import 'dart:convert';

class DepositModel {
  final int? id;
  final int userId;
  final int merchantId;
  final String itemType;
  final String itemDescription;
  final List<String> itemPhotos;
  final String durationUnit;
  final int durationValue;
  final String? specialNotes;
  final double estimatedAmount;
  final double? finalAmount;
  final String? depositCode;
  final String status;
  final DateTime? depositTime;
  final DateTime? receivedTime;
  final DateTime? withdrawTime;
  final String? qrCode;
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;

  DepositModel({
    this.id,
    required this.userId,
    required this.merchantId,
    required this.itemType,
    required this.itemDescription,
    required this.itemPhotos,
    required this.durationUnit,
    required this.durationValue,
    this.specialNotes,
    required this.estimatedAmount,
    this.finalAmount,
    this.depositCode,
    this.status = 'pending',
    this.depositTime,
    this.receivedTime,
    this.withdrawTime,
    this.qrCode,
    this.synced = false,
    required this.createdAt,
    required this.updatedAt,
  });

  DepositModel copyWith({
    int? id,
    int? userId,
    int? merchantId,
    String? itemType,
    String? itemDescription,
    List<String>? itemPhotos,
    String? durationUnit,
    int? durationValue,
    String? specialNotes,
    double? estimatedAmount,
    double? finalAmount,
    String? depositCode,
    String? status,
    DateTime? depositTime,
    DateTime? receivedTime,
    DateTime? withdrawTime,
    String? qrCode,
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DepositModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      merchantId: merchantId ?? this.merchantId,
      itemType: itemType ?? this.itemType,
      itemDescription: itemDescription ?? this.itemDescription,
      itemPhotos: itemPhotos ?? this.itemPhotos,
      durationUnit: durationUnit ?? this.durationUnit,
      durationValue: durationValue ?? this.durationValue,
      specialNotes: specialNotes ?? this.specialNotes,
      estimatedAmount: estimatedAmount ?? this.estimatedAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      depositCode: depositCode ?? this.depositCode,
      status: status ?? this.status,
      depositTime: depositTime ?? this.depositTime,
      receivedTime: receivedTime ?? this.receivedTime,
      withdrawTime: withdrawTime ?? this.withdrawTime,
      qrCode: qrCode ?? this.qrCode,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'merchant_id': merchantId,
    'item_type': itemType,
    'item_description': itemDescription,
    'item_photos': jsonEncode(itemPhotos),
    'duration_unit': durationUnit,
    'duration_value': durationValue,
    'special_notes': specialNotes,
    'estimated_amount': estimatedAmount,
    'final_amount': finalAmount,
    'deposit_code': depositCode,
    'status': status,
    'deposit_time': depositTime?.toIso8601String(),
    'received_time': receivedTime?.toIso8601String(),
    'withdraw_time': withdrawTime?.toIso8601String(),
    'qr_code': qrCode,
    'synced': synced ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory DepositModel.fromJson(Map<String, dynamic> json) => DepositModel(
    id: json['id'],
    userId: json['user_id'],
    merchantId: json['merchant_id'],
    itemType: json['item_type'],
    itemDescription: json['item_description'],
    itemPhotos: json['item_photos'] != null 
        ? List<String>.from(jsonDecode(json['item_photos'])) 
        : [],
    durationUnit: json['duration_unit'],
    durationValue: json['duration_value'],
    specialNotes: json['special_notes'],
    estimatedAmount: json['estimated_amount']?.toDouble() ?? 0.0,
    finalAmount: json['final_amount']?.toDouble(),
    depositCode: json['deposit_code'],
    status: json['status'] ?? 'pending',
    depositTime: json['deposit_time'] != null ? DateTime.parse(json['deposit_time']) : null,
    receivedTime: json['received_time'] != null ? DateTime.parse(json['received_time']) : null,
    withdrawTime: json['withdraw_time'] != null ? DateTime.parse(json['withdraw_time']) : null,
    qrCode: json['qr_code'],
    synced: (json['synced'] ?? 0) == 1,
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}
