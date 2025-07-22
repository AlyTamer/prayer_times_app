import 'package:flutter/material.dart';

class PTimeWidget extends StatefulWidget {
  final bool   isCurrPrayer;
  final String currPrayer;
  final String prayerTime;
  const PTimeWidget({
    super.key,
    this.isCurrPrayer = false,
    this.currPrayer   = 'Fajr',
    this.prayerTime   = '12:12 PM',
  });

  @override
  State<PTimeWidget> createState() => _PTimeWidgetState();
}

class _PTimeWidgetState extends State<PTimeWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.isCurrPrayer
            ? Colors.green
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${widget.currPrayer} Prayer",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            widget.prayerTime,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

}
