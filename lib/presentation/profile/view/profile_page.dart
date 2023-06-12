import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outsource/data/bloc/choose_lang_bloc.dart';
import 'package:outsource/domain/interactors/logout_interactor.dart';
import 'package:outsource/navigation/route_name.dart';
import 'package:outsource/presentation/profile/bloc/profile_bloc.dart';
import 'package:outsource/presentation/widgets/choose_lang_widget.dart';
import 'package:outsource/presentation/widgets/cupertino_segment_child.dart';
import 'package:outsource/presentation/widgets/reusable_phone_field.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/resources/app_icons.dart';
import 'package:outsource/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ProfileBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              LocaleKeys.profile.tr(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(RouteName.changePin.route);
              },
              child: Text(
                LocaleKeys.change_pin.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.slate500,
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: bloc.data.user == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  const Center(child: _CircleAvatar()),
                  const SizedBox(height: 16),
                  Text(
                    bloc.data.user!.fullName ?? '',
                    style: const TextStyle(
                        color: AppColors.grey900,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '+${bloc.data.user!.phoneNumber}',
                    style: const TextStyle(
                        color: AppColors.grey500,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  const _CupertinoSegmentWidget(),
                  if (bloc.data.selectedSegmentId == 0) const _ProfileColumn(),
                  if (bloc.data.selectedSegmentId == 1)
                    const _ChangeNumberColumn(),
                ],
              ),
      ),
    );
  }
}

class _CircleAvatar extends StatefulWidget {
  const _CircleAvatar({Key? key}) : super(key: key);

  @override
  State<_CircleAvatar> createState() => _CircleAvatarState();
}

class _CircleAvatarState extends State<_CircleAvatar> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ProfileBloc>();
    return SizedBox(
      height: 180,
      width: 156,
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: [
          DottedBorder(
            dashPattern: [20, 7],
            padding: const EdgeInsets.all(4),
            strokeWidth: 4,
            strokeCap: StrokeCap.square,
            color: AppColors.green500,
            borderType: BorderType.Circle,
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.transparent,
              //backgroundImage: const AssetImage(AppIcons.exampleImage),
              backgroundImage: bloc.data.croppedImage != null
                  ? MemoryImage(bloc.data.croppedImage!)
                  : NetworkImage(bloc.data.user!.avatar!) as ImageProvider,
            ),
          ),
          Positioned(
            bottom: -3,
            child: GestureDetector(
              onTap: () async {
                final isChanged = await Navigator.of(context).pushNamed(
                  RouteName.cropToUpdateProfile.route,
                  arguments: bloc,
                );
                print(bloc.data.croppedImage);
                if (isChanged == true) setState(() {});
              },
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 4,
                    color: Colors.white,
                  ),
                  color: AppColors.green500,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _CupertinoSegmentWidget extends StatefulWidget {
  const _CupertinoSegmentWidget({Key? key}) : super(key: key);

  @override
  State<_CupertinoSegmentWidget> createState() =>
      _CupertinoSegmentWidgetState();
}

class _CupertinoSegmentWidgetState extends State<_CupertinoSegmentWidget> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ProfileBloc>();
    final segmentId = bloc.data.selectedSegmentId;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        child: CupertinoSlidingSegmentedControl(
          groupValue: segmentId,
          backgroundColor: Colors.white,
          onValueChanged: (index) => bloc.changeSelectedId(index),
          children: {
            0: CupertinoSlidingChild(
              text: LocaleKeys.main_text.tr(),
              color: segmentId == 0 ? AppColors.green600 : AppColors.grey500,
            ),
            1: CupertinoSlidingChild(
              text: LocaleKeys.phone.tr(),
              color: segmentId == 1 ? AppColors.green600 : AppColors.grey500,
            ),
          },
        ),
      ),
    );
  }
}

