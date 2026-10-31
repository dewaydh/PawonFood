import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../motion/motion.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Rounded group of [SettingsRow]s with an optional small heading above.
/// Theme-aware: adapts surface, borders and dividers to dark mode.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              title!,
              style: AppTypography.labelExpressive(
                13.5,
                weight: 700,
                color: AppColors.inkMutedOf(context),
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: [
            for (final (i, c) in children.indexed) ...[
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Divider(height: 1, thickness: 1, color: borderColor),
                ),
              c,
            ],
          ]),
        ),
      ],
    );
  }
}

/// One row: title, optional subtitle, and a chevron, a switch or nothing on the right. [destructive] is red.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.chevron = true,
    this.toggle,
    this.onToggle,
    this.destructive = false,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool chevron;

  /// Switch value; when set, the row shows a switch instead of the chevron.
  final bool? toggle;
  final ValueChanged<bool>? onToggle;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final hasToggle = toggle != null;
    final tap = hasToggle ? () => onToggle?.call(!toggle!) : onTap;
    final inkColor = AppColors.inkOf(context);
    final inkMutedColor = AppColors.inkMutedOf(context);

    return Semantics(
      button: !hasToggle,
      toggled: toggle,
      label: [title, ?subtitle].join(', '),
      onTap: tap,
      excludeSemantics: true,
      child: InkWell(
        onTap: tap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.display(
                        15.5,
                        weight: 600,
                        height: 22,
                        color: destructive ? AppColors.error : inkColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.text(13, height: 18, color: inkMutedColor),
                      ),
                    ],
                  ],
                ),
              ),
              if (hasToggle)
                Switch(
                  value: toggle!,
                  onChanged: onToggle,
                  activeTrackColor: AppColors.primaryOf(context),
                  activeThumbColor: Colors.white,
                  inactiveTrackColor: AppColors.sandOf(context),
                  inactiveThumbColor: inkMutedColor,
                  trackOutlineColor: WidgetStateProperty.resolveWith(
                    (s) => s.contains(WidgetState.selected)
                        ? AppColors.primaryOf(context)
                        : AppColors.borderStrongOf(context),
                  ),
                )
              else if (chevron)
                Icon(LucideIcons.chevronRight, size: 20, color: inkMutedColor),
            ],
          ),
        ),
      ),
    );
  }
}

/// FAQ-style row that opens to show [body]; the chevron turns as it opens.
class ExpandableRow extends StatefulWidget {
  const ExpandableRow({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  State<ExpandableRow> createState() => _ExpandableRowState();
}

class _ExpandableRowState extends State<ExpandableRow> {
  var _open = false;

  @override
  Widget build(BuildContext context) {
    final d = Motion.of(context, Motion.base);
    final inkColor = AppColors.inkOf(context);
    final inkMutedColor = AppColors.inkMutedOf(context);

    return Semantics(
      button: true,
      expanded: _open,
      child: InkWell(
        onTap: () => setState(() => _open = !_open),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppTypography.display(15.5, weight: 600, height: 22, color: inkColor),
                  ),
                ),
                AnimatedRotation(
                  turns: _open ? 0.25 : 0,
                  duration: d,
                  curve: Motion.move,
                  child: Icon(LucideIcons.chevronRight, size: 20, color: inkMutedColor),
                ),
              ]),
              AnimatedSize(
                duration: d,
                curve: Motion.move,
                alignment: Alignment.topCenter,
                child: _open
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          widget.body,
                          style: AppTypography.text(14, height: 21, color: inkMutedColor),
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
