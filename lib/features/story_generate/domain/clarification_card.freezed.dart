// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clarification_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClarificationCard {

 String get question; String? get description;/// 卡片形态。决定选项是单选还是多选、是否只收文本。
 ClarificationCardType get type; List<ClarificationOption> get options;/// 允许在选项之外补一段自由文本。
 bool get allowCustom; String? get inputPlaceholder;/// 至少要选几项。契约缺省为 1。
 int get minSelections;/// 最多能选几项。为 null 表示不限。
 int? get maxSelections;/// 当前是第几轮澄清（从 1 起）。上游没给或给了不自洽的值时为 null。
 int? get round;/// 一共最多问几轮。与 [round] 同生同灭，见 [hasRoundProgress]。
 int? get maxRounds;
/// Create a copy of ClarificationCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClarificationCardCopyWith<ClarificationCard> get copyWith => _$ClarificationCardCopyWithImpl<ClarificationCard>(this as ClarificationCard, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClarificationCard&&(identical(other.question, question) || other.question == question)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.allowCustom, allowCustom) || other.allowCustom == allowCustom)&&(identical(other.inputPlaceholder, inputPlaceholder) || other.inputPlaceholder == inputPlaceholder)&&(identical(other.minSelections, minSelections) || other.minSelections == minSelections)&&(identical(other.maxSelections, maxSelections) || other.maxSelections == maxSelections)&&(identical(other.round, round) || other.round == round)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds));
}


@override
int get hashCode => Object.hash(runtimeType,question,description,type,const DeepCollectionEquality().hash(options),allowCustom,inputPlaceholder,minSelections,maxSelections,round,maxRounds);

@override
String toString() {
  return 'ClarificationCard(question: $question, description: $description, type: $type, options: $options, allowCustom: $allowCustom, inputPlaceholder: $inputPlaceholder, minSelections: $minSelections, maxSelections: $maxSelections, round: $round, maxRounds: $maxRounds)';
}


}

