import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outsource/data/models/request_dto.dart';
import 'package:outsource/presentation/advert_info/bloc/advert_info_bloc.dart';
import 'package:outsource/presentation/adverts/models/advert.dart';
import 'package:outsource/presentation/edit_advert/bloc/edit_advert_bloc.dart';
import 'package:outsource/presentation/edit_advert/view/edit_advert.dart';
import 'package:outsource/presentation/widgets/cupertino_segment_child.dart';
import 'package:outsource/presentation/widgets/view_image_proof_page.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/resources/app_icons.dart';
import 'package:outsource/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertInfoPage extends StatefulWidget {
  final int advertId;

  const AdvertInfoPage({Key? key, required this.advertId}) : super(key: key);

  @override
  State<AdvertInfoPage> createState() => _AdvertInfoPageState();
}

class _AdvertInfoPageState extends State<AdvertInfoPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
    final bloc = context.watch<AdvertInfoBloc>();
    return WillPopScope(
      onWillPop: Platform.isAndroid
          ? () async {
              print(navigatorKey.currentState);
              return true;
              // if (navigatorKey.currentState != null &&
              //     navigatorKey.currentState!.canPop()) {
              //   navigatorKey.currentState!.pop();
              //   return true;
              // }
              // return false;
            }
          : null,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            bloc.data.advert?.title ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
        ),
        body: const _AdvertInfoBody(),
      ),
    );
  }
}

class _AdvertInfoBody extends StatefulWidget {
  const _AdvertInfoBody({Key? key}) : super(key: key);

  @override
  State<_AdvertInfoBody> createState() => _AdvertInfoBodyState();
}

class _AdvertInfoBodyState extends State<_AdvertInfoBody> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AdvertInfoBloc>();
    final int? slidingIndex = bloc.data.slideIndex;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 16),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoSlidingSegmentedControl(
                groupValue: slidingIndex,
                backgroundColor: Colors.white,
                onValueChanged: (int? value) {
                  setState(() {
                    bloc.data.slideIndex = value;
                    bloc.getData(value ?? 0);
                  });
                },
                children: {
                  0: CupertinoSlidingChild(
                    text: LocaleKeys.order_data.tr(),
                    color: slidingIndex == 0
                        ? AppColors.green600
                        : AppColors.grey500,
                  ),
                  1: CupertinoSlidingChild(
                    orderCount: bloc.data.requests.isEmpty
                        ? null
                        : bloc.data.requests.length,
                    text: LocaleKeys.responses.tr(),
                    color: slidingIndex == 1
                        ? AppColors.green600
                        : AppColors.grey500,
                  ),
                },
              ),
            ),
          ),
          if (slidingIndex == 0) const _AdvertDetails(),
          if (slidingIndex == 1) const _MyRequests(),
        ],
      ),
    );
  }
}

class _AdvertDetails extends StatefulWidget {
  const _AdvertDetails({Key? key}) : super(key: key);

  @override
  State<_AdvertDetails> createState() => _AdvertDetailsState();
}

class _AdvertDetailsState extends State<_AdvertDetails> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AdvertInfoBloc>();
    final advert = bloc.data.advert;
    return !bloc.data.isLoading
        ? Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 16.0,
              bottom: 40.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (advert?.canEdit == false) ...[
                    _ContactDataWidget(
                      title: LocaleKeys.courier_contacts.tr(),
                      name: '${advert?.driverFullName}',
                      phone: '${advert?.driverPhoneNumber}',
                    ),
                    const SizedBox(height: 24)
                  ],
                  Text(
                    advert?.title ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate900,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _LocationsNameWidget(
                    text: '${advert?.fromRegion}, ${advert?.fromDistrict}',
                  ),
                  const SizedBox(height: 8),
                  _ContactDataWidget(
                    title: LocaleKeys.sender_contacts.tr(),
                    name: '${advert?.senderFullName}',
                    phone: '${advert?.senderPhoneNumber}',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Container(
                      width: 1,
                      height: 28,
                      color: AppColors.slate500.withOpacity(0.3),
                    ),
                  ),
                  _LocationsNameWidget(
                    text: '${advert?.toRegion}, ${advert?.toDistrict}',
                  ),
                  const SizedBox(height: 8),
                  _ContactDataWidget(
                    title: LocaleKeys.recipient_contacts.tr(),
                    name: '${advert?.receiverFullName}',
                    phone: '${advert?.receiverPhoneNumber}',
                  ),
                  const SizedBox(height: 8),
                  _OrderInfoWidget(advert: advert!),
                  const SizedBox(height: 16),
                  const _ActionButtons(),
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              color: AppColors.green500,
            ),
          );
  }
}

class _MyRequests extends StatefulWidget {
  const _MyRequests({Key? key}) : super(key: key);

