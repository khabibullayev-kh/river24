import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:outsource/presentation/adverts/bloc/adverts_bloc.dart';
import 'package:outsource/presentation/adverts/models/advert.dart';
import 'package:outsource/presentation/widgets/advert_info.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:outsource/resources/app_icons.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdvertsBloc(),
      child: Scaffold(
          appBar: AppBar(
            title: const _AppBarWidget(),
          ),
          body: const _AdvertsBody()),
    );
  }
}

class _AdvertsBody extends StatefulWidget {
  const _AdvertsBody({Key? key}) : super(key: key);

  @override
  State<_AdvertsBody> createState() => _AdvertsBodyState();
}

class _AdvertsBodyState extends State<_AdvertsBody> {
  int? _sliding = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 16),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoSlidingSegmentedControl(
                groupValue: _sliding,
                backgroundColor: Colors.white,
                onValueChanged: (int? value) {
                  setState(() {
                    _sliding = value;
                    print(_sliding);
                  });
                },
                children: {
                  0: _CupertinoSlidingChild(
                    text: 'Активные',
                    color:
                        _sliding == 0 ? AppColors.green600 : AppColors.grey500,
                  ),
                  1: _CupertinoSlidingChild(
                    text: 'Выполненные',
                    color:
                        _sliding == 1 ? AppColors.green600 : AppColors.grey500,
                  ),
                },
              ),
            ),
          ),
          _AdvertsList(),
        ],
      ),
    );
  }
}

class _AdvertsList extends StatelessWidget {
  const _AdvertsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AdvertsBloc>().data;
    final adverts = data.adverts;
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return AdvertInfo(advert: adverts[index]);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemCount: adverts.length,
    );
  }
}

class _CupertinoSlidingChild extends StatelessWidget {
  final String text;
  final Color color;

  const _CupertinoSlidingChild({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
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
        const Text(
          'Мои заказы',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: AppColors.green200,
              ),
              borderRadius: BorderRadius.circular(50)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                AppIcons.wallet,
                color: AppColors.green500,
              ),
              const SizedBox(width: 7),
              const Text(
                '0 UZS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate900,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
