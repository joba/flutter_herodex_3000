import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_state.dart';
import 'package:flutter_herodex_3000/config/texts.dart';
import 'package:flutter_herodex_3000/styles/colors.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';

class HeroesAlignmentBar extends StatelessWidget {
  final RosterState state;
  const HeroesAlignmentBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: state.goodCount,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.borderRadius),
                    bottomLeft: Radius.circular(AppConstants.borderRadius),
                  ),
                ),
              ),
            ),
            if (state.neutralCount > 0)
              Expanded(
                flex: state.neutralCount,
                child: Container(height: 4, color: Colors.grey),
              ),
            Expanded(
              flex: state.badCount,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppConstants.borderRadius),
                    bottomRight: Radius.circular(AppConstants.borderRadius),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.appPaddingBase),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Container(
                  width: AppConstants.appPaddingBase,
                  height: AppConstants.appPaddingBase,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius / 4,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.appPaddingBase / 2),
                Text(
                  '${AppTexts.roster.alignmentGood} (${state.goodCount})',
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: AppConstants.appPaddingBase,
                  height: AppConstants.appPaddingBase,
                  decoration: BoxDecoration(
                    color: AppColors.neutral,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius / 4,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.appPaddingBase / 2),
                Text(
                  '${AppTexts.roster.alignmentNeutral} (${state.neutralCount})',
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: AppConstants.appPaddingBase,
                  height: AppConstants.appPaddingBase,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius / 4,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.appPaddingBase / 2),
                Text(
                  '${AppTexts.roster.alignmentBad} (${state.badCount})',
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
