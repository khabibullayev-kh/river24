import 'package:flutter/material.dart';

class CupertinoSlidingChild extends StatelessWidget {
  final String text;
  final Color color;
  final int? orderCount;

  const CupertinoSlidingChild({
    Key? key,
    required this.text,
    required this.color,
    this.orderCount,
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
          if (orderCount != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: Text(
                orderCount.toString(),
                style: const TextStyle(
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
