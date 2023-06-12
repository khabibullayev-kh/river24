import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:outsource/presentation/home/bloc/home_bloc.dart';
import 'package:outsource/presentation/new_order/bloc/new_order_bloc.dart';
import 'package:outsource/presentation/new_order/view/choose_location_page.dart';
import 'package:outsource/presentation/widgets/reusable_drop_down_button.dart';
import 'package:outsource/presentation/widgets/reusable_phone_field.dart';
import 'package:outsource/presentation/widgets/reusable_text_field.dart';
import 'package:outsource/presentation/widgets/view_image_proof_page.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/resources/app_icons.dart';
import 'package:outsource/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({Key? key}) : super(key: key);

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          LocaleKeys.create_new_advert.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: const <Widget>[
                  _SenderData(),
                  Divider(height: 46, color: AppColors.slate300, thickness: 1),
                  _GetterData(),
                  Divider(height: 46, color: AppColors.slate300, thickness: 1),
                  _SendData(),
                  SizedBox(height: 18),
                  _ChooseOrderPhoto(),
                  SizedBox(height: 18),
                  _AddCommentField(),
                  SizedBox(height: 18),
                  _DoneButton(),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
          const _LoadingWidget(),
        ],
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((NewOrderBloc bloc) => bloc.data.isLoading);
    return isLoading
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white.withOpacity(0.5),
            child: const Center(
                child: CircularProgressIndicator(
              color: AppColors.green500,
            )),
          )
        : const SizedBox();
  }
}

class _SenderData extends StatefulWidget {
  const _SenderData({Key? key}) : super(key: key);

  @override
  State<_SenderData> createState() => _SenderDataState();
}

class _SenderDataState extends State<_SenderData> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NewOrderBloc>();
    final data = bloc.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          LocaleKeys.sender_data.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 23),
        ReusableTextField(
          controller: data.title,
          hintText: LocaleKeys.advert_name_text.tr(),
        ),
        const SizedBox(height: 16),
        ReusableDropDownButton(
          hintText: LocaleKeys.choose_region_city.tr(),
          items: data.fromRegionItems,
          value: data.fromRegionId,
          onChanged: bloc.setFromRegionId,
        ),
        const SizedBox(height: 16),
        ReusableDropDownButton(
          hintText: LocaleKeys.choose_region.tr(),
          items: data.fromDistrictItems,
          value: data.fromDistrictId,
          onChanged: bloc.setFromDistrict,
        ),
        const SizedBox(height: 16),
        const _ChooseLocationField(),
      ],
    );
  }
}

class _GetterData extends StatefulWidget {
  const _GetterData({Key? key}) : super(key: key);

  @override
  State<_GetterData> createState() => _GetterDataState();
}

class _GetterDataState extends State<_GetterData> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NewOrderBloc>();
    final data = bloc.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          LocaleKeys.reciever_data.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 23),
        ReusableDropDownButton(
          hintText: LocaleKeys.choose_region_city.tr(),
          items: data.toRegionItems,
          value: data.toRegionId,
          onChanged: bloc.setToRegionId,
        ),
        const SizedBox(height: 16),
        ReusableDropDownButton(
          hintText: LocaleKeys.choose_region.tr(),
          items: data.toDistrictItems,
          value: data.toDistrictId,
          onChanged: bloc.setToDistrict,
        ),
        const SizedBox(height: 16),
        ReusableTextField(
          controller: data.receiverAddress,
          hintText: LocaleKeys.address.tr(),
        ),
        const SizedBox(height: 16),
        ReusableTextField(
          controller: data.receiverFullName,
          hintText: LocaleKeys.reciever_full_name.tr(),
        ),
        const SizedBox(height: 16),
        PhoneField(
          controller: data.receiverPhoneNumber,
          hintText: LocaleKeys.reciever_phone_number.tr(),
        ),
      ],
    );
  }
}

class _SendData extends StatelessWidget {
  const _SendData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          LocaleKeys.departure_data.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            Text(
              LocaleKeys.weight.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.slate900,
              ),
            ),
            const SizedBox(width: 16),
            ...kilosWidget(context),
          ],
        ),
      ],
    );
  }

  List<Widget> kilosWidget(BuildContext context) {
    final bloc = context.watch<NewOrderBloc>();
    final data = bloc.data;
    return data.weights.map((weight) {
      return GestureDetector(
        onTap: () {
          bloc.setWeight(weight.id);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: data.weightId == weight.id ? AppColors.green500 : null,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppColors.green500, width: 1),
            ),
            child: Text(
              '${weight.value} ${weight.type.toLowerCase()}',
              style: TextStyle(
                color: data.weightId == weight.id ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _ChooseOrderPhoto extends StatelessWidget {
  const _ChooseOrderPhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NewOrderBloc>();
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.slate400, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            LocaleKeys.add_image.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: bloc.data.images.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ViewImageProofsPage(
                              images: bloc.data.images, storageImages: [],
                            );
                          },
                        ),
                      );
                    },
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 55,
                        width: 55,
                        child: Image.file(File(e.path)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              bloc.pickImages();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: AppColors.slate100,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: Text(
                  LocaleKeys.choose_files.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.slate500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _AddCommentField extends StatefulWidget {
  const _AddCommentField({Key? key}) : super(key: key);

  @override
  State<_AddCommentField> createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<_AddCommentField> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NewOrderBloc>();
    return TextField(
      controller: bloc.data.comment,
      style: const TextStyle(
        color: AppColors.slate500,
        fontSize: 16,
      ),
      maxLines: 2,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: LocaleKeys.add_comment.tr(),
        hintStyle: const TextStyle(
          color: AppColors.slate500,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.slate400,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.slate400,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.slate400,
            width: 1,
          ),
        ),
      ),
    );
  }
}

class _DoneButton extends StatelessWidget {
  const _DoneButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NewOrderBloc>();
    final homeBloc = context.watch<HomeBloc>();
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await bloc.createAdvert();
          if (bloc.data.error.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors.red500,
              duration: const Duration(seconds: 1),
              content: Text(
                LocaleKeys.full_all_fields.tr(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ));
            bloc.data.error = '';
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors.green500,
              duration: const Duration(seconds: 1),
              content: Text(
                LocaleKeys.adver_created.tr(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ));
            homeBloc.changeTab(index: 0, advertsBloc: homeBloc.advertsBloc);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //   RouteName.home.route,
            //       (Route<dynamic> route) => false,
            // );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // <-- Radius
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppIcons.done),
              const SizedBox(width: 10),
              Text(
                LocaleKeys.create_advert.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChooseLocationField extends StatefulWidget {
  const _ChooseLocationField({Key? key}) : super(key: key);

  @override
  State<_ChooseLocationField> createState() => _ChooseLocationFieldState();
}

class _ChooseLocationFieldState extends State<_ChooseLocationField> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NewOrderBloc>();
    return TextField(
      controller: bloc.data.mapAddress,
      style: const TextStyle(
        color: AppColors.slate500,
        fontSize: 16,
      ),
      onTap: () async {
        print("TAPPED LOCATION");
        final location = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return MapSample(bloc: bloc);
            },
          ),
        );
        bloc.data.mapAddress.text = location;
      },
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: LocaleKeys.select_exact_address.tr(),
        hintStyle: const TextStyle(
          color: AppColors.slate500,
          fontSize: 16,
        ),
        suffixIcon: const Icon(
          Icons.location_on_rounded,
          color: AppColors.slate400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.slate400,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.slate400,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.slate400,
            width: 1,
          ),
        ),
      ),
    );
  }
}
