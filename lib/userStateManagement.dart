import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService{

  // collection reference
  CollectionReference _wordsData;

  DatabaseService.instance() : _wordsData = FirebaseFirestore.instance.collection('users');

  // get users stream
  Stream<QuerySnapshot> get users{
    return _wordsData.snapshots();
  }

  Future<Set<WordPair>> getWords(User user) async{
    var savedData = await _wordsData.doc(user.uid).get().then((doc) => doc["words"]);
    Set<WordPair> words = _fromArrayToSet(savedData);
    return words;
  }

  Set<WordPair> _fromArrayToSet(List words){
    return words.map((word){
      return WordPair(word['first'], word['second']);
    }).toSet();
  }

  List _fromSetToArray(Set<WordPair> words){
    return words.map((word) {
      return {'first': word.first, 'second': word.second};
    }).toList();
  }


  Future addPair(User user, WordPair toAdd) async{
    //final user = FirebaseAuth.instance.currentUser;
    var savedData = await _wordsData.doc(user.uid).get().then((doc) => doc["words"]);

    Set<WordPair> words = _fromArrayToSet(savedData);
    //print("wow");
    //print(words.toString());

    if (!words.contains(toAdd)){
      words.add(toAdd);
      await _wordsData.doc(user.uid).set({"words": _fromSetToArray(words)});
    }
  }

  Future removePair(User user, WordPair toRemove) async{
    //final user = FirebaseAuth.instance.currentUser;
    var savedData = await _wordsData.doc(user.uid).get().then((doc) => doc["words"]);

    Set<WordPair> words = _fromArrayToSet(savedData);

    if (words.contains(toRemove)){
      words.remove(toRemove);
      await _wordsData.doc(user.uid).set({"words": _fromSetToArray(words)});
    }
  }
}