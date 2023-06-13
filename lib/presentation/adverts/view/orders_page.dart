import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outsource/navigation/route_name.dart';
import 'package:outsource/presentation/adverts/bloc/adverts_bloc.dart';
import 'package:outsource/presentation/widgets/advert_widget.dart';
import 'package:outsource/presentation/widgets/cupertino_segment_child.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const _AppBarWidget(),
        ),
        body: const _AdvertsBody());
  }
}

class _AdvertsBody extends StatefulWidget {
  const _AdvertsBody({Key? key}) : super(key: key);

  @override
  State<_AdvertsBody> createState() => _AdvertsBodyState();
}

class _AdvertsBodyState extends State<_AdvertsBody> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AdvertsBloc>();
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
                    text: LocaleKeys.active.tr(),
                    color: slidingIndex == 0
                        ? AppColors.green600
                        : AppColors.grey500,
                  ),
                  1: CupertinoSlidingChild(
                    text: LocaleKeys.completed.tr(),
                    color: slidingIndex == 1
                        ? AppColors.green600
                        : AppColors.grey500,
                  ),
                },
              ),
            ),
          ),
          IndexedStack(
              index: slidingIndex,
              children: const [
                _AdvertsList(),
                _CompletedAdvertsList()
              ],
            ),
          // if (slidingIndex == 0) _AdvertsList(),
          // if (slidingIndex == 1) _CompletedAdvertsList(),
        ],
      ),
    );
  }
}

class _CompletedAdvertsList extends StatelessWidget {
  const _CompletedAdvertsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AdvertsBloc>();
    final data = bloc.data;
    final adverts = data.adverts;
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              RouteName.advertInfo.route,
              arguments: adverts[index].id,
            );
          },
          child: AdvertInfo(advert: adverts[index]),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemCount: adverts.length,
    );
  }
}

class _AdvertsList extends StatelessWidget {
  const _AdvertsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AdvertsBloc>();
    final data = bloc.data;
    final adverts = data.adverts;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: false).pushNamed(
              RouteName.advertInfo.route,
              arguments: adverts[index].id,
            ).then((value) {
              bloc.loadActive();
            });
          },
          child: AdvertInfo(advert: adverts[index]),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemCount: adverts.length,
    );
  }
}

class _AppBarWidget extends StatelessWidget {
  const _AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          LocaleKeys.my_adverts.tr(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        // Container(
        //   padding: const EdgeInsets.symmetric(
        //     horizontal: 8,
        //     vertical: 4,
        //   ),
        //   decoration: BoxDecoration(
        //       border: Border.all(
        //         width: 1,
        //         color: AppColors.green200,
        //       ),
        //       borderRadius: BorderRadius.circular(50)),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: <Widget>[
        //       SvgPicture.asset(
        //         AppIcons.wallet,
        //         color: AppColors.green500,
        //       ),
        //       const SizedBox(width: 7),
        //       const Text(
        //         '0 UZS',
        //         style: TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w600,
        //           color: AppColors.slate900,
        //         ),
        //       )
        //     ],
        //   ),
        // )
      ],
    );
  }
}
