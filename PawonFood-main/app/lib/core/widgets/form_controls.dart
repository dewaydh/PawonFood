import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../motion/motion.dart';
import '../motion/pressable.dart';
import '../services/formatters.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'brand_icons.dart';

/// Groups digits with dots while typing (5000 -> 5.000).
class ThousandsFormatter extends TextInputFormatter {
  const ThousandsFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return const TextEditingValue();
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write('.');
      buf.write(digits[i]);
    }
    final text = buf.toString();
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}

/// Parses "5.000" back to 5000.
int? parseAmount(String text) => int.tryParse(text.replaceAll('.', ''));

/// Two-option segmented control (Gratis / Jual murah, Saya menerima / Saya berbagi).
class SegmentedControl extends StatelessWidget {
  const SegmentedControl({super.key, required this.options, required this.selected, required this.onChanged, this.badges});

  final List<String> options;
  final int selected;
  final ValueChanged<int> onChanged;

  /// Optional unread counts, same length as [options].
  final List<int>? badges;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderDefault),
      ),
      child: Stack(alignment: Alignment.center, children: [
        Positioned.fill(
          child: AnimatedAlign(
            duration: Motion.of(context, Motion.base),
            curve: Motion.move,
            alignment: Alignment(options.length < 2 ? 0 : -1 + 2 * selected / (options.length - 1), 0),
            child: FractionallySizedBox(
              widthFactor: 1 / options.length,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 4, offset: const Offset(0, 1))],
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            for (var i = 0; i < options.length; i++)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: i == selected,
                  label: options[i],
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onChanged(i),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 42),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: AnimatedDefaultTextStyle(
                              duration: Motion.of(context, Motion.base),
                              style: AppTextStyles.button(i == selected ? colors.textPrimary : colors.textSecondary).copyWith(fontWeight: i == selected ? FontWeight.w700 : FontWeight.w600),
                              child: Text(options[i], textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          if (badges != null && badges![i] > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: colors.brandPrimary, shape: BoxShape.circle),
                              child: Text('${badges![i]}', style: AppTextStyles.label(colors.textInverse)),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ]),
    );
  }
}

/// Quantity Stepper with adaptive colors.
class QtyStepper extends StatelessWidget {
  const QtyStepper({super.key, required this.value, required this.onChanged, this.min = 1, this.max = 99});

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 140,
      height: 56,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.borderDefault),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _RoundButton(
            icon: LucideIcons.minus,
            fill: colors.backgroundSecondary,
            color: colors.textPrimary,
            label: 'Kurangi porsi',
            onTap: value > min ? () => onChanged(value - 1) : null,
          ),
          AnimatedSwitcher(
            duration: Motion.of(context, Motion.fast),
            transitionBuilder: (child, a) => FadeTransition(opacity: a, child: ScaleTransition(scale: Tween(begin: 0.7, end: 1.0).animate(a), child: child)),
            child: Text('$value', key: ValueKey(value), style: AppTextStyles.h3(colors.textPrimary)),
          ),
          _RoundButton(
            icon: LucideIcons.plus,
            fill: colors.brandPrimary,
            color: colors.textInverse,
            label: 'Tambah porsi',
            onTap: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.fill, required this.color, required this.label, required this.onTap});

  final IconData icon;
  final Color fill;
  final Color color;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        enabled: onTap != null,
        label: label,
        child: Pressable(
          enabled: onTap != null,
          scale: 0.9,
          child: Material(
            color: onTap == null ? fill.withValues(alpha: 0.5) : fill,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(onTap: onTap, child: SizedBox(width: 44, height: 44, child: Icon(icon, size: 22, color: onTap == null ? color.withValues(alpha: 0.4) : color))),
          ),
        ),
      );
}

/// Equal-width pickup deadline chips (19.00 / 20.30 / 22.00).
class TimeChips extends StatelessWidget {
  const TimeChips({super.key, required this.times, required this.selected, required this.now, required this.onSelected, this.onCustom, this.custom});

