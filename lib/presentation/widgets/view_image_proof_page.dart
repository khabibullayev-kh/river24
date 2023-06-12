import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ViewImageProofsPage extends StatefulWidget {
  final List<XFile?> images;
  final List<String> storageImages;
  final int? index;

  const ViewImageProofsPage({
    Key? key,
    required this.images,
    this.index,
    required this.storageImages,
  }) : super(key: key);

  @override
  State<ViewImageProofsPage> createState() => _ViewImageProofsPageState();
}

class _ViewImageProofsPageState extends State<ViewImageProofsPage> {
  late int index;
  late List<XFile?> images;
  late List<String> storageImages;

  @override
  void initState() {
    super.initState();
    index = widget.index ?? 0;
    images = widget.images;
    storageImages = widget.storageImages;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

    return WillPopScope(
      onWillPop: Platform.isAndroid ? () async {
        // if (navigatorKey.currentState != null &&
        //     navigatorKey.currentState!.canPop()) {
        //   navigatorKey.currentState!.pop();
        //   return true;
        // }
        return true;
      } : null,
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Center(
                child: IconButton(
                  onPressed: () {
                    if (index != 0) {
                      index = index - 1;
                    } else {
                      index = images.isNotEmpty
                          ? images.length - 1
                          : storageImages.length - 1;
                    }
                    setState(() {});
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: PinchZoom(
                maxScale: 3,
                resetDuration: const Duration(milliseconds: 100),
                child: Center(
                  child: images.isNotEmpty
                      ? Image.file(File(images[index]!.path))
                      : GestureDetector(
                    // onTap: () {
                    //   Navigator.of(context).pop();
                    // },
                        child: CachedNetworkImage(
                            imageUrl: storageImages[index],
                            fit: BoxFit.fill,
                            errorWidget: (error, context, url) {
                              return Container(
                                alignment: Alignment.center,
                                color: Colors.white,
                                child: const CircularProgressIndicator(),
                              );
                            },
                          ),
                      ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: IconButton(
                  onPressed: () {
                    int imageLength = images.isNotEmpty
                        ? images.length - 1
                        : storageImages.length - 1;
                    if (index != imageLength) {
                      index = index + 1;
                    } else {
                      index = 0;
                    }
                    setState(() {});
                  },
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
