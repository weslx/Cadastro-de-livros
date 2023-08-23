import 'package:flutter/material.dart';
import 'cadastro_livro_controller.dart';

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
  final CadastroLivroController _controller = CadastroLivroController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _classificacaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.inicializar();
  }

  Future<void> _cadastrarLivro() async {
    final livro = {
      'nome': _nomeController.text,
      'autor': _autorController.text,
      'classificacao': _classificacaoController.text,
    };
    await _controller.cadastrarLivro(livro);
    _limparCampos();
  }

  Future<void> _apagarDados() async {
    showDialog(
      context: context,
      builder: (context) => ApagarDadosDialog(onApagarDados: () async {
        await _controller.apagarDados();
        Navigator.pop(context); // Fecha o diálogo de confirmação
      }),
    );
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
                    builder: (context) => LivrosDialog(livros: _controller.livros),
                  );
                },
                icon: Icon(Icons.search),
              ),
              IconButton(
                onPressed: _apagarDados,
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
          onPressed: onApagarDados,
          child: Text(
            'Apagar',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
