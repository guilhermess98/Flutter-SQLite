import 'package:flutter/material.dart';
import 'package:teste_sqlite/helpers/database_helper.dart';
import 'package:teste_sqlite/models/contato.dart';
import 'package:teste_sqlite/pages/contato_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper db = DatabaseHelper();
  List<Contato> contatos = List<Contato>();

  @override
  void initState() {
    super.initState();

    // Contato c = Contato(1, 'Maria', 'maria@gmail.com');
    // db.insertContato(c);
    // Contato c1 = Contato(2, 'Jorge', 'jorge@gmail.com');
    // db.insertContato(c1);
    // Contato c2 = Contato(3, 'Alberto', 'alberto@gmail.com');
    // db.insertContato(c2);

    // db.getContatos().then((lista) {
    //   print(lista);
    // });

    _exibeTodosContatos();
  }

  void _exibeTodosContatos() {
    db.getContatos().then((lista) {
      setState(() {
        contatos = lista;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agenda'),
          backgroundColor: Colors.indigo,
          centerTitle: true,
          actions: <Widget>[],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _exibeContatoPage();
          },
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: contatos.length,
          itemBuilder: (context, index) {
            return _listaContatos(context, index);
          },
        ));
  }

  _listaContatos(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    contatos[index].nome ?? "",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    contatos[index].email ?? "",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _confirmaExclusao(context, contatos[index].id, index);
                },
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _exibeContatoPage(contato: contatos[index]);
      },
    );
  }

  void _exibeContatoPage({Contato contato}) async {
    final contatoRecebido = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContatoPage(contato: contato)));

    if (contatoRecebido != null) {
      if (contato != null) {
        await db.updateContato(contatoRecebido);
      } else {
        await db.insertContato(contatoRecebido);
      }
      _exibeTodosContatos();
    }
  }

  void _confirmaExclusao(BuildContext context, int contatoid, index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Excluir Contato'),
            content: Text('Confirma a exclusão do contato'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Excluir'),
                onPressed: () {
                  setState(() {
                    contatos.removeAt(index);
                    db.deleteContato(contatoid);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
