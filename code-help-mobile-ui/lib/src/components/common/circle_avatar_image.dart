import 'dart:io';

import 'package:coding_helper_cross_platform/src/i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CircleAvatarImage extends StatefulWidget {
  final String imageUrl;
  final bool imagePicker;
  final void Function()? onTap;

  const CircleAvatarImage({
    required this.imageUrl,
    this.imagePicker = true,
    this.onTap,
    super.key,
  });

  @override
  State<CircleAvatarImage> createState() => _CircleAvatarImageState();
}

class _CircleAvatarImageState extends State<CircleAvatarImage> {
  File? image;

  void handlePickImage() async {
    final bool? isCamera = await showChoiceModal();

    if (isCamera == null) {
      return;
    }

    final imagePicker = ImagePicker();
    imagePicker
        .pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery,
          maxWidth: 600,
        )
        .then((value) => value == null ? null : File(value.path))
        .then((value) {
      if (value != null) {
        setState(() => image = value);
      }
    });

    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  Future<bool?> showChoiceModal() async {
    final t = getTranslation(context);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${t('pick')}:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  label: Text(t("camera")),
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.camera),
                ),
                TextButton.icon(
                  label: Text(t("gallery")),
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.image),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider = image == null
        ? NetworkImage(widget.imageUrl)
        : FileImage(image!) as ImageProvider<Object>;

    return GestureDetector(
      onTap: widget.imagePicker ? handlePickImage : widget.onTap,
      child: CircleAvatar(
        radius: 40.0,
        backgroundImage: imageProvider,
      ),
    );
  }
}
