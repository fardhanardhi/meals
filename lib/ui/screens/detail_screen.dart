import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Modular.to.pop(),
          child: const Text('Back to Home'),
        ),
      ),
    );
  }
}
