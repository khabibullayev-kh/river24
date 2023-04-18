import 'package:flutter/material.dart';
import 'package:outsource/presentation/adverts/models/advert.dart';
import 'package:outsource/resources/app_colors.dart';

class AdvertInfo extends StatelessWidget {
  final Advert advert;

  const AdvertInfo({Key? key, required this.advert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.only(
          top: 16,
          right: 16,
          left: 16,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  advert.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900,
                  ),
                ),
                Text(
                  advert.createdTime,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.slate500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TimeLineVertical(advert: advert),
            const SizedBox(height: 12),
            _MakeStatusRow(status: advert.status),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     // _FinishedStatus(
            //     //   endedOrClickText:
            //     //       order.isFinished != null ? 'Завершен' : '${order.clicks}',
            //     // ),
            //     // if (order.isFinished != null)
            //     //   const Text(
            //     //     'Нажмите чтобы оценить',
            //     //     style: TextStyle(
            //     //       fontSize: 14,
            //     //       fontWeight: FontWeight.w700,
            //     //       color: AppColors.amber500,
            //     //     ),
            //     //   )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class _MakeStatusRow extends StatelessWidget {
  final String status;

  const _MakeStatusRow({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case "PENDING":
        return Row(
          children: [
            _WaitingStatus(),
          ],
        );
      case "ON_THE_WAY":
        return Row(
          children: [
            _OnTheWayStatus(),
          ],
        );
      case "CANCELED":
        return Row(
          children: [
            _CanceledStatus(),
          ],
        );
      case "COMPLETED":
        return Row(
          children: [
            _FinishedStatus(endedOrClickText: 'Завершен'),
          ],
        );
      default:
        return Row(
          children: [
            _FinishedStatus(endedOrClickText: '3 отклика'),
          ],
        );
    }
    return Container();
  }
}

class TimeLineVertical extends StatelessWidget {
  final Advert advert;

  const TimeLineVertical({
    Key? key,
    required this.advert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 1,
              height: 51,
              color: AppColors.slate500,
            ),
            Column(
              children: [
                _indicatorWidget(),
                const SizedBox(height: 18),
                _indicatorWidget(),
              ],
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '${advert.fromRegion}, ${advert.fromDistrict}',
                  textAlign: TextAlign.start,
                  style:
                      const TextStyle(fontSize: 14, color: AppColors.slate900),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '${advert.toRegion}, ${advert.toDistrict}',
                  textAlign: TextAlign.start,
                  style:
                      const TextStyle(fontSize: 14, color: AppColors.slate900),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Stack _indicatorWidget() {
    return Stack(
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
    );
  }
}

class _FinishedStatus extends StatelessWidget {
  final String endedOrClickText;

  const _FinishedStatus({required this.endedOrClickText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.green500,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        endedOrClickText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _PriceStatus extends StatelessWidget {
  final String price;

  const _PriceStatus({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.green500.withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        price,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _OnTheWayStatus extends StatelessWidget {
  const _OnTheWayStatus();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            width: 1,
            color: AppColors.green500,
          )),
      child: const Text(
        'В пути',
        style: TextStyle(
          color: AppColors.green500,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _WaitingStatus extends StatelessWidget {
  const _WaitingStatus();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.amber500,
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Text(
        'В ожидании',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _CanceledStatus extends StatelessWidget {
  const _CanceledStatus();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.red500,
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Text(
        'Отменен',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}
