import 'package:flutter/material.dart';

class GedeeldeRuimteScreen extends StatelessWidget {
  const GedeeldeRuimteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Gedeelde Ruimte'),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Terug'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