  final List<DateTime> times;
  final DateTime? selected;
  final DateTime now;
  final ValueChanged<DateTime> onSelected;
  final VoidCallback? onCustom;
  final DateTime? custom;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          for (var i = 0; i < times.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: _chip(context, times[i])),
          ],
          if (onCustom != null) ...[const SizedBox(width: 8), Expanded(child: _customChip(context))],
        ],
      );

  Widget _chipShell(BuildContext context, {required bool on, required bool enabled, required Color border, required VoidCallback? onTap, required Widget child}) {
    final colors = context.colors;
    return Pressable(
      enabled: enabled,
      child: AnimatedContainer(
        duration: Motion.of(context, Motion.base),
        curve: Motion.move,
        decoration: ShapeDecoration(
          color: on ? colors.brandPrimary : colors.surfaceCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: on ? colors.brandPrimary : border, width: border == colors.brandPrimary && !on ? 1.5 : 1)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(onTap: onTap, child: Container(height: 52, alignment: Alignment.center, padding: const EdgeInsets.symmetric(horizontal: 6), child: FittedBox(fit: BoxFit.scaleDown, child: child))),
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, DateTime t) {
    final colors = context.colors;
    final enabled = t.isAfter(now);
    final on = selected != null && selected!.isAtSameMomentAs(t);
    return Semantics(
      button: true,
      selected: on,
      enabled: enabled,
      label: 'Ambil paling lambat ${formatTime(t)}',
      child: _chipShell(
        context,
        on: on,
        enabled: enabled,
        border: colors.borderDefault,
        onTap: enabled ? () => onSelected(t) : null,
        child: Text(formatTime(t), style: AppTextStyles.button(on ? colors.textInverse : (enabled ? colors.textPrimary : colors.textDisabled))),
      ),
    );
  }

  Widget _customChip(BuildContext context) {
    final colors = context.colors;
    final t = custom;
    final on = t != null && selected != null && selected!.isAtSameMomentAs(t);
    return Semantics(
      button: true,
      selected: on,
      label: t == null ? 'Atur jam ambil sendiri' : 'Ambil paling lambat ${formatTime(t)}, ketuk untuk mengubah',
      child: _chipShell(
        context,
        on: on,
        enabled: true,
        border: t == null ? colors.brandPrimary : colors.borderDefault,
        onTap: onCustom,
        child: t == null
            ? Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(LucideIcons.pencil, size: 16, color: colors.brandPrimary),
                const SizedBox(width: 6),
                Text('Atur jam', style: AppTextStyles.button(colors.brandPrimary)),
              ])
            : Text(formatTime(t), style: AppTextStyles.button(on ? colors.textInverse : colors.textPrimary)),
      ),
    );
  }
}

/// Green checkbox with a label and an optional helper.
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({super.key, required this.value, required this.onChanged, required this.label, this.textSize = 14, this.helper, this.enabled = true});

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final double textSize;
  final String? helper;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      checked: value,
      enabled: enabled,
      label: helper == null ? label : '$label. $helper',
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: InkWell(
          onTap: enabled ? () => onChanged(!value) : null,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: AnimatedContainer(
                    duration: Motion.of(context, Motion.fast),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: value ? colors.brandPrimary : colors.surfaceCard,
                      borderRadius: BorderRadius.circular(6),
                      border: value ? null : Border.all(color: colors.borderStrong, width: 1.5),
                    ),
                    child: AnimatedScale(
                      scale: value ? 1 : 0.5,
                      duration: Motion.of(context, Motion.base),
                      curve: value ? Motion.pop : Motion.exit,
                      child: AnimatedOpacity(
                        opacity: value ? 1 : 0,
                        duration: Motion.of(context, Motion.base),
                        child: Icon(LucideIcons.check, size: 16, color: colors.textInverse),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: AppTextStyles.bodyMedium(colors.textPrimary)),
                        if (helper != null) Text(helper!, style: AppTextStyles.caption(colors.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Text field with a label above, error text with icon, and password visibility toggle.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.errorText,
    this.helperText,
    this.password = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.prefix,
    this.suffixText,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.semanticLabel,
    this.maxLines = 1,
  });

  final String label;
  final int maxLines;
  final String? semanticLabel;
  final TextEditingController? controller;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final bool password;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? prefix;
  final String? suffixText;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.password;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasError = widget.errorText != null;

    OutlineInputBorder border(Color c, double w) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c, width: w),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(widget.label, style: AppTextStyles.h4(colors.textPrimary)),
          const SizedBox(height: 6),
        ],
        Semantics(
          label: widget.semanticLabel ?? (widget.label.isNotEmpty ? widget.label : widget.hint),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            obscureText: _obscured,
            maxLines: _obscured ? 1 : widget.maxLines,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            style: AppTextStyles.bodyLarge(colors.textPrimary),
            cursorColor: colors.brandPrimary,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.bodyLarge(colors.textPlaceholder),
              filled: true,
              fillColor: colors.surfaceInput,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              prefixIcon: widget.prefix == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: Text(widget.prefix!, style: AppTextStyles.button(colors.textSecondary)),
                    ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixText: widget.suffixText,
              suffixStyle: AppTextStyles.bodyMedium(colors.textSecondary),
              suffixIcon: widget.password
                  ? IconButton(
                      tooltip: _obscured ? 'Tampilkan password' : 'Sembunyikan password',
                      onPressed: () => setState(() => _obscured = !_obscured),
                      icon: _obscured ? FluentEyeOffIcon(color: colors.textSecondary) : FluentEyeIcon(color: colors.textSecondary),
                    )
                  : null,
              enabledBorder: border(hasError ? colors.semanticError : colors.borderDefault, hasError ? 1.5 : 1),
              focusedBorder: border(hasError ? colors.semanticError : colors.borderFocus, 1.5),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Semantics(
            liveRegion: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Icon(LucideIcons.triangleAlert, size: 16, color: colors.semanticError),
                ),
                const SizedBox(width: 6),
                Expanded(child: Text(widget.errorText!, style: AppTextStyles.caption(colors.semanticError).copyWith(fontWeight: FontWeight.w600))),
              ],
            ),
          ),
        ] else if (widget.helperText != null) ...[
          const SizedBox(height: 6),
          Text(widget.helperText!, style: AppTextStyles.caption(colors.textSecondary)),
        ],
      ],
    );
  }
}
