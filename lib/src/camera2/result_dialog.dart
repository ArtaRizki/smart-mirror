
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CaptureResultDialog extends StatelessWidget {
  final Uint8List? bytes;

  const CaptureResultDialog(this.bytes, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: .1,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Apakah Anda ingin menggunakan foto ini?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                    ),
                  )
              ),
            ),

            const Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(
                          0,
                          2
                      ),
                    blurRadius: 6,
                    spreadRadius: 1
                  )
                ]
              ),
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  bytes!,
                ),
              )
            ),
            const Spacer(),

            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                    'Ya'
                )
            ),
            const SizedBox.square(dimension: 12,),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                    'Tidak'
                )
            ),

            const SizedBox(height: 32,)
          ],
        ),
      ),
    );
  }
}
