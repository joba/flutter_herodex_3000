import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/config/texts.dart';
import 'package:flutter_herodex_3000/models/hero_alignment.dart';
import 'package:flutter_herodex_3000/styles/colors.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';

class AlignmentFilter extends StatelessWidget {
  final HeroAlignment? selectedAlignment;
  final ValueChanged<HeroAlignment?> onAlignmentChanged;

  const AlignmentFilter({
    super.key,
    required this.selectedAlignment,
    required this.onAlignmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Filter heroes by alignment',
      child: Wrap(
        spacing: AppConstants.appPaddingBase / 2,
        children: [
          FilterChip(
            label: Text(AppTexts.roster.alignmentAll),
            selectedColor: AppColors.primary,
            selected: selectedAlignment == null,
            onSelected: (_) => onAlignmentChanged(null),
            showCheckmark: false,
          ),
          FilterChip(
            label: Text(AppTexts.roster.alignmentGood),
            selectedColor: AppColors.secondary,
            selected: selectedAlignment == HeroAlignment.good,
            onSelected: (_) => onAlignmentChanged(HeroAlignment.good),
            showCheckmark: false,
          ),
          FilterChip(
            label: Text(AppTexts.roster.alignmentBad),
            selectedColor: AppColors.error,
            selected: selectedAlignment == HeroAlignment.bad,
            onSelected: (_) => onAlignmentChanged(HeroAlignment.bad),
            showCheckmark: false,
          ),
          FilterChip(
            label: Text(AppTexts.roster.alignmentNeutral),
            selectedColor: AppColors.neutral,
            selected: selectedAlignment == HeroAlignment.neutral,
            onSelected: (_) => onAlignmentChanged(HeroAlignment.neutral),
            showCheckmark: false,
          ),
        ],
      ),
    );
  }
}
