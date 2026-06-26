import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/user_model.dart';

class UserRepository {
  final _db = AppDatabase.instance;

  // CREATE - Register user
  Future<int> createUser(UserModel user) async {
    final database = await _db.database;
    return await database.insert('users', user.toJson());
  }

  // READ - Get user by phone
  Future<UserModel?> getUserByPhone(String phone) async {
    final database = await _db.database;
    final result = await database.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
    );
    
    if (result.isEmpty) return null;
    return UserModel.fromJson(result.first);
  }

  // READ - Get user by email
  Future<UserModel?> getUserByEmail(String email) async {
    final database = await _db.database;
    final result = await database.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    
    if (result.isEmpty) return null;
    return UserModel.fromJson(result.first);
  }

  // READ - Get user by ID
  Future<UserModel?> getUserById(int id) async {
    final database = await _db.database;
    final result = await database.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isEmpty) return null;
    return UserModel.fromJson(result.first);
  }

  // UPDATE - Update user
  Future<int> updateUser(UserModel user) async {
    final database = await _db.database;
    return await database.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // UPDATE - Update profile photo
  Future<int> updateProfilePhoto(int userId, String photoPath) async {
    final database = await _db.database;
    return await database.update(
      'users',
      {'profile_photo_path': photoPath},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // UPDATE - Verify phone
  Future<int> verifyPhone(int userId) async {
    final database = await _db.database;
    return await database.update(
      'users',
      {
        'phone_verified': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // UPDATE - Verify identity
  Future<int> verifyIdentity(int userId) async {
    final database = await _db.database;
    return await database.update(
      'users',
      {
        'identity_verified': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // DELETE - Delete user
  Future<int> deleteUser(int id) async {
    final database = await _db.database;
    return await database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Check if email exists
  Future<bool> emailExists(String email) async {
    final database = await _db.database;
    final result = await database.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // Check if phone exists
  Future<bool> phoneExists(String phone) async {
    final database = await _db.database;
    final result = await database.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
    );
    return result.isNotEmpty;
  }
}
