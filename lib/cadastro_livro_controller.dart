import 'cadastro_livro_model.dart';

class CadastroLivroController {
  final CadastroLivroModel _model = CadastroLivroModel();

  Future<void> inicializar() async {
    await _model.openDatabaseAndFetchData();
  }

  Future<void> cadastrarLivro(Map<String, String> livro) async {
    await _model.cadastrarLivro(livro);
  }

  Future<void> apagarDados() async {
    await _model.apagarDados();
  }

  List<Map<String, dynamic>> get livros => _model.livros;
}
