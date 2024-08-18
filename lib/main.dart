import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition/providers/camera_provider.dart';
import 'package:text_recognition/screens/camera_view.dart';

void main(List<String> args) {
  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CameraProvider())
      ],
      child: MaterialApp(
        title: "Text recognition",
        home: const CameraView(),
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme
          )
        ),
      ),
    );
  }
}
