import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastroLivroModel {
  late final Database _database;
  late List<Map<String, dynamic>> _livros;

  Future<void> openDatabaseAndFetchData() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'livros_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE livros(id INTEGER PRIMARY KEY, nome TEXT, autor TEXT, classificacao TEXT, capa TEXT)',
        );
      },
      version: 1,
    );

    bool dataLoaded = await _checkIfDataLoaded();
    if (!dataLoaded) {
      await _loadSampleDatabase();
      await _setDataLoaded();
    }

    await _atualizarListaLivros();
  }

  Future<void> cadastrarLivro(Map<String, String> livro) async {
    await _database.insert(
      'livros',
      livro,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

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


  List<Map<String, dynamic>> get livros => _livros;

  Future<bool> _checkIfDataLoaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('data_loaded') ?? false;
  }

  Future<void> _setDataLoaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('data_loaded', true);
  }

  Future<void> _loadSampleDatabase() async {
    String path = join(await getDatabasesPath(), 'livros_database.db');
    ByteData data = await rootBundle.load('assets/sample.db');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes);

    print("Loaded sample database");
  }
}