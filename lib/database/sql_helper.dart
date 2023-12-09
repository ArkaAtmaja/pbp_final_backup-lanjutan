import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //create db
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE berita(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        judul TEXT,
        deskripsi TEXT,
        kategori TEXT,
        lokasi TEXT,
        imagePath
      )
    """);

    await database.execute("""
    CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        username TEXT,
        email TEXT,
        password TEXT,
        tanggalLahir TEXT, 
        noTelp TEXT,
        gender TEXT,
      )
  """);
      await database.execute("""
    CREATE TABLE news(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        judul TEXT,
        kategoori TEXT,
        deskripsi TEXT,
      )
  """);
  }

  //call db

  static Future<sql.Database> db() async {
    return sql.openDatabase('berita.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //insert Berita
  static Future<int> addBerita(
      String judul, String kategori, String deskripsi) async {
    final db = await SQLHelper.db();
    final data = {
      'judul': judul,
      'kategori': kategori,
      'deskripsi': deskripsi,
      //'lokasi': lokasi,
      
    };
    return await db.insert('berita', data);
  }

  //read Berita
  static Future<List<Map<String, dynamic>>> getBerita(String search) async {
    final db = await SQLHelper.db();
    return db.query('berita',
        where:
            'judul LIKE ? OR kategori LIKE ? OR deskripsi LIKE ? OR lokasi LIKE ?',
        whereArgs: ['%$search%']);
  }

  static Future<List<Map<String, dynamic>>> getBerita2(String search) async {
    final db = await SQLHelper.db();
    return db.query('berita',
        where:
            'judul LIKE ? OR kategori LIKE ? OR deskripsi LIKE ? OR lokasi LIKE ?',
        whereArgs: ['%$search%', '%$search%', '%$search%', '%$search%']);
  }

  //update Berita
  static Future<int> editBerita(
    int id,
    String judul,
    String kategori,
    String deskripsi,
    //String lokasi,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      'judul': judul,
      'kategori': kategori,
      'deskripsi': deskripsi,
      //'lokasi': lokasi,
    };
    return await db.update('berita', data, where: "id = $id");
  }

  static Future<int> deleteBerita(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('berita', where: "id = $id");
  }

  static Future<int> editLokasiBerita(int? id, String? lokasi) async {
    final db = await SQLHelper.db();
    final data = {'lokasi': lokasi};
    return db.update('berita', data, where: 'id = ?', whereArgs: [id]);
  }
 // user punya
  static Future<sql.Database> dbUser() async {
    return sql.openDatabase('user.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<Map<String, dynamic>> getUserByUsername(String username) async {
    final db = await dbUser();
    final List<Map<String, dynamic>> result = await db.query(
      'user',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? result[0] : {};
  }

  static Future<int> editUserByUsername(
      String username,
      String email,
      String password,
      String date,
      String phone,
      String gender,) async {
    final db = await dbUser();
    final data = {
      'email': email,
      'password': password,
      'tanggalLahir:': date,
      'noTelp': phone,
      'gender': gender,
    };
    return await db
        .update('user', data, where: "username = ?", whereArgs: [username]);
  }
  static Future<int> addUser(String username, String email,
      String password, String tanggalLahir, String noTelp, String gender) async {
    final db = await SQLHelper.dbUser();
    final data = {
      'username': username,
      'email': email,
      'password': password,
      'tanggal': tanggalLahir,
      'noTelp': noTelp,
      'gender': gender,
    };
    return await db.insert('user', data);
  }

  static Future<int> editUser(
      int id,
      String username,
      String email,
      String password,
      String tanggalLahir,
      String noTelp,
      String gender
      ) async {
    final db = await SQLHelper.dbUser();
    final data = {
      'username': username,
      'email': email,
      'password': password,
      'tanggal': tanggalLahir,
      'noTelp': noTelp,
      'gender': gender,
    };
    return await db.update('user', data, where: "id = $id");
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await SQLHelper.dbUser();
    return db.query('user');
  }

  static Future<int> deleteUser(int id) async {
    final db = await SQLHelper.dbUser();
    return await db.delete('user', where: "id = $id");
  }

  static Future<List<Map<String, dynamic>>> getUser(String username) async {
    final db = await dbUser();
    return db.query('user', where: "username = ?", whereArgs: [username]);
  }

  static Future<bool> isEmailUnique(String email) async {
    final db = await dbUser();
    final List<Map<String, dynamic>> result = await db.query(
      'user',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isEmpty;
  }

  static Future<bool> isUsernameUnique(String username) async {
    final db = await dbUser();
    final List<Map<String, dynamic>> result = await db.query(
      'user',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isEmpty;
  }
}