  @override
  State<_MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<_MyRequests> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AdvertInfoBloc>();
    final requests = bloc.data.requests;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: requests.map((request) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _RequestCardWidget(request: request),
          );
        }).toList(),
      ),
    );
  }
}

class _RequestCardWidget extends StatelessWidget {
  final RequestDto request;

  const _RequestCardWidget({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AdvertInfoBloc>();
    return Opacity(
      opacity:
          request.status == "ACCEPTED" || request.status == "PENDING" ? 1 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    height: 40,
                    width: 40,
                    AppIcons.exampleImage,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '${request.fullName}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.slate900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        text: '${LocaleKeys.response_for.tr()} ',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.slate900,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '${request.price} ${LocaleKeys.sum_text.tr()}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.slate900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Row(
                  children: <Widget>[
                    Text(
                      '${request.calculatedRating}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.star,
                        color: AppColors.yellow500, size: 10),
                    Text(
                      ' / ${request.countOfRates} ${LocaleKeys.reviews.tr()}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _AcceptButton(
              request: request,
              onPressed: () async {
                if (request.canRequest) {
                  await bloc.acceptRequest(request.id);
                } else {
                  launchUrl(Uri.parse('tel://+${request.phoneNumber}'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AcceptButton extends StatelessWidget {
  final RequestDto request;
  final VoidCallback onPressed;

  const _AcceptButton({
    Key? key,
    required this.request,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:
          request.status == "ACCEPTED" || request.canRequest ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green500,
        disabledBackgroundColor: AppColors.green500.withOpacity(0.5),
        disabledForegroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // <-- Radius
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (request.status != "ACCEPTED")
              Image.asset(AppIcons.done, width: 16, height: 16),
            if (request.status == "ACCEPTED") const Icon(Icons.call, size: 16),
            const SizedBox(width: 10),
            Text(
              request.status != "ACCEPTED"
                  ? LocaleKeys.accept.tr()
                  : LocaleKeys.call_the_courier.tr(),
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

class _LocationsNameWidget extends StatelessWidget {
  final String text;

  const _LocationsNameWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppColors.slate100,
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 11,
                        width: 11,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: AppColors.green500,
                          ),
                        ),
                      ),
                      Container(
                        height: 6.88,
                        width: 6.88,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.green500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 11),
                  Flexible(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: AppColors.slate900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: AppColors.slate100,
            ),
            child: const Center(
              child: Icon(
                Icons.location_on_rounded,
                color: AppColors.slate400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactDataWidget extends StatelessWidget {
  final String title;
  final String name;
  final String phone;

  const _ContactDataWidget({
    Key? key,
    required this.title,
    required this.name,
    required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: AppColors.slate100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.slate900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.slate900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '+$phone',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.slate900,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              launchUrl(Uri.parse('tel://+$phone'));
            },
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              child: const Center(
                child: Icon(
                  Icons.phone,
                  color: AppColors.green500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderInfoWidget extends StatelessWidget {
  final Advert advert;

  const _OrderInfoWidget({Key? key, required this.advert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> imagesPaths = [];
    for (ImagesDto i in advert.images ?? []) {
      imagesPaths.add(i.urlPath);
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: AppColors.slate100,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (advert.images != null) ...[
            Text(
              LocaleKeys.order_images.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.slate900,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: advert.images!.map((e) {
                  return Hero(
                    tag: 'images',
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ViewImageProofsPage(
                                  images: [],
                                  storageImages: imagesPaths,
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
                            child: Image.network(e.urlPath),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (advert.comment != null) ...[
            Text(
              LocaleKeys.comment.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.slate900,
              ),
            ),
            Flexible(
              child: Text(
                '${advert.comment}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.slate500,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
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
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.green500, width: 1),
                ),
                child: Text(
                  '${advert.weight} ${advert.weightType?.toLowerCase()}',
                  style: const TextStyle(
                    color: AppColors.slate900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AdvertInfoBloc>();
    final advert = bloc.data.advert;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        advert!.canCancel == true
            ? Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await bloc.cancelAdvert();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red500,
                      disabledBackgroundColor:
                          AppColors.red500.withOpacity(0.5),
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(AppIcons.closeRounded),
                        const SizedBox(width: 10),
                        Text(LocaleKeys.cancel.tr()),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: advert.canEdit!
                ? () async {
                    final isTrue = await Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ChangeNotifierProvider(
                            create: (context) => EditAdvertBloc(advert.id),
                            child: EditAdvertPage(advertId: advert.id),
                          );
                        },
                      ),
                    );
                    if (isTrue == true) {
                      bloc.getAdvert();
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.slate900,
                disabledBackgroundColor: AppColors.slate900.withOpacity(0.5),
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(AppIcons.pencil),
                  const SizedBox(width: 10),
                  Text(LocaleKeys.edit.tr()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
