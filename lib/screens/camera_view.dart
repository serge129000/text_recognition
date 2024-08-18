import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition/providers/camera_provider.dart';
import 'package:text_recognition/screens/result_screen.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController controller;
  late CameraProvider cameraProvider;
  @override
  void initState() {
    cameraProvider = context.read<CameraProvider>();
    Future.delayed(Duration.zero, () async {
      await availableCameras().then((allCams) {
        cameraProvider.setAvailablesCameras(cameras: allCams);
      });
    }).then((v) async {
      controller = CameraController(
          cameraProvider.availableCamera
              .firstWhere((e) => e.lensDirection == CameraLensDirection.back),
          ResolutionPreset.high);
      await controller.initialize();
      setState(() {});
    });
    cameraProvider.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    cameraProvider.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(builder: (context) {
        if (cameraProvider.availableCamera.isEmpty) {
          return Center(
            child: Text(
              'No camera detected',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            ),
          );
        }
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  CameraPreview(controller),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          if (!(cameraProvider.pictures.length >= 3)) {
                            controller.takePicture().then((photo) {
                              cameraProvider.addPicture(capture: photo);
                              setState(() {});
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              "You can't add more than 3 pic",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            )));
                          }
                        },
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: const Center(
                            child: Icon(Icons.camera),
                          ),
                        ),
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...cameraProvider.pictures.map((e) => Stack(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: FileImage(File(e.path)))),
                              ),
                              Positioned(
                                  child: Container(
                                height: 15,
                                width: 15,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                                child: Center(
                                  child: Text(
                                    "${cameraProvider.pictures.indexOf(e) + 1}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ))
                            ],
                          ))
                    ],
                  ),
                  if (cameraProvider.pictures.isNotEmpty)
                    ElevatedButton(
                        onPressed: () {
                          cameraProvider.setTreatRes();
                        },
                        child: Text(
                          "Treat photos",
                          style: Theme.of(context).textTheme.bodySmall,
                        ))
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  void listener() {
    final st = cameraProvider.treatmentResult;
    if (st == Status.loading) {
      showDialog(
          context: context,
          builder: (context) => const CupertinoActivityIndicator(
                color: Colors.white,
              ));
    }
    if (st == Status.loaded) {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ResultScreen()));
    }
    if (st == Status.error) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        cameraProvider.err,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.white),
      )));
    }
  }
}
