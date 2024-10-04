import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meme_provider.dart';
import '../widgets/meme_card.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';

  @override
  void initState() {
    super.initState();
    Provider.of<MemeProvider>(context, listen: false).fetchMemes();
  }

  @override
  Widget build(BuildContext context) {
    final memes = Provider.of<MemeProvider>(context).memes;
    final filteredMemes = memes.where((meme) => meme.name.toLowerCase().contains(query.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphics Cycle Meme'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CustomSearchBar(onSearch: (val) {
            setState(() {
              query = val;
            });
          }),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: filteredMemes.length,
                itemBuilder: (ctx, i) => MemeCard(meme: filteredMemes[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
