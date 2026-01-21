import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HerodexLogo extends StatelessWidget {
  static const String logo = 'assets/herodex_3000.svg';

  const HerodexLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(logo, semanticsLabel: 'Herodex 3000');
  }
}
