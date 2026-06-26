import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:martip_mobile/models/auth_response_model.dart';
import 'package:martip_mobile/helpers/logger_helper.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'martip.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
    LoggerHelper.info('Database and users table created');
  }

  // Insert new user
  Future<Map<String, dynamic>> insertUser(Map<String, dynamic> userMap) async {
    try {
      final db = await database;
      
      // Check if email or phone already exists
      final existingEmail = await db.query('users', where: 'email = ?', whereArgs: [userMap['email']]);
      if (existingEmail.isNotEmpty) {
        throw Exception('Email sudah terdaftar');
      }

      final existingPhone = await db.query('users', where: 'phone = ?', whereArgs: [userMap['phone']]);
      if (existingPhone.isNotEmpty) {
        throw Exception('Nomor telepon sudah terdaftar');
      }

      await db.insert('users', userMap);
      return userMap;
    } catch (e) {
      LoggerHelper.error('Error inserting user', e);
      rethrow;
    }
  }

  // Get user for login
  Future<Map<String, dynamic>?> getUser(String emailOrPhone, String password) async {
    try {
      final db = await database;
      final result = await db.query(
        'users',
        where: '(email = ? OR phone = ?) AND password = ?',
        whereArgs: [emailOrPhone, emailOrPhone, password],
      );

      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    } catch (e) {
      LoggerHelper.error('Error getting user', e);
      rethrow;
    }
  }
}
