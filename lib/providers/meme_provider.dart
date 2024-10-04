import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/meme.dart';

class MemeProvider with ChangeNotifier {
  List<Meme> _memes = [];
  List<Meme> get memes => _memes;

  Future<void> fetchMemes() async {
    final url = Uri.parse('https://api.imgflip.com/get_memes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Meme> loadedMemes = [];
      for (var meme in data['data']['memes']) {
        loadedMemes.add(Meme.fromJson(meme));
      }
      _memes = loadedMemes;
      notifyListeners();
    }
  }
}
