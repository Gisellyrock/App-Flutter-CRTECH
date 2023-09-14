import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:crtech/produtos/meus_produtos.dart';
import 'package:crtech/produtos/produtos.dart';

class DetalhesProdutoMaior extends StatefulWidget {
  final Produtos produto;

  DetalhesProdutoMaior({
    required this.produto,
  });

  @override
  _DetalhesProdutoMaiorState createState() => _DetalhesProdutoMaiorState();
}

class _DetalhesProdutoMaiorState extends State<DetalhesProdutoMaior> {
  double _rating = 0.0;
  TextEditingController _commentController = TextEditingController();
  bool _comentarioEnviado = false;
  List<Produtos> produtosSugeridos = [];

  @override
  void initState() {
    super.initState();

    // Encontre produtos relacionados com base no ID do produto atual
    produtosSugeridos = MeusProdutos.todosProdutos
        .where((produto) =>
            produto.categoria == widget.produto.categoria &&
            produto != widget.produto)
        .toList();
  }

  void _enviarAvaliacao() {
    final comentario = _commentController.text;
    print('Comentário enviado pelo cliente: $comentario');
    setState(() {
      _comentarioEnviado = true;
    });

    // Aqui você pode adicionar a lógica para enviar o comentário para o servidor, se necessário.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(241, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  widget.produto.imagem,
                  width: MediaQuery.of(context).size.width - 32,
                  height: 150,
                ),
              ),
            ),
            const SizedBox(height: 35.0),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nome: ${widget.produto.nome}'),
                    Text(
                        'Preço: R\$ ${widget.produto.preco.toStringAsFixed(2)}'),
                    Text('Descrição: ${widget.produto.descricao}'),
                    const SizedBox(height: 7.0),
                    // Ícone de estrela com quatro estrelas amarelas e uma estrela cinza
                    RatingBar.builder(
                      initialRating: 4,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 15.0,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, index) {
                        if (index < 4) {
                          return const Icon(
                            Icons.star,
                            color: Colors.amber,
                          );
                        } else {
                          return const Icon(
                            Icons.star,
                            color: Colors.grey,
                          );
                        }
                      },
                      onRatingUpdate: (rating) {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 35.0),
            Text(
              'Sugestões de Produtos',
              style: TextStyle(fontSize: 18),
            ),
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: produtosSugeridos.length,
                itemBuilder: (context, index) {
                  final produtoSugerido = produtosSugeridos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesProdutoMaior(
                            produto: produtoSugerido,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            produtoSugerido.imagem,
                            width: 50,
                            height: 50,
                          ),
                          Text(produtoSugerido.nome),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 35.0),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color.fromARGB(242, 242, 241, 241),
              ),
              child: _comentarioEnviado
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 2.0),
                            child: Text(
                              'Avalie este produto',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'roboto',
                              ),
                            ),
                          ),
                          const SizedBox(height: 1.0),
                          const Text(
                            'Compartilhe seus pensamentos com outros clientes',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 1.0),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 25.0,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                _rating = rating;
                              });
                            },
                          ),
                          TextField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              labelText: 'Comentário',
                              border: InputBorder.none,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _enviarAvaliacao();
                              mostrarModalEnviado(
                                  context); //Chama o método para enviar o comentário
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.pink, // Cor de fundo rosa (pink)
                            ),
                            child: const Text(
                              'Enviar Avaliação',
                              style: TextStyle(
                                color: Colors.white, // Cor do texto branco
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void mostrarModalEnviado(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Avaliação enviada com sucesso!'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.pink, // Cor de fundo rosa (pink)
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white, // Cor do texto branco
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
