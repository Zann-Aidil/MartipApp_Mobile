class TransactionModel {
  final int? id;
  final String transactionId;
  final int depositId;
  final String payerPhone;
  final String receiverPhone;
  final double amount;
  final String status;
  final String? responseData;
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    this.id,
    required this.transactionId,
    required this.depositId,
    required this.payerPhone,
    required this.receiverPhone,
    required this.amount,
    required this.status,
    this.responseData,
    this.synced = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'transaction_id': transactionId,
    'deposit_id': depositId,
    'payer_phone': payerPhone,
    'receiver_phone': receiverPhone,
    'amount': amount,
    'status': status,
    'response_data': responseData,
    'synced': synced ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    id: json['id'],
    transactionId: json['transaction_id'],
    depositId: json['deposit_id'],
    payerPhone: json['payer_phone'],
    receiverPhone: json['receiver_phone'],
    amount: json['amount']?.toDouble() ?? 0.0,
    status: json['status'],
    responseData: json['response_data'],
    synced: (json['synced'] ?? 0) == 1,
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );
}