/// @nodoc
abstract mixin class $ClarificationCardCopyWith<$Res>  {
  factory $ClarificationCardCopyWith(ClarificationCard value, $Res Function(ClarificationCard) _then) = _$ClarificationCardCopyWithImpl;
@useResult
$Res call({
 String question, String? description, ClarificationCardType type, List<ClarificationOption> options, bool allowCustom, String? inputPlaceholder, int minSelections, int? maxSelections, int? round, int? maxRounds
});




}
/// @nodoc
class _$ClarificationCardCopyWithImpl<$Res>
    implements $ClarificationCardCopyWith<$Res> {
  _$ClarificationCardCopyWithImpl(this._self, this._then);

  final ClarificationCard _self;
  final $Res Function(ClarificationCard) _then;

/// Create a copy of ClarificationCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? question = null,Object? description = freezed,Object? type = null,Object? options = null,Object? allowCustom = null,Object? inputPlaceholder = freezed,Object? minSelections = null,Object? maxSelections = freezed,Object? round = freezed,Object? maxRounds = freezed,}) {
  return _then(_self.copyWith(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ClarificationCardType,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<ClarificationOption>,allowCustom: null == allowCustom ? _self.allowCustom : allowCustom // ignore: cast_nullable_to_non_nullable
as bool,inputPlaceholder: freezed == inputPlaceholder ? _self.inputPlaceholder : inputPlaceholder // ignore: cast_nullable_to_non_nullable
as String?,minSelections: null == minSelections ? _self.minSelections : minSelections // ignore: cast_nullable_to_non_nullable
as int,maxSelections: freezed == maxSelections ? _self.maxSelections : maxSelections // ignore: cast_nullable_to_non_nullable
as int?,round: freezed == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as int?,maxRounds: freezed == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClarificationCard].
extension ClarificationCardPatterns on ClarificationCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClarificationCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClarificationCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClarificationCard value)  $default,){
final _that = this;
switch (_that) {
case _ClarificationCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClarificationCard value)?  $default,){
final _that = this;
switch (_that) {
case _ClarificationCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String question,  String? description,  ClarificationCardType type,  List<ClarificationOption> options,  bool allowCustom,  String? inputPlaceholder,  int minSelections,  int? maxSelections,  int? round,  int? maxRounds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClarificationCard() when $default != null:
return $default(_that.question,_that.description,_that.type,_that.options,_that.allowCustom,_that.inputPlaceholder,_that.minSelections,_that.maxSelections,_that.round,_that.maxRounds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String question,  String? description,  ClarificationCardType type,  List<ClarificationOption> options,  bool allowCustom,  String? inputPlaceholder,  int minSelections,  int? maxSelections,  int? round,  int? maxRounds)  $default,) {final _that = this;
switch (_that) {
case _ClarificationCard():
return $default(_that.question,_that.description,_that.type,_that.options,_that.allowCustom,_that.inputPlaceholder,_that.minSelections,_that.maxSelections,_that.round,_that.maxRounds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String question,  String? description,  ClarificationCardType type,  List<ClarificationOption> options,  bool allowCustom,  String? inputPlaceholder,  int minSelections,  int? maxSelections,  int? round,  int? maxRounds)?  $default,) {final _that = this;
switch (_that) {
case _ClarificationCard() when $default != null:
return $default(_that.question,_that.description,_that.type,_that.options,_that.allowCustom,_that.inputPlaceholder,_that.minSelections,_that.maxSelections,_that.round,_that.maxRounds);case _:
  return null;

}
}

}

/// @nodoc


class _ClarificationCard extends ClarificationCard {
  const _ClarificationCard({required this.question, this.description, this.type = ClarificationCardType.singleSelect, final  List<ClarificationOption> options = const <ClarificationOption>[], this.allowCustom = false, this.inputPlaceholder, this.minSelections = 1, this.maxSelections, this.round, this.maxRounds}): _options = options,super._();
  

@override final  String question;
@override final  String? description;
/// 卡片形态。决定选项是单选还是多选、是否只收文本。
@override@JsonKey() final  ClarificationCardType type;
 final  List<ClarificationOption> _options;
@override@JsonKey() List<ClarificationOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

/// 允许在选项之外补一段自由文本。
@override@JsonKey() final  bool allowCustom;
@override final  String? inputPlaceholder;
/// 至少要选几项。契约缺省为 1。
@override@JsonKey() final  int minSelections;
/// 最多能选几项。为 null 表示不限。
@override final  int? maxSelections;
/// 当前是第几轮澄清（从 1 起）。上游没给或给了不自洽的值时为 null。
@override final  int? round;
/// 一共最多问几轮。与 [round] 同生同灭，见 [hasRoundProgress]。
@override final  int? maxRounds;

/// Create a copy of ClarificationCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClarificationCardCopyWith<_ClarificationCard> get copyWith => __$ClarificationCardCopyWithImpl<_ClarificationCard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClarificationCard&&(identical(other.question, question) || other.question == question)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.allowCustom, allowCustom) || other.allowCustom == allowCustom)&&(identical(other.inputPlaceholder, inputPlaceholder) || other.inputPlaceholder == inputPlaceholder)&&(identical(other.minSelections, minSelections) || other.minSelections == minSelections)&&(identical(other.maxSelections, maxSelections) || other.maxSelections == maxSelections)&&(identical(other.round, round) || other.round == round)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds));
}


@override
int get hashCode => Object.hash(runtimeType,question,description,type,const DeepCollectionEquality().hash(_options),allowCustom,inputPlaceholder,minSelections,maxSelections,round,maxRounds);

@override
String toString() {
  return 'ClarificationCard(question: $question, description: $description, type: $type, options: $options, allowCustom: $allowCustom, inputPlaceholder: $inputPlaceholder, minSelections: $minSelections, maxSelections: $maxSelections, round: $round, maxRounds: $maxRounds)';
}


}

