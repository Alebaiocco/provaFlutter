import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(AppCard());
}

class AppCard extends StatelessWidget {
  final store = CardStore();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Observer(
          builder: (_) => GradientCard(store: store),
        ),
      ),
    );
  }
}

class GradientCard extends StatefulWidget {
  final CardStore store;

  const GradientCard({Key? key, required this.store}) : super(key: key);

  @override
  _GradientCardState createState() => _GradientCardState();
}

class _GradientCardState extends State<GradientCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff1E4D60), Color(0xff2E9690)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: CardWidget(store: widget.store),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final CardStore store;

  const CardWidget({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: BlocoNotas(savedPhrases: store.savedPhrases),
          ),
          GestureDetector(
            onTap: () async {
              const url = 'https://www.google.com.br';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                print('Não foi possível abrir o link.');
              }
            },
            child: Text(
              'Política de Privacidade',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardStore {
  final TextEditingController textEditingController = TextEditingController();
  final List<String> savedPhrases = [];

  Future<void> saveData(String text) async {
    savedPhrases.add(text);
    await _saveData();
  }

  Future<void> clearData() async {
    savedPhrases.clear();
    await _saveData();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedPhrases', savedPhrases);
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmação'),
        content: Text('Deseja excluir a informação?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              clearData();
              Navigator.of(context).pop();
            },
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

class BlocoNotas extends StatelessWidget {
  final List<String> savedPhrases;

  const BlocoNotas({Key? key, required this.savedPhrases}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotepadWidget(savedPhrases: savedPhrases);
  }
}

class NotepadWidget extends StatefulWidget {
  final List<String> savedPhrases;

  const NotepadWidget({Key? key, required this.savedPhrases}) : super(key: key);

  @override
  _NotepadWidgetState createState() => _NotepadWidgetState();
}

class _NotepadWidgetState extends State<NotepadWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  bool isLabelVisible = true;

  int selectedPhraseIndex =
      -1; // Index da frase selecionada para edição ou exclusão

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text('Texto Digitado',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _startEditingPhrase(widget.savedPhrases.length - 1);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(
                                widget.savedPhrases.length - 1);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: widget.savedPhrases.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) => GestureDetector(
                    onLongPress: () {
                      _startEditingPhrase(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(widget.savedPhrases[index],
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _textEditingController,
                  onChanged: (value) {
                    setState(() {
                      isLabelVisible = value.isEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: isLabelVisible ? 'Digite sua Frase' : '',
                    labelStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (selectedPhraseIndex == -1) {
                    // Adiciona nova frase se não estiver editando
                    final newPhrase = _textEditingController.text;
                    if (newPhrase.isNotEmpty) {
                      widget.savedPhrases.add(newPhrase);
                      _textEditingController.clear();
                    }
                  } else {
                    // Salva a frase editada
                    widget.savedPhrases[selectedPhraseIndex] =
                        _textEditingController.text;
                    _textEditingController.clear();
                    setState(() {
                      selectedPhraseIndex = -1;
                    });
                  }
                },
                icon: Icon(selectedPhraseIndex == -1 ? Icons.send : Icons.save),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _startEditingPhrase(int index) {
    setState(() {
      selectedPhraseIndex = index;
      _textEditingController.text = widget.savedPhrases[index];
      isLabelVisible = false;
    });
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmação'),
        content: Text('Deseja excluir a ultima frase?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              widget.savedPhrases.removeAt(index);
              Navigator.of(context).pop();
            },
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
