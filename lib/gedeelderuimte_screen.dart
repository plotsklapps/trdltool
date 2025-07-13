import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import 'database_service.dart';

class GedeeldeRuimteScreen extends StatelessWidget {
  const GedeeldeRuimteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sCodeOpleider.watch(context)),
        centerTitle: true,
      ),
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