/// @nodoc
abstract mixin class _$ClarificationCardCopyWith<$Res> implements $ClarificationCardCopyWith<$Res> {
  factory _$ClarificationCardCopyWith(_ClarificationCard value, $Res Function(_ClarificationCard) _then) = __$ClarificationCardCopyWithImpl;
@override @useResult
$Res call({
 String question, String? description, ClarificationCardType type, List<ClarificationOption> options, bool allowCustom, String? inputPlaceholder, int minSelections, int? maxSelections, int? round, int? maxRounds
});




}
/// @nodoc
class __$ClarificationCardCopyWithImpl<$Res>
    implements _$ClarificationCardCopyWith<$Res> {
  __$ClarificationCardCopyWithImpl(this._self, this._then);

  final _ClarificationCard _self;
  final $Res Function(_ClarificationCard) _then;

/// Create a copy of ClarificationCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? question = null,Object? description = freezed,Object? type = null,Object? options = null,Object? allowCustom = null,Object? inputPlaceholder = freezed,Object? minSelections = null,Object? maxSelections = freezed,Object? round = freezed,Object? maxRounds = freezed,}) {
  return _then(_ClarificationCard(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ClarificationCardType,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<ClarificationOption>,allowCustom: null == allowCustom ? _self.allowCustom : allowCustom // ignore: cast_nullable_to_non_nullable
as bool,inputPlaceholder: freezed == inputPlaceholder ? _self.inputPlaceholder : inputPlaceholder // ignore: cast_nullable_to_non_nullable
as String?,minSelections: null == minSelections ? _self.minSelections : minSelections // ignore: cast_nullable_to_non_nullable
as int,maxSelections: freezed == maxSelections ? _self.maxSelections : maxSelections // ignore: cast_nullable_to_non_nullable
as int?,round: freezed == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as int?,maxRounds: freezed == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$ClarificationOption {

/// 提交时用的值，也是选中状态的 key。
 String get value;/// 展示文案。
 String get label; String? get description;
/// Create a copy of ClarificationOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClarificationOptionCopyWith<ClarificationOption> get copyWith => _$ClarificationOptionCopyWithImpl<ClarificationOption>(this as ClarificationOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClarificationOption&&(identical(other.value, value) || other.value == value)&&(identical(other.label, label) || other.label == label)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,value,label,description);

@override
String toString() {
  return 'ClarificationOption(value: $value, label: $label, description: $description)';
}


}

/// @nodoc
abstract mixin class $ClarificationOptionCopyWith<$Res>  {
  factory $ClarificationOptionCopyWith(ClarificationOption value, $Res Function(ClarificationOption) _then) = _$ClarificationOptionCopyWithImpl;
@useResult
$Res call({
 String value, String label, String? description
});




}
/// @nodoc
class _$ClarificationOptionCopyWithImpl<$Res>
    implements $ClarificationOptionCopyWith<$Res> {
  _$ClarificationOptionCopyWithImpl(this._self, this._then);

  final ClarificationOption _self;
  final $Res Function(ClarificationOption) _then;

/// Create a copy of ClarificationOption
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


/// Adds pattern-matching-related methods to [ClarificationOption].
extension ClarificationOptionPatterns on ClarificationOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClarificationOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClarificationOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClarificationOption value)  $default,){
final _that = this;
switch (_that) {
case _ClarificationOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClarificationOption value)?  $default,){
final _that = this;
switch (_that) {
case _ClarificationOption() when $default != null:
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
case _ClarificationOption() when $default != null:
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
case _ClarificationOption():
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
case _ClarificationOption() when $default != null:
return $default(_that.value,_that.label,_that.description);case _:
  return null;

}
}

}

/// @nodoc


class _ClarificationOption implements ClarificationOption {
  const _ClarificationOption({required this.value, required this.label, this.description});
  

/// 提交时用的值，也是选中状态的 key。
@override final  String value;
/// 展示文案。
@override final  String label;
@override final  String? description;

/// Create a copy of ClarificationOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClarificationOptionCopyWith<_ClarificationOption> get copyWith => __$ClarificationOptionCopyWithImpl<_ClarificationOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClarificationOption&&(identical(other.value, value) || other.value == value)&&(identical(other.label, label) || other.label == label)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,value,label,description);

@override
String toString() {
  return 'ClarificationOption(value: $value, label: $label, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ClarificationOptionCopyWith<$Res> implements $ClarificationOptionCopyWith<$Res> {
  factory _$ClarificationOptionCopyWith(_ClarificationOption value, $Res Function(_ClarificationOption) _then) = __$ClarificationOptionCopyWithImpl;
@override @useResult
$Res call({
 String value, String label, String? description
});




}
/// @nodoc
class __$ClarificationOptionCopyWithImpl<$Res>
    implements _$ClarificationOptionCopyWith<$Res> {
  __$ClarificationOptionCopyWithImpl(this._self, this._then);

  final _ClarificationOption _self;
  final $Res Function(_ClarificationOption) _then;

/// Create a copy of ClarificationOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? label = null,Object? description = freezed,}) {
  return _then(_ClarificationOption(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
