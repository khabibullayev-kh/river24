import 'package:cropperx/cropperx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outsource/navigation/route_name.dart';
import 'package:outsource/presentation/register/bloc/register_bloc.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:provider/provider.dart';

class CropImagePage extends StatefulWidget {
  final RegisterBloc bloc;

  const CropImagePage({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  State<CropImagePage> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  final ImagePicker _picker = ImagePicker();
  final GlobalKey _cropperKey = GlobalKey(debugLabel: 'cropperKey');
  Uint8List? _imageToCrop;

  Future<void> pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      final imageBytes = await image.readAsBytes();
      setState(() {
        _imageToCrop = imageBytes;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    pickImage();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Выбор аватара'),
          backgroundColor: AppColors.backgroundColor,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: _imageToCrop != null
                      ? Cropper(
                          cropperKey: _cropperKey,
                          backgroundColor: AppColors.backgroundColor,
                          overlayColor:
                              AppColors.backgroundColor.withOpacity(0.5),
                          overlayType: OverlayType.circle,
                          image: Image.memory(_imageToCrop!),
                        )
                      : const ColoredBox(color: Colors.grey),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  onPressed: () async {
                    final imageBytes = await Cropper.crop(
                      cropperKey: _cropperKey,
                    );

                    if (imageBytes != null) {
                      widget.bloc.data.croppedImage = imageBytes;
                    }
                    Navigator.pop(context, true);
                  },
                  child: const Text('Выбрать'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
