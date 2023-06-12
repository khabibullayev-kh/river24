import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:outsource/navigation/route_name.dart';
import 'package:outsource/presentation/register/bloc/register_bloc.dart';
import 'package:outsource/presentation/widgets/agreement_policy.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/resources/app_icons.dart';
import 'package:outsource/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';

class LastStepPage extends StatefulWidget {
  final RegisterBloc bloc;

  const LastStepPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<LastStepPage> createState() => _LastStepPageState();
}

class _LastStepPageState extends State<LastStepPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.bloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  SizedBox(height: 24),
                  _LastStepText(),
                  SizedBox(height: 24),
                  _CircleAvatar(),
                  SizedBox(height: 24),
                  _FullNameField(),
                  Divider(color: AppColors.slate300, height: 48),
                  _DoneButton(),
                  Expanded(child: SizedBox()),
                  Divider(thickness: 1, height: 1),
                  SizedBox(height: 24),
                  AgreementPolicy(),
                  SizedBox(height: 24),
                ],
              ),
              const _LoadingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((RegisterBloc bloc) => bloc.data.isLoading);
    return isLoading
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white.withOpacity(0.5),
            child: const Center(child: CircularProgressIndicator()),
          )
        : const SizedBox();
  }
}

class _LastStepText extends StatelessWidget {
  const _LastStepText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocaleKeys.last_step.tr(),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: Color(0xFF2D283F),
        ),
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
    final controller = context.read<RegisterBloc>().data.fullNameController;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
        height: 60,
        child: TextFormField(
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
    final bloc = context.watch<RegisterBloc>();
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
              backgroundImage: bloc.data.croppedImage != null
                  ? MemoryImage(bloc.data.croppedImage!)
                  : const AssetImage(AppIcons.exampleImage) as ImageProvider,
            ),
          ),
          Positioned(
            bottom: -3,
            child: GestureDetector(
              onTap: () async {
                final isChanged = await Navigator.of(context).pushNamed(
                  RouteName.cropImage.route,
                  arguments: bloc,
                );
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

class _DoneButton extends StatelessWidget {
  const _DoneButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isHeight = MediaQuery.of(context).size.height > 900;
    final bloc = context.watch<RegisterBloc>();
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 16),
        child: ElevatedButton(
          onPressed: () async {
            await bloc.saveUserData();
            if (bloc.data.isSuccess) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                RouteName.enterPin.route,
                (Route<dynamic> route) => false,
                //arguments: bloc,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // <-- Radius
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isHeight ? 32 : 20,
              vertical: isHeight ? 16 : 14,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppIcons.done),
                const SizedBox(width: 10),
                Text(
                  LocaleKeys.ready.tr(),
                  style: TextStyle(
                    fontSize: isHeight ? 14 : 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
