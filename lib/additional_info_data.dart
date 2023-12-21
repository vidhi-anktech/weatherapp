import 'package:flutter/material.dart';

class AdditionalInfoData extends StatelessWidget {
  final IconData icon;
  final String data;
  final String value;
  const AdditionalInfoData({
    super.key,
    required this.icon,
    required this.data,
    required this.value
  }
    );

  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              Icon(
                icon,
                size: 35,
              ),
              const SizedBox(height:8),
              Text(
                data,
                style:const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height:8),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          );
  }
}