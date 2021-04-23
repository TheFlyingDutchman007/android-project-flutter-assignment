import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hello_me/authRepo.dart';
import 'package:hello_me/loginPage.dart';
import 'package:provider/provider.dart';
import 'package:hello_me/userStateManagement.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:hello_me/grabbingWidget.dart';
import 'package:hello_me/snappingSheetProfileSectionWidget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider<AuthRepository>(
      create: (_) => AuthRepository.instance(),
      builder: (context, snapshot) {
        return App();
      }));
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          primaryColor: Colors.red,
        ),
        home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  final _snappingSheetController = SnappingSheetController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(builder: (context, auth, snapshot) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Startup Name Generator'),
            actions: [
              IconButton(icon: Icon(Icons.favorite), onPressed: _pushSaved),
              (auth.status != Status.Authenticated)
                  ? IconButton(icon: Icon(Icons.login), onPressed: _loginScreen)
                  : IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () {
                        _saved.clear();
                        auth.signOut();
                      })
            ],
          ),
          // TODO: EDIT WITH FUN!!!
          body:
          (auth.status == Status.Authenticated)
          ? SnappingSheet(
            controller: _snappingSheetController,
            child: _buildSuggestions(),
            grabbing: GrabbingWidget(_snappingSheetController),
            grabbingHeight: 75,
            sheetAbove: null,
            sheetBelow: SnappingSheetContent(
              sizeBehavior: SheetSizeStatic(height: 300),
              draggable: true,
              child: ProfileSection(),
            ),
          )
      : _buildSuggestions());
    });
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        // The itemBuilder callback is called once per suggested
        // word pairing, and places each suggestion into a ListTile
        // row. For even rows, the function adds a ListTile row for
        // the word pairing. For odd rows, the function adds a
        // Divider widget to visually separate the entries. Note that
        // the divider may be difficult to see on smaller devices.
        itemBuilder: (BuildContext _context, int i) {
          // Add a one-pixel-high divider widget before each row
          // in the ListView.
          if (i.isOdd) {
            return Divider();
          }

          // The syntax "i ~/ 2" divides i by 2 and returns an
          // integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings
          // in the ListView,minus the divider widgets.
          final int index = i ~/ 2;
          // If you've reached the end of the available word
          // pairings...
          if (index >= _suggestions.length) {
            // ...then generate 10 more and add them to the
            // suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () async {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
        final auth = AuthRepository.instance();
        if (auth.status == Status.Authenticated) {
          if (alreadySaved) {
            await DatabaseService.instance().removePair(auth.user!, pair);
          } else {
            await DatabaseService.instance().addPair(auth.user!, pair);
          }
        }
      },
    );
  }

  void _pushSaved() {
    /*if (_saved.isEmpty){
      final emptySnackBar =
      SnackBar(content: Text("No favorites to show"));
      ScaffoldMessenger.of(context).showSnackBar(emptySnackBar);
      return;
    }*/
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: StatefulBuilder(
                builder: (BuildContext context, StateSetter setIt) {
              if (_saved.isEmpty)
                return Center(
                  child: Text("No Favorites"),
                );
              final tiles = _saved.map(
                (WordPair pair) {
                  return ListTile(
                      title: Text(
                        pair.asPascalCase,
                        style: _biggerFont,
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            setIt(() {
                              /*if (_saved.length == 1)
                                  Navigator.of(context).pop();*/
                            });
                            await _deleteSnackBar(pair);
                          }));
                },
              );
              final divided = ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList();
              return ListView(children: divided);
            }),
          );
        },
      ),
    );
  }

  void _loginScreen() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => LoginPage(_saved)),
    );
  }

  Future _deleteSnackBar(pair) async {
    final auth = AuthRepository.instance();
    final user = auth.user;
    final db = DatabaseService.instance();
    setState(() {
      _saved.remove(pair);
    });
    if (auth.status == Status.Authenticated) {
      db.removePair(user!, pair);
    }
  }
}
