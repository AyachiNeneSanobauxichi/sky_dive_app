// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clarification_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClarificationCardDto {

 String get question; String? get description;@JsonKey(name: "card_type") String? get cardType; List<ClarificationOptionDto> get options;@JsonKey(name: "allow_custom") bool get allowCustom;@JsonKey(name: "input_placeholder") String? get inputPlaceholder;@JsonKey(name: "min_selections") int? get minSelections;@JsonKey(name: "max_selections") int? get maxSelections;/// 当前是第几轮澄清（从 1 起）。
 int? get round;/// 一共最多问几轮。
@JsonKey(name: "max_rounds") int? get maxRounds;
/// Create a copy of ClarificationCardDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClarificationCardDtoCopyWith<ClarificationCardDto> get copyWith => _$ClarificationCardDtoCopyWithImpl<ClarificationCardDto>(this as ClarificationCardDto, _$identity);

  /// Serializes this ClarificationCardDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClarificationCardDto&&(identical(other.question, question) || other.question == question)&&(identical(other.description, description) || other.description == description)&&(identical(other.cardType, cardType) || other.cardType == cardType)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.allowCustom, allowCustom) || other.allowCustom == allowCustom)&&(identical(other.inputPlaceholder, inputPlaceholder) || other.inputPlaceholder == inputPlaceholder)&&(identical(other.minSelections, minSelections) || other.minSelections == minSelections)&&(identical(other.maxSelections, maxSelections) || other.maxSelections == maxSelections)&&(identical(other.round, round) || other.round == round)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,description,cardType,const DeepCollectionEquality().hash(options),allowCustom,inputPlaceholder,minSelections,maxSelections,round,maxRounds);

@override
String toString() {
  return 'ClarificationCardDto(question: $question, description: $description, cardType: $cardType, options: $options, allowCustom: $allowCustom, inputPlaceholder: $inputPlaceholder, minSelections: $minSelections, maxSelections: $maxSelections, round: $round, maxRounds: $maxRounds)';
}


}

