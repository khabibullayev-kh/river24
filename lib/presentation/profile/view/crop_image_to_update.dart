import 'package:cropperx/cropperx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outsource/navigation/route_name.dart';
import 'package:outsource/presentation/profile/bloc/profile_bloc.dart';
import 'package:outsource/presentation/register/bloc/register_bloc.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';

class CropImageToUpdatePage extends StatefulWidget {
  final ProfileBloc bloc;

  const CropImageToUpdatePage({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  State<CropImageToUpdatePage> createState() => _CropImageToUpdatePageState();
}

class _CropImageToUpdatePageState extends State<CropImageToUpdatePage> {
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
          title: Text(LocaleKeys.choose_avatar.tr()),
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
                  child: Text(LocaleKeys.choose.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
