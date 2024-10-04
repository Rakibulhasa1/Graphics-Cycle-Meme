import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/meme_provider.dart';
import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meme App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
