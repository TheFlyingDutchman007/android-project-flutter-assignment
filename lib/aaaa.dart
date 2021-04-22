/*import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

import 'package:hello_me/login_page.dart';
import 'package:hello_me/user_repository.dart';
import 'package:hello_me/saved_suggestions_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
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
    return ChangeNotifierProvider(
        create: (_) => UserRepository.instance(),
        child: MaterialApp(
          title: 'Welcome to Flutter',
          theme: ThemeData(
            primaryColor: Colors.red,
          ),
          home: RandomWords(),
        ));
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  Set<WordPair> _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserRepository>(builder: (context, userRepo, _) {
      return Scaffold(
          appBar: AppBar(title: Text('Startup Name Generator'), actions: [
            IconButton(icon: Icon(Icons.favorite), onPressed: _pushSaved),
            (userRepo.status == Status.Authenticated)
                ? IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  final user =
                  Provider.of<UserRepository>(context, listen: false);
                  updateSuggestionsOnLogout();
                  await user.signOut();
                })
                : IconButton(
                icon: Icon(Icons.login),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (context) => LoginPage(updateSuggestionsOnLogin))))
          ]),
          body: _buildSuggestions());
    });
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Saved Suggestions'),
              ),
              body: StatefulBuilder(builder: (context, setInnerState) {
                var userRepo = Provider.of<UserRepository>(context);
                if (userRepo.status != Status.Authenticated) {
                  // Build a list tile for each saved name.
                  final tiles = _saved.map(
                        (WordPair pair) {
                      return ListTile(
                        title: Text(
                          pair.asPascalCase,
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setInnerState(() {
                                _saved.remove(pair);
                                setState(() {});
                              });
                            }),
                      );
                    },
                  ).toList();

                  // Create a divided list from the tiles created earlier.
                  final divided = ListTile.divideTiles(
                    context: context,
                    tiles: tiles,
                  ).toList();

                  // Return a view for the divided list.
                  return ListView(children: divided);
                } else {
                  return StreamBuilder<List<WordPair>>(
                      stream: SavedSuggestionsRepository.instance()
                          .getUserSavedSuggestions(userRepo.user),
                      builder: (context, snapshot) {
                        Set<WordPair> totalPairs;
                        if (snapshot.hasData) {
                          totalPairs =
                              (snapshot.data + _saved.toList()).toSet();
                          // update _saved if needed.
                          _saved = totalPairs;
                        } else {
                          totalPairs = _saved;
                        }

                        // Build a list tile for each saved name.
                        final tiles = totalPairs.map(
                              (WordPair pair) {
                            return ListTile(
                              title: Text(
                                pair.asPascalCase,
                                style: const TextStyle(fontSize: 18),
                              ),
                              trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    setState(() {
                                      _saved.remove(pair);
                                    });
                                    await SavedSuggestionsRepository.instance()
                                        .deleteWordPair(userRepo.user, pair);
                                  }),
                            );
                          },
                        ).toList();

                        // Create a divided list from the tiles created earlier.
                        final divided = ListTile.divideTiles(
                          context: context,
                          tiles: tiles,
                        ).toList();

                        // Return a view for the divided list.
                        return ListView(children: divided);
                      });
                }
              }));
        },
      ),
    );
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
        final userRepo = Provider.of<UserRepository>(context, listen: false);
        if (userRepo.status == Status.Authenticated) {
          if (alreadySaved) {
            await SavedSuggestionsRepository.instance()
                .deleteWordPair(userRepo.user, pair);
          } else {
            await SavedSuggestionsRepository.instance()
                .addWordPair(userRepo.user, pair);
          }
        }
      },
    );
  }

  Future updateSuggestionsOnLogin() async {
    final userRepo = Provider.of<UserRepository>(context, listen: false);
    final updatedSaved =  await SavedSuggestionsRepository.instance().updateUserSavedSuggestions(userRepo.user, _saved);

    setState(() {
      _saved = updatedSaved.toSet();
    });

    return Future.delayed(Duration.zero);
  }

  void updateSuggestionsOnLogout() {
    _saved.clear();
  }
}
*/