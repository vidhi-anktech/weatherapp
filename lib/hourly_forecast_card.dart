import 'package:flutter/material.dart';

class HourlyForecastCard extends StatelessWidget {
  final String time;
  final String value;
  final IconData icon;
  const HourlyForecastCard({
    super.key,
    required this.time,
    required this.value,
    required this.icon
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
          elevation: 5,
          shadowColor: Colors.white,
          color: const Color.fromARGB(255, 66, 64, 64),
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Icon(
                  icon,
                  size: 25,
                ),
                Text(
                  value,
                  style:const TextStyle(
                    fontSize: 15,
                  ),
                )
              ],
            ),
          )),
    );
  }
}