/// @nodoc
abstract mixin class $ClarificationCardDtoCopyWith<$Res>  {
  factory $ClarificationCardDtoCopyWith(ClarificationCardDto value, $Res Function(ClarificationCardDto) _then) = _$ClarificationCardDtoCopyWithImpl;
@useResult
$Res call({
 String question, String? description,@JsonKey(name: "card_type") String? cardType, List<ClarificationOptionDto> options,@JsonKey(name: "allow_custom") bool allowCustom,@JsonKey(name: "input_placeholder") String? inputPlaceholder,@JsonKey(name: "min_selections") int? minSelections,@JsonKey(name: "max_selections") int? maxSelections, int? round,@JsonKey(name: "max_rounds") int? maxRounds
});




}
/// @nodoc
class _$ClarificationCardDtoCopyWithImpl<$Res>
    implements $ClarificationCardDtoCopyWith<$Res> {
  _$ClarificationCardDtoCopyWithImpl(this._self, this._then);

  final ClarificationCardDto _self;
  final $Res Function(ClarificationCardDto) _then;

/// Create a copy of ClarificationCardDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? question = null,Object? description = freezed,Object? cardType = freezed,Object? options = null,Object? allowCustom = null,Object? inputPlaceholder = freezed,Object? minSelections = freezed,Object? maxSelections = freezed,Object? round = freezed,Object? maxRounds = freezed,}) {
  return _then(_self.copyWith(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,cardType: freezed == cardType ? _self.cardType : cardType // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<ClarificationOptionDto>,allowCustom: null == allowCustom ? _self.allowCustom : allowCustom // ignore: cast_nullable_to_non_nullable
as bool,inputPlaceholder: freezed == inputPlaceholder ? _self.inputPlaceholder : inputPlaceholder // ignore: cast_nullable_to_non_nullable
as String?,minSelections: freezed == minSelections ? _self.minSelections : minSelections // ignore: cast_nullable_to_non_nullable
as int?,maxSelections: freezed == maxSelections ? _self.maxSelections : maxSelections // ignore: cast_nullable_to_non_nullable
as int?,round: freezed == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as int?,maxRounds: freezed == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClarificationCardDto].
extension ClarificationCardDtoPatterns on ClarificationCardDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClarificationCardDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClarificationCardDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClarificationCardDto value)  $default,){
final _that = this;
switch (_that) {
case _ClarificationCardDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClarificationCardDto value)?  $default,){
final _that = this;
switch (_that) {
case _ClarificationCardDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String question,  String? description, @JsonKey(name: "card_type")  String? cardType,  List<ClarificationOptionDto> options, @JsonKey(name: "allow_custom")  bool allowCustom, @JsonKey(name: "input_placeholder")  String? inputPlaceholder, @JsonKey(name: "min_selections")  int? minSelections, @JsonKey(name: "max_selections")  int? maxSelections,  int? round, @JsonKey(name: "max_rounds")  int? maxRounds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClarificationCardDto() when $default != null:
return $default(_that.question,_that.description,_that.cardType,_that.options,_that.allowCustom,_that.inputPlaceholder,_that.minSelections,_that.maxSelections,_that.round,_that.maxRounds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String question,  String? description, @JsonKey(name: "card_type")  String? cardType,  List<ClarificationOptionDto> options, @JsonKey(name: "allow_custom")  bool allowCustom, @JsonKey(name: "input_placeholder")  String? inputPlaceholder, @JsonKey(name: "min_selections")  int? minSelections, @JsonKey(name: "max_selections")  int? maxSelections,  int? round, @JsonKey(name: "max_rounds")  int? maxRounds)  $default,) {final _that = this;
switch (_that) {
case _ClarificationCardDto():
return $default(_that.question,_that.description,_that.cardType,_that.options,_that.allowCustom,_that.inputPlaceholder,_that.minSelections,_that.maxSelections,_that.round,_that.maxRounds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String question,  String? description, @JsonKey(name: "card_type")  String? cardType,  List<ClarificationOptionDto> options, @JsonKey(name: "allow_custom")  bool allowCustom, @JsonKey(name: "input_placeholder")  String? inputPlaceholder, @JsonKey(name: "min_selections")  int? minSelections, @JsonKey(name: "max_selections")  int? maxSelections,  int? round, @JsonKey(name: "max_rounds")  int? maxRounds)?  $default,) {final _that = this;
switch (_that) {
case _ClarificationCardDto() when $default != null:
return $default(_that.question,_that.description,_that.cardType,_that.options,_that.allowCustom,_that.inputPlaceholder,_that.minSelections,_that.maxSelections,_that.round,_that.maxRounds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClarificationCardDto extends ClarificationCardDto {
  const _ClarificationCardDto({this.question = "", this.description, @JsonKey(name: "card_type") this.cardType, final  List<ClarificationOptionDto> options = const <ClarificationOptionDto>[], @JsonKey(name: "allow_custom") this.allowCustom = false, @JsonKey(name: "input_placeholder") this.inputPlaceholder, @JsonKey(name: "min_selections") this.minSelections, @JsonKey(name: "max_selections") this.maxSelections, this.round, @JsonKey(name: "max_rounds") this.maxRounds}): _options = options,super._();
  factory _ClarificationCardDto.fromJson(Map<String, dynamic> json) => _$ClarificationCardDtoFromJson(json);

@override@JsonKey() final  String question;
@override final  String? description;
@override@JsonKey(name: "card_type") final  String? cardType;
 final  List<ClarificationOptionDto> _options;
@override@JsonKey() List<ClarificationOptionDto> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override@JsonKey(name: "allow_custom") final  bool allowCustom;
@override@JsonKey(name: "input_placeholder") final  String? inputPlaceholder;
@override@JsonKey(name: "min_selections") final  int? minSelections;
@override@JsonKey(name: "max_selections") final  int? maxSelections;
/// 当前是第几轮澄清（从 1 起）。
@override final  int? round;
/// 一共最多问几轮。
@override@JsonKey(name: "max_rounds") final  int? maxRounds;

/// Create a copy of ClarificationCardDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClarificationCardDtoCopyWith<_ClarificationCardDto> get copyWith => __$ClarificationCardDtoCopyWithImpl<_ClarificationCardDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClarificationCardDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClarificationCardDto&&(identical(other.question, question) || other.question == question)&&(identical(other.description, description) || other.description == description)&&(identical(other.cardType, cardType) || other.cardType == cardType)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.allowCustom, allowCustom) || other.allowCustom == allowCustom)&&(identical(other.inputPlaceholder, inputPlaceholder) || other.inputPlaceholder == inputPlaceholder)&&(identical(other.minSelections, minSelections) || other.minSelections == minSelections)&&(identical(other.maxSelections, maxSelections) || other.maxSelections == maxSelections)&&(identical(other.round, round) || other.round == round)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,description,cardType,const DeepCollectionEquality().hash(_options),allowCustom,inputPlaceholder,minSelections,maxSelections,round,maxRounds);

@override
String toString() {
  return 'ClarificationCardDto(question: $question, description: $description, cardType: $cardType, options: $options, allowCustom: $allowCustom, inputPlaceholder: $inputPlaceholder, minSelections: $minSelections, maxSelections: $maxSelections, round: $round, maxRounds: $maxRounds)';
}


}

/// @nodoc
abstract mixin class _$ClarificationCardDtoCopyWith<$Res> implements $ClarificationCardDtoCopyWith<$Res> {
  factory _$ClarificationCardDtoCopyWith(_ClarificationCardDto value, $Res Function(_ClarificationCardDto) _then) = __$ClarificationCardDtoCopyWithImpl;
@override @useResult
$Res call({
 String question, String? description,@JsonKey(name: "card_type") String? cardType, List<ClarificationOptionDto> options,@JsonKey(name: "allow_custom") bool allowCustom,@JsonKey(name: "input_placeholder") String? inputPlaceholder,@JsonKey(name: "min_selections") int? minSelections,@JsonKey(name: "max_selections") int? maxSelections, int? round,@JsonKey(name: "max_rounds") int? maxRounds
});




}
/// @nodoc
class __$ClarificationCardDtoCopyWithImpl<$Res>
    implements _$ClarificationCardDtoCopyWith<$Res> {
  __$ClarificationCardDtoCopyWithImpl(this._self, this._then);

  final _ClarificationCardDto _self;
  final $Res Function(_ClarificationCardDto) _then;

/// Create a copy of ClarificationCardDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? question = null,Object? description = freezed,Object? cardType = freezed,Object? options = null,Object? allowCustom = null,Object? inputPlaceholder = freezed,Object? minSelections = freezed,Object? maxSelections = freezed,Object? round = freezed,Object? maxRounds = freezed,}) {
  return _then(_ClarificationCardDto(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,cardType: freezed == cardType ? _self.cardType : cardType // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<ClarificationOptionDto>,allowCustom: null == allowCustom ? _self.allowCustom : allowCustom // ignore: cast_nullable_to_non_nullable
as bool,inputPlaceholder: freezed == inputPlaceholder ? _self.inputPlaceholder : inputPlaceholder // ignore: cast_nullable_to_non_nullable
as String?,minSelections: freezed == minSelections ? _self.minSelections : minSelections // ignore: cast_nullable_to_non_nullable
as int?,maxSelections: freezed == maxSelections ? _self.maxSelections : maxSelections // ignore: cast_nullable_to_non_nullable
as int?,round: freezed == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as int?,maxRounds: freezed == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ClarificationOptionDto {

 String get value; String get label; String? get description;
/// Create a copy of ClarificationOptionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClarificationOptionDtoCopyWith<ClarificationOptionDto> get copyWith => _$ClarificationOptionDtoCopyWithImpl<ClarificationOptionDto>(this as ClarificationOptionDto, _$identity);

  /// Serializes this ClarificationOptionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClarificationOptionDto&&(identical(other.value, value) || other.value == value)&&(identical(other.label, label) || other.label == label)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,label,description);

@override
String toString() {
  return 'ClarificationOptionDto(value: $value, label: $label, description: $description)';
}


}

/// @nodoc
abstract mixin class $ClarificationOptionDtoCopyWith<$Res>  {
  factory $ClarificationOptionDtoCopyWith(ClarificationOptionDto value, $Res Function(ClarificationOptionDto) _then) = _$ClarificationOptionDtoCopyWithImpl;
@useResult
$Res call({
 String value, String label, String? description
});




}
/// @nodoc
class _$ClarificationOptionDtoCopyWithImpl<$Res>
    implements $ClarificationOptionDtoCopyWith<$Res> {
  _$ClarificationOptionDtoCopyWithImpl(this._self, this._then);

  final ClarificationOptionDto _self;
  final $Res Function(ClarificationOptionDto) _then;

/// Create a copy of ClarificationOptionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? label = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClarificationOptionDto].
extension ClarificationOptionDtoPatterns on ClarificationOptionDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClarificationOptionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClarificationOptionDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClarificationOptionDto value)  $default,){
final _that = this;
switch (_that) {
case _ClarificationOptionDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClarificationOptionDto value)?  $default,){
final _that = this;
switch (_that) {
case _ClarificationOptionDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value,  String label,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClarificationOptionDto() when $default != null:
return $default(_that.value,_that.label,_that.description);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value,  String label,  String? description)  $default,) {final _that = this;
switch (_that) {
case _ClarificationOptionDto():
return $default(_that.value,_that.label,_that.description);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value,  String label,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _ClarificationOptionDto() when $default != null:
return $default(_that.value,_that.label,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClarificationOptionDto extends ClarificationOptionDto {
  const _ClarificationOptionDto({this.value = "", this.label = "", this.description}): super._();
  factory _ClarificationOptionDto.fromJson(Map<String, dynamic> json) => _$ClarificationOptionDtoFromJson(json);

@override@JsonKey() final  String value;
@override@JsonKey() final  String label;
@override final  String? description;

/// Create a copy of ClarificationOptionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClarificationOptionDtoCopyWith<_ClarificationOptionDto> get copyWith => __$ClarificationOptionDtoCopyWithImpl<_ClarificationOptionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClarificationOptionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClarificationOptionDto&&(identical(other.value, value) || other.value == value)&&(identical(other.label, label) || other.label == label)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,label,description);

@override
String toString() {
  return 'ClarificationOptionDto(value: $value, label: $label, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ClarificationOptionDtoCopyWith<$Res> implements $ClarificationOptionDtoCopyWith<$Res> {
  factory _$ClarificationOptionDtoCopyWith(_ClarificationOptionDto value, $Res Function(_ClarificationOptionDto) _then) = __$ClarificationOptionDtoCopyWithImpl;
@override @useResult
$Res call({
 String value, String label, String? description
});




}
/// @nodoc
class __$ClarificationOptionDtoCopyWithImpl<$Res>
    implements _$ClarificationOptionDtoCopyWith<$Res> {
  __$ClarificationOptionDtoCopyWithImpl(this._self, this._then);

  final _ClarificationOptionDto _self;
  final $Res Function(_ClarificationOptionDto) _then;

/// Create a copy of ClarificationOptionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? label = null,Object? description = freezed,}) {
  return _then(_ClarificationOptionDto(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
