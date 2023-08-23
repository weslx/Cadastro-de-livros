import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(CadastroLivrosApp());
}

class CadastroLivrosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Livros',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF2D2D37),
        primaryColor: Color.fromARGB(255, 250, 250, 250),
        hintColor: Color.fromARGB(255, 44, 44, 42),
        iconTheme: IconThemeData(color: Color(0xFFFFC500)),
      ),
      home: CadastroLivroScreen(),
    );
  }
}

class CadastroLivroScreen extends StatefulWidget {
  @override
  _CadastroLivroScreenState createState() => _CadastroLivroScreenState();
}

class _CadastroLivroScreenState extends State<CadastroLivroScreen> {
  late final TextEditingController _nomeController;
  late final TextEditingController _autorController;
  late final TextEditingController _classificacaoController;
  late final Database _database;
  late List<Map<String, dynamic>> _livros;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _autorController = TextEditingController();
    _classificacaoController = TextEditingController();
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
    _atualizarListaLivros();
  }

  Future<void> _cadastrarLivro() async {
    final livro = {
      'nome': _nomeController.text,
      'autor': _autorController.text,
      'classificacao': _classificacaoController.text,
    };
    await _database.insert(
      'livros',
      livro,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _limparCampos();
    _atualizarListaLivros();
  }

  Future<void> _atualizarListaLivros() async {
    final livros = await _database.query('livros');
    setState(() {
      _livros = livros;
    });
  }

  Future<void> _apagarDados() async {
    await _database.delete('livros');
    _atualizarListaLivros();
  }

  void _limparCampos() {
    _nomeController.clear();
    _autorController.clear();
    _classificacaoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Livros'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome do Livro'),
              ),
              TextField(
                controller: _autorController,
                decoration: InputDecoration(labelText: 'Autor do Livro'),
              ),
              TextField(
                controller: _classificacaoController,
                decoration: InputDecoration(labelText: 'Classificação do Livro'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _cadastrarLivro,
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).hintColor,
                ),
                child: Text('Cadastrar Livro'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.home),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => LivrosDialog(livros: _livros),
                  );
                },
                icon: Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ApagarDadosDialog(onApagarDados: _apagarDados),
                  );
                },
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LivrosDialog extends StatelessWidget {
  final List<Map<String, dynamic>> livros;

  LivrosDialog({required this.livros});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Livros Cadastrados'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: livros.map((livro) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome: ${livro['nome']}',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Autor: ${livro['autor']}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Classificação: ${livro['classificacao']}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Fechar'),
        ),
      ],
    );
  }
}

class ApagarDadosDialog extends StatelessWidget {
  final VoidCallback onApagarDados;

  ApagarDadosDialog({required this.onApagarDados});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Apagar Dados',
        style: TextStyle(color: Colors.red),
      ),
      content: Text('Deseja realmente apagar todos os dados?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            onApagarDados();
            Navigator.pop(context);
          },
          child: Text(
            'Apagar',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
