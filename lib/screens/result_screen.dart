import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition/providers/camera_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CameraProvider>(
        builder: (context, cameraProvider, widgets) {
          return ListView(
            children: [
              ...cameraProvider.treatResult.entries.map((k)=> Column(
                children: [
                  Center(child: Image.file(File(k.key), height: 70, width: 70,)),
                  Padding(padding: const EdgeInsets.symmetric(
                    vertical: 30
                  ),
                  child: Text(k.value, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.black
                  ),),)
                ],
              ))
            ],
          );
        }
      ),
    );
  }
}