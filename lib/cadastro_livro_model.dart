import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CadastroLivroModel {
  late final Database _database;
  late List<Map<String, dynamic>> _livros;

  Future<void> openDatabaseAndFetchData() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'livros_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE livros(id INTEGER PRIMARY KEY, nome TEXT, autor TEXT, classificacao TEXT)',
        );
      },
      version: 1,
    );
    await _atualizarListaLivros();
  }

  Future<void> cadastrarLivro(Map<String, String> livro) async {
    await _database.insert(
      'livros',
      livro,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _limparCampos();
    await _atualizarListaLivros();
  }

  Future<void> _atualizarListaLivros() async {
    final livros = await _database.query('livros');
    _livros = livros;
  }

  Future<void> apagarDados() async {
    await _database.delete('livros');
    await _atualizarListaLivros();
  }

  void _limparCampos() {
    // Implementação para limpar os campos
  }

  List<Map<String, dynamic>> get livros => _livros;
}
