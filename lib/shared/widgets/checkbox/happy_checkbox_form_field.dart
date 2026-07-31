import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "happy_checkbox.dart";

/// [HappyCheckbox] 的 `FormField` 包装：接入 `Form` 的校验与提交流程。
class HappyCheckboxFormField extends FormField<bool> {
  HappyCheckboxFormField({
    super.key,
    required Widget label,
    bool value = false,
    ValueChanged<bool>? onChanged,
    super.validator,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(
         initialValue: value,
         builder: (field) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               HappyCheckbox(
                 value: field.value ?? false,
                 isError: field.hasError, // 出错方框变红
                 label: label,
                 onChanged: (v) {
                   field.didChange(v); // 通知 FormField，触发校验
                   onChanged?.call(v); // 顺便把值回传给外部（可选）
                 },
               ),
               if (field.hasError)
                 Padding(
                   // 左内边距对齐方框右侧的文案起始位置，错误文案不会歪出来
                   padding: const EdgeInsets.only(
                     left: HappySpacing.s32 + HappySpacing.s2,
                     top: HappySpacing.s4,
                   ),
                   child: Text(
                     field.errorText!,
                     style: Theme.of(
                       field.context,
                     ).inputDecorationTheme.errorStyle,
                   ),
                 ),
             ],
           );
         },
       );
}
