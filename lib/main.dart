import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/fruit_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const FruitMixerApp());
}

class FruitMixerApp extends StatelessWidget {
  const FruitMixerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FruitProvider()),
      ],
      child: MaterialApp(
        title: 'Fruit Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}