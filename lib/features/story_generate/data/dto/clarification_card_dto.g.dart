// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clarification_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClarificationCardDto _$ClarificationCardDtoFromJson(
  Map<String, dynamic> json,
) => _ClarificationCardDto(
  question: json['question'] as String? ?? "",
  description: json['description'] as String?,
  cardType: json['card_type'] as String?,
  options:
      (json['options'] as List<dynamic>?)
          ?.map(
            (e) => ClarificationOptionDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <ClarificationOptionDto>[],
  allowCustom: json['allow_custom'] as bool? ?? false,
  inputPlaceholder: json['input_placeholder'] as String?,
  minSelections: (json['min_selections'] as num?)?.toInt(),
  maxSelections: (json['max_selections'] as num?)?.toInt(),
);

Map<String, dynamic> _$ClarificationCardDtoToJson(
  _ClarificationCardDto instance,
) => <String, dynamic>{
  'question': instance.question,
  'description': instance.description,
  'card_type': instance.cardType,
  'options': instance.options,
  'allow_custom': instance.allowCustom,
  'input_placeholder': instance.inputPlaceholder,
  'min_selections': instance.minSelections,
  'max_selections': instance.maxSelections,
};

_ClarificationOptionDto _$ClarificationOptionDtoFromJson(
  Map<String, dynamic> json,
) => _ClarificationOptionDto(
  value: json['value'] as String? ?? "",
  label: json['label'] as String? ?? "",
  description: json['description'] as String?,
);

Map<String, dynamic> _$ClarificationOptionDtoToJson(
  _ClarificationOptionDto instance,
) => <String, dynamic>{
  'value': instance.value,
  'label': instance.label,
  'description': instance.description,
};
