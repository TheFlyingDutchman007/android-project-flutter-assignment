/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:english_words/english_words.dart';

class SavedSuggestionsRepository {
  FirebaseFirestore _store;
  String _suggestionsCollectionPath = 'savedSuggestions';

  SavedSuggestionsRepository.instance() : _store = FirebaseFirestore.instance;

  Stream<List<WordPair>> getUserSavedSuggestions(User user) {
    return _store
        .collection(_suggestionsCollectionPath)
        .doc(user.uid)
        .snapshots()
        .map((doc) => _convertArrayToWordPairs(doc[
    'saved'])); //_convertArrayToWordPairs(snapshot.docs.first['saved']));
  }

  Future addNewUserDocument(User user) async {
    return _store
        .collection(_suggestionsCollectionPath)
        .doc(user.uid)
        .get()
        .then((docSnapshot) {
      if (!docSnapshot.exists) {
        _store
            .collection(_suggestionsCollectionPath)
            .doc(user.uid)
            .set({'saved': []});
      }
    });
  }

  Future addWordPair(User user, WordPair pair) async {
    var savedArray = await _store
        .collection(_suggestionsCollectionPath)
        .doc(user.uid)
        .get()
        .then((doc) => doc['saved']);

    List<WordPair> userWordPairs = _convertArrayToWordPairs(savedArray);

    if (!userWordPairs.contains(pair)) {
      userWordPairs.add(pair);
      await _store
          .collection(_suggestionsCollectionPath)
          .doc(user.uid)
          .set({'saved': _convertWordPairsToArray(userWordPairs)});
    }

    return Future.delayed(Duration.zero);
  }

  Future deleteWordPair(User user, WordPair pair) async {
    var savedArray = await _store
        .collection(_suggestionsCollectionPath)
        .doc(user.uid)
        .get()
        .then((doc) => doc['saved']);

    List<WordPair> userWordPairs = _convertArrayToWordPairs(savedArray);

    if (userWordPairs.contains(pair)) {
      userWordPairs.remove(pair);
      await _store
          .collection(_suggestionsCollectionPath)
          .doc(user.uid)
          .set({'saved': _convertWordPairsToArray(userWordPairs)});
    }

    return Future.delayed(Duration.zero);
  }

  Future<List<WordPair>> updateUserSavedSuggestions(User user, Set<WordPair> localPairs) async {
    var savedArray = await _store
        .collection(_suggestionsCollectionPath)
        .doc(user.uid)
        .get()
        .then((doc) => doc['saved']);

    List<WordPair> userWordPairs = _convertArrayToWordPairs(savedArray);
    userWordPairs.addAll(localPairs);
    // remove duplications but keep the order.
    final seen = Set<WordPair>();
    final uniquePairs = userWordPairs.where((pair) => seen.add(pair)).toList();
    await _store.collection(_suggestionsCollectionPath).doc(user.uid).set({
      'saved':
      _convertWordPairsToArray(uniquePairs)
    });

    return uniquePairs;
  }

  List<WordPair> _convertArrayToWordPairs(List<dynamic> userArray) {
    // Each item is a '<FIRST_WORD>,<SECOND_WORD>' WordPair string.
    // Map each item to it's actual pair.
    return userArray.map((item) {
      final splittedPair = (item as String).split(',');
      return WordPair(splittedPair[0], splittedPair[1]);
    }).toList();
  }

  List<String> _convertWordPairsToArray(List<WordPair> wordPairs) {
    // Map each item to '<FIRST_WORD>,<SECOND_WORD>' string.
    return wordPairs.map((pair) => ('${pair.first},${pair.second}')).toList();
  }
}*/
