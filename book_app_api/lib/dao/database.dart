import 'package:dotenv/dotenv.dart';
import 'package:mysql1/mysql1.dart';

class Database {
  Future<MySqlConnection> openConnection() async {
    final env = await DotEnv(includePlatformEnvironment: true)
      ..load();

    final host = env['DATABASE_HOST'] ?? env['databaseHost'] ?? '';
    final port =
        int.tryParse(env['DATABASE_PORT'] ?? env['databasePort'] ?? '') ?? 5432;
    final database = env['DATABASE_NAME'] ?? env['databaseName'] ?? '';
    final username = env['DATABASE_USER'] ?? env['databaseUser'] ?? '';
    final password = env['DATABASE_PASSWORD'] ?? env['databasePassword'] ?? '';

    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: host,
          port: port,
          user: username,
          password: password,
          db: database,
        ),
      );
      return conn;
    } catch (e, s) {
      print('Erro ao abrir a conexão com o banco de dados: $e, $s');
      rethrow; // Rethrow para que o erro seja propagado para quem chama este método
    }
  }
}
