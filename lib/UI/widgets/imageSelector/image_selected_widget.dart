import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'show_imagen_selector.dart';

class ImageSelectedWidget extends ConsumerWidget {
  const ImageSelectedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageSelectedPro = ref.watch(imageSelectedProvider);
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width * 0.4,
          height: size.width * 0.4,
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: imageSelectedPro!, fit: BoxFit.cover)),
        ),
        SizedBox(
          width: size.width * 0.4,
          height: size.width * 0.4,
          child: Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () async {
                showImagenSelector(context, ref);
              },
              child: Container(
                color: Colors.grey,
                width: size.width * 0.12,
                height: size.width * 0.12,
                child: Icon(Icons.image),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final imageSelectedProvider = StateProvider.autoDispose<ImageProvider?>(
  (ref) => const AssetImage("assets/icons/user_icon_white.png"),
);
