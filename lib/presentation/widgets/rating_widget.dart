import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:outsource/presentation/adverts/bloc/adverts_bloc.dart';
import 'package:outsource/presentation/adverts/models/advert.dart';
import 'package:outsource/presentation/widgets/reusable_confirm_button.dart';
import 'package:outsource/resources/app_colors.dart';
import 'package:provider/provider.dart';

class RatingWidget extends StatefulWidget {
  final Advert advert;

  const RatingWidget({Key? key, required this.advert}) : super(key: key);

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AdvertsBloc>();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Оценить работу',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.slate900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.slate900,
                  ),
                ),
                // IconButton(
                //   padding: EdgeInsets.zero,
                //   onPressed: () {},
                //   icon: const Icon(Icons.close),
                // )
              ],
            ),
          ),
          RatingBar.builder(
            itemCount: 5,
            itemPadding: const EdgeInsets.all(10),
            itemSize: 40.0,
            unratedColor: AppColors.slate300,
            itemBuilder: (context, index) {
              return const Icon(
                Icons.star_rounded,
                color: AppColors.amber500,
                size: 40,
              );
            },
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ReusableConfirmButton(
              onTap: () {
                bloc.rateAdvert(
                  advertId: widget.advert.id,
                  driverId: widget.advert.driverId!,
                  rate: _rating.toInt(),
                );
                Navigator.pop(context);

              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
