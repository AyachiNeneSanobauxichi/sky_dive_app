import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";

class HappyCheckbox extends StatelessWidget {
  const HappyCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.isError = false,
  });

  final bool value;
  final ValueChanged<bool>? onChanged; // 传 null 表示禁用
  final Widget label;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    return InkWell(
      onTap: enabled ? () => onChanged!(!value) : null,
      borderRadius: BorderRadius.circular(HappyRadius.checkbox),
      child: Row(
        children: [
          Checkbox(
            value: value,
            isError: isError,
            onChanged: enabled ? (v) => onChanged!(v ?? false) : null,
          ),
          Expanded(child: label),
        ],
      ),
    );
  }
}
