import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "sky_checkbox.dart";

/// [SkyCheckbox] 的 `FormField` 包装：接入 `Form` 的校验与提交流程。
class SkyCheckboxFormField extends FormField<bool> {
  SkyCheckboxFormField({
    super.key,
    required Widget label,
    bool value = false,
    ValueChanged<bool>? onChanged,
    CrossAxisAlignment labelAlignment = CrossAxisAlignment.start,
    super.validator,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(
         initialValue: value,
         builder: (field) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               SkyCheckbox(
                 value: field.value ?? false,
                 isError: field.hasError, // 出错方框变红
                 label: label,
                 labelAlignment: labelAlignment,
                 onChanged: (v) {
                   field.didChange(v); // 通知 FormField，触发校验
                   onChanged?.call(v); // 顺便把值回传给外部（可选）
                 },
               ),
               if (field.hasError)
                 Padding(
                   // 左内边距对齐方框右侧的文案起始位置，错误文案不会歪出来
                   padding: const EdgeInsets.only(
                     left: SkySpacing.s32 + SkySpacing.s2,
                     top: SkySpacing.s4,
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