class _ChangeNumberColumn extends StatelessWidget {
  const _ChangeNumberColumn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ProfileBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          PhoneField(controller: bloc.data.phoneController),
          const Divider(height: 40, color: AppColors.slate300),
          _SaveButton(
            onPressed: () async {
              await bloc.updatePhone();
              if (bloc.data.isSuccess) {
                FocusScope.of(context).unfocus();
                Navigator.of(context)
                    .pushNamed(
                  RouteName.updatePhone.route,
                  arguments: bloc,
                )
                    .whenComplete(() {
                  bloc.load();
                });
              }

              if (bloc.data.error.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: AppColors.red500,
                  content: Text(
                    bloc.data.error,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ));
              }
            },
          ),
          const SizedBox(height: 19),
        ],
      ),
    );
  }
}

class _ProfileColumn extends StatelessWidget {
  const _ProfileColumn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ProfileBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          const _FullNameField(),
          const Divider(height: 40, color: AppColors.slate300),
          const _LanguageChooseDDButton(),
          const SizedBox(height: 19),
          _SaveButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await bloc.updateProfile();
              if (bloc.data.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.green500,
                    content: Text(LocaleKeys.changes_saved.tr()),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 19),
          _LogoutButton(
            onPressed: () {
              LogoutInteractor.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteName.signIn.route, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageChooseDDButton extends StatefulWidget {
  const _LanguageChooseDDButton({Key? key}) : super(key: key);

  @override
  State<_LanguageChooseDDButton> createState() =>
      _LanguageChooseDDButtonState();
}

class _LanguageChooseDDButtonState extends State<_LanguageChooseDDButton> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ProfileBloc>();
    final controller = bloc.data.languageController;
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ChangeNotifierProvider(
              create: (_) => ChooseLangBloc(),
              child: const ChooseLangWidget(),
            );
          },
        ).whenComplete(() async {
          await bloc.loadLang();
        });
        // print(isTrue);
        // if (isTrue == true) {
        //   await Future.delayed(Duration(seconds: 2), () {
        //     setState(() {
        //       print("rebuilded");
        //     });
        //   });
        // }
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.slate900,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            AppIcons.globe,
            width: 24,
            height: 24,
            color: AppColors.slate900,
          ),
        ),
        prefixIconColor: AppColors.slate900,
        suffixIcon: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.slate900,
          ),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.slate400,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.slate400,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.slate400,
            )),
      ),
    );
  }
}

class _FullNameField extends StatefulWidget {
  const _FullNameField({Key? key}) : super(key: key);

  @override
  State<_FullNameField> createState() => _FullNameFieldState();
}

class _FullNameFieldState extends State<_FullNameField> {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<ProfileBloc>().data.fullNameController;
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.slate400,
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.slate900,
      ),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.slate900,
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.account_circle,
            color: AppColors.slate900,
          ),
        ),
        prefixIconColor: AppColors.slate900,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.slate400,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.slate400,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.slate400,
            )),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // <-- Radius
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.refresh,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 10),
            Text(
              LocaleKeys.save_changes.tr(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LogoutButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          side: const BorderSide(width: 1, color: AppColors.red200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // <-- Radius
          ),
        ),
        child: Text(
          LocaleKeys.logout.tr(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.red500,
          ),
        ),
      ),
    );
  }
}

class _PhoneField extends StatefulWidget {
  const _PhoneField({Key? key}) : super(key: key);

  @override
  State<_PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<_PhoneField> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProfileBloc>();
    final phoneController = bloc.data.phoneController;
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'UZ',
      newMask: '+000 00 000 00 00',
    );
    return SizedBox(
      height: 60,
      child: TextFormField(
        controller: phoneController,
        cursorColor: AppColors.slate400,
        keyboardType: TextInputType.phone,
        inputFormatters: [PhoneInputFormatter()],
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.slate900,
        ),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: const Icon(
            Icons.phone,
          ),
          prefixIconColor: AppColors.slate900,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 1,
                color: AppColors.slate400,
              )),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 1,
                color: AppColors.slate400,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 1,
                color: AppColors.slate400,
              )),
        ),
      ),
    );
  }
}
