import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Database _database;

  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  Future<void> _openDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'livros_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE livros(id INTEGER PRIMARY KEY, nome TEXT, autor TEXT, classificacao TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> _apagarDados() async {
    await _database.delete('livros');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Apagar Dados',
              style: TextStyle(fontSize: 18.0, color: Colors.red),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _apagarDados,
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text('Apagar Dados'),
            ),
          ],
        ),
      ),
    );
  }
}
