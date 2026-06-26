import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/deposit_model.dart';
import 'package:uuid/uuid.dart';

class DepositRepository {
  final _db = AppDatabase.instance;
  final _uuid = Uuid();

  // CREATE
  Future<int> createDeposit(DepositModel deposit) async {
    final database = await _db.database;
    
    // Generate deposit code if null
    Map<String, dynamic> data = deposit.toJson();
    if (data['deposit_code'] == null) {
      data['deposit_code'] = 'TRX-${DateTime.now().millisecondsSinceEpoch}';
    }
    
    return await database.insert('deposits', data);
  }

  // READ - Get by ID
  Future<DepositModel?> getDepositById(int id) async {
    final database = await _db.database;
    final result = await database.query(
      'deposits',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isEmpty) return null;
    return DepositModel.fromJson(result.first);
  }

  // READ - Get by User ID
  Future<List<DepositModel>> getDepositsByUserId(int userId) async {
    final database = await _db.database;
    final result = await database.query(
      'deposits',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    
    return result.map((json) => DepositModel.fromJson(json)).toList();
  }

  // UPDATE
  Future<int> updateDeposit(DepositModel deposit) async {
    final database = await _db.database;
    return await database.update(
      'deposits',
      deposit.toJson(),
      where: 'id = ?',
      whereArgs: [deposit.id],
    );
  }

  // UPDATE STATUS
  Future<int> updateDepositStatus(int id, String status) async {
    final database = await _db.database;
    
    Map<String, dynamic> data = {
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    if (status == 'active') {
      data['deposit_time'] = DateTime.now().toIso8601String();
    } else if (status == 'completed') {
      data['withdraw_time'] = DateTime.now().toIso8601String();
    }
    
    return await database.update(
      'deposits',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // UPDATE QR CODE
  Future<int> updateQRCode(int id, String qrCode) async {
    final database = await _db.database;
    return await database.update(
      'deposits',
      {
        'qr_code': qrCode,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE
  Future<int> deleteDeposit(int id) async {
    final database = await _db.database;
    return await database.delete(
      'deposits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
