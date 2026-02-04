import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/config/app_texts.dart';
import 'package:flutter_herodex_3000/models/map_location.dart';

class BattleInfoDialog extends StatelessWidget {
  final MapLocation location;

  const BattleInfoDialog({super.key, required this.location});

  static void show(BuildContext context, MapLocation location) {
    showDialog(
      context: context,
      builder: (context) => BattleInfoDialog(location: location),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(location.name),
      content: Text(location.description ?? ''),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppTexts.common.close),
        ),
      ],
    );
  }
}
