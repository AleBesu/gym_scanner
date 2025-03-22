import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_scanner/UI/widgets/imageSelector/image_selected_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showImagenSelector(BuildContext context, WidgetRef ref) async {
  final picker = ImagePicker();
  Size size = MediaQuery.of(context).size;
  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                XFile? image =
                    await picker.pickImage(source: ImageSource.camera);

                if (image != null) {
                  final imageCroped = await ImageCropper().cropImage(
                      sourcePath: image.path,
                      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));

                  if (imageCroped != null) {
                    ref.read(imageSelectedProvider.notifier).state =
                        FileImage(File(imageCroped.path));
                    Navigator.pop(context);
                  }
                }
              },
              icon: Icon(
                Icons.photo_camera,
                size: size.width * 0.1,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: IconButton(
                onPressed: () async {
                  XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    final imageCroped = await ImageCropper().cropImage(
                        sourcePath: image.path,
                        aspectRatio:
                            const CropAspectRatio(ratioX: 1, ratioY: 1));

                    if (imageCroped != null) {
                      ref.read(imageSelectedProvider.notifier).state =
                          FileImage(File(imageCroped.path));
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  }
                },
                icon: Icon(
                  Icons.collections,
                  size: size.width * 0.1,
                )),
          ),
        ],
      );
    },
  );
}
