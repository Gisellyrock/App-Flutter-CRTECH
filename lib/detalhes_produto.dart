import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:crtech/appBar.dart';
import 'package:crtech/barra_inferior.dart';
import 'package:crtech/produtos/meus_produtos.dart';
import 'package:crtech/produtos/produtos.dart';
import 'package:crtech/tela/carrrossel.dart';
import 'package:crtech/tela/tela_carrinho.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PaginaPrincipal extends StatefulWidget {
  final List<Produtos> carrinho;

  const PaginaPrincipal({Key? key, required this.carrinho}) : super(key: key);

  @override
  _EstadoPaginaPrincipal createState() => _EstadoPaginaPrincipal();
}

class _EstadoPaginaPrincipal extends State<PaginaPrincipal> {
  int isSelected = 0;
  List<bool> favoritos = List.filled(MeusProdutos.todosProdutos.length, false);
  String searchText = "";
  List<Produtos> listaDeProdutos = MeusProdutos.todosProdutos;
  List<Produtos> carrinho = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        flexibleSpace: Column(
          children: [
            Image.asset(
              'assets/logo/logo.jpg', // Caminho da imagem
              width: 90.0,
              height: 90.0,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Carrossel(), // Adicione o carrossel aqui
          CustomAppBar(
            onCartPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaCarrinho(carrinho: carrinho),
                ),
              );
            },
            onSearchChanged: (text) {
              setState(() {
                searchText = text;
              });
            },
          ),
          // Conteúdo principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
              child: Column(
                children: [
                  construirCategoriasDeProdutos(),
                  Expanded(
                    child: construirProdutosExibidos(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomAppBar(
        onTabSelected: (index) {
          setState(() {
            isSelected = index;
          });
        },
        selectedIndex: isSelected,
        favoritos: favoritos,
      ),
    );
  }

  Widget construirCardDeProdutos(Produtos produtos, int index, int id) {
    double _rating = 0.0;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Ícone de coração para favoritar
              IconButton(
                iconSize: 18.5, // Tamanho do ícone
                icon: Icon(
                  favoritos[index] ? Icons.favorite : Icons.favorite_border,
                  color: Color.fromARGB(255, 231, 130, 164),
                ),
                onPressed: () {
                  setState(() {
                    favoritos[index] = !favoritos[index];
                  });
                },
              ),
              // Ícone de carrinho para adicionar ao carrinho
              IconButton(
                iconSize: 18.5, // Tamanho do ícone
                icon: Icon(
                  Icons.add_shopping_cart_sharp,
                  color: Colors.black, // Cor do ícone de carrinho
                ),
                onPressed: () {
                  setState(() {
                    carrinho.add(produtos);
                  });
                  mostrarModalConfirmacao(context);
                },
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalhesProdutoMaior(
                      produto: produtos,
                    ),
                  ),
                );
              },
              child: Image.asset(
                produtos.imagem,
              ),
            ),
          ),
          Text(
            produtos.descricao,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            'R\$ ${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(produtos.preco)}',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void mostrarModalConfirmacao(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Produto adicionado ao carrinho.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget construirCategoriasDeProdutos() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            construirCategoriaDeProdutos(index: 0, nome: "Ver tudo"),
            construirCategoriaDeProdutos(index: 1, nome: "Gamer"),
            construirCategoriaDeProdutos(index: 2, nome: "Rede"),
            construirCategoriaDeProdutos(index: 3, nome: "Hardware"),
          ],
        ),
      ),
    );
  }

  Widget construirCategoriaDeProdutos({
    required int index,
    required String nome,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = index;
          searchText = "";
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          nome,
          style: TextStyle(
            color: isSelected == index ? Colors.white : Colors.pink,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget construirProdutosExibidos() {
    List<Produtos> produtosExibidos;

    produtosExibidos = listaDeProdutos.where((produto) {
      return produto.descricao.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    if (isSelected == 1) {
      produtosExibidos = produtosExibidos.where((produto) {
        return MeusProdutos.listaGamer.contains(produto);
      }).toList();
    } else if (isSelected == 2) {
      produtosExibidos = produtosExibidos.where((produto) {
        return MeusProdutos.listaDeRede.contains(produto);
      }).toList();
    } else if (isSelected == 3) {
      produtosExibidos = produtosExibidos.where((produto) {
        return MeusProdutos.listaDeHardware.contains(produto);
      }).toList();
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 3 / 3,
      ),
      itemCount: produtosExibidos.length,
      itemBuilder: (context, index) {
        final produtos = produtosExibidos[index];
        return construirCardDeProdutos(produtos, index, produtos.categoria);
      },
    );
  }
}

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
      backgroundColor: Colors.white,
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
            const SizedBox(height: 20.0),
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
            const SizedBox(height: 7.0),
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
                            child: const Text('Enviar Avaliação'),
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
          content: const Text('Avaliação enviado com sucesso!'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
