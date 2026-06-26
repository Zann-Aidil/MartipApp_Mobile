import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('martip.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE,
        phone TEXT UNIQUE,
        password TEXT NOT NULL,
        phone_verified INTEGER DEFAULT 0,
        identity_type TEXT,
        identity_number TEXT UNIQUE,
        identity_verified INTEGER DEFAULT 0,
        profile_photo_path TEXT,
        address TEXT,
        city TEXT,
        province TEXT,
        postal_code TEXT,
        onopay_phone TEXT,
        status TEXT DEFAULT 'active',
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    // Create merchants table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS merchants (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        logo_url TEXT,
        phone TEXT,
        address TEXT,
        city TEXT,
        latitude REAL,
        longitude REAL,
        opening_time TEXT,
        closing_time TEXT,
        is_open_24h INTEGER DEFAULT 0,
        facilities TEXT,
        rating REAL,
        review_count INTEGER DEFAULT 0,
        commission_rate REAL,
        status TEXT DEFAULT 'approved',
        created_at TEXT,
        updated_at TEXT,
        synced_at TEXT
      )
    ''');

    // Create deposits table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS deposits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        merchant_id INTEGER NOT NULL,
        item_type TEXT,
        item_description TEXT,
        item_photos TEXT,
        duration_unit TEXT,
        duration_value INTEGER,
        special_notes TEXT,
        estimated_amount REAL,
        final_amount REAL,
        deposit_code TEXT UNIQUE,
        status TEXT DEFAULT 'pending',
        deposit_time TEXT,
        received_time TEXT,
        withdraw_time TEXT,
        qr_code TEXT,
        synced INTEGER DEFAULT 0,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (merchant_id) REFERENCES merchants(id)
      )
    ''');

    // Create reviews table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS reviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deposit_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        merchant_id INTEGER NOT NULL,
        rating INTEGER,
        comment TEXT,
        photos TEXT,
        helpful_count INTEGER DEFAULT 0,
        synced INTEGER DEFAULT 0,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (deposit_id) REFERENCES deposits(id),
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (merchant_id) REFERENCES merchants(id),
        UNIQUE (deposit_id, user_id)
      )
    ''');

    // Create onopay_transactions table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS onopay_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_id TEXT UNIQUE,
        deposit_id INTEGER,
        payer_phone TEXT,
        receiver_phone TEXT,
        amount REAL,
        status TEXT,
        response_data TEXT,
        synced INTEGER DEFAULT 0,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (deposit_id) REFERENCES deposits(id)
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_merchants_city ON merchants(city)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_deposits_user ON deposits(user_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_deposits_status ON deposits(status)');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
