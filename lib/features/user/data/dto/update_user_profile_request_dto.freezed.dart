// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_profile_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateUserProfileRequestDto {

 String get id; String? get nickname; String? get gender; String? get zodiac;/// 职业。领域实体里叫 `occupation`。
 String? get profession; String? get mbti;/// JSON 文本形式的字符串数组。
 String? get hobbies; String? get idealLife; String? get city; String? get industry; String? get company;/// JSON 文本形式的字符串数组。
 String? get personalityTags;/// 生日（`yyyy-MM-dd`）。
 String? get birthday;
/// Create a copy of UpdateUserProfileRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateUserProfileRequestDtoCopyWith<UpdateUserProfileRequestDto> get copyWith => _$UpdateUserProfileRequestDtoCopyWithImpl<UpdateUserProfileRequestDto>(this as UpdateUserProfileRequestDto, _$identity);

  /// Serializes this UpdateUserProfileRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateUserProfileRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.zodiac, zodiac) || other.zodiac == zodiac)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.mbti, mbti) || other.mbti == mbti)&&(identical(other.hobbies, hobbies) || other.hobbies == hobbies)&&(identical(other.idealLife, idealLife) || other.idealLife == idealLife)&&(identical(other.city, city) || other.city == city)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.company, company) || other.company == company)&&(identical(other.personalityTags, personalityTags) || other.personalityTags == personalityTags)&&(identical(other.birthday, birthday) || other.birthday == birthday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nickname,gender,zodiac,profession,mbti,hobbies,idealLife,city,industry,company,personalityTags,birthday);

@override
String toString() {
  return 'UpdateUserProfileRequestDto(id: $id, nickname: $nickname, gender: $gender, zodiac: $zodiac, profession: $profession, mbti: $mbti, hobbies: $hobbies, idealLife: $idealLife, city: $city, industry: $industry, company: $company, personalityTags: $personalityTags, birthday: $birthday)';
}


}

/// @nodoc
abstract mixin class $UpdateUserProfileRequestDtoCopyWith<$Res>  {
  factory $UpdateUserProfileRequestDtoCopyWith(UpdateUserProfileRequestDto value, $Res Function(UpdateUserProfileRequestDto) _then) = _$UpdateUserProfileRequestDtoCopyWithImpl;
@useResult
$Res call({
 String id, String? nickname, String? gender, String? zodiac, String? profession, String? mbti, String? hobbies, String? idealLife, String? city, String? industry, String? company, String? personalityTags, String? birthday
});




}
/// @nodoc
class _$UpdateUserProfileRequestDtoCopyWithImpl<$Res>
    implements $UpdateUserProfileRequestDtoCopyWith<$Res> {
  _$UpdateUserProfileRequestDtoCopyWithImpl(this._self, this._then);

  final UpdateUserProfileRequestDto _self;
  final $Res Function(UpdateUserProfileRequestDto) _then;

/// Create a copy of UpdateUserProfileRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nickname = freezed,Object? gender = freezed,Object? zodiac = freezed,Object? profession = freezed,Object? mbti = freezed,Object? hobbies = freezed,Object? idealLife = freezed,Object? city = freezed,Object? industry = freezed,Object? company = freezed,Object? personalityTags = freezed,Object? birthday = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,zodiac: freezed == zodiac ? _self.zodiac : zodiac // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,mbti: freezed == mbti ? _self.mbti : mbti // ignore: cast_nullable_to_non_nullable
as String?,hobbies: freezed == hobbies ? _self.hobbies : hobbies // ignore: cast_nullable_to_non_nullable
as String?,idealLife: freezed == idealLife ? _self.idealLife : idealLife // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,personalityTags: freezed == personalityTags ? _self.personalityTags : personalityTags // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateUserProfileRequestDto].
extension UpdateUserProfileRequestDtoPatterns on UpdateUserProfileRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateUserProfileRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateUserProfileRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateUserProfileRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _UpdateUserProfileRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateUserProfileRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateUserProfileRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? nickname,  String? gender,  String? zodiac,  String? profession,  String? mbti,  String? hobbies,  String? idealLife,  String? city,  String? industry,  String? company,  String? personalityTags,  String? birthday)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateUserProfileRequestDto() when $default != null:
return $default(_that.id,_that.nickname,_that.gender,_that.zodiac,_that.profession,_that.mbti,_that.hobbies,_that.idealLife,_that.city,_that.industry,_that.company,_that.personalityTags,_that.birthday);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? nickname,  String? gender,  String? zodiac,  String? profession,  String? mbti,  String? hobbies,  String? idealLife,  String? city,  String? industry,  String? company,  String? personalityTags,  String? birthday)  $default,) {final _that = this;
switch (_that) {
case _UpdateUserProfileRequestDto():
return $default(_that.id,_that.nickname,_that.gender,_that.zodiac,_that.profession,_that.mbti,_that.hobbies,_that.idealLife,_that.city,_that.industry,_that.company,_that.personalityTags,_that.birthday);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? nickname,  String? gender,  String? zodiac,  String? profession,  String? mbti,  String? hobbies,  String? idealLife,  String? city,  String? industry,  String? company,  String? personalityTags,  String? birthday)?  $default,) {final _that = this;
switch (_that) {
case _UpdateUserProfileRequestDto() when $default != null:
return $default(_that.id,_that.nickname,_that.gender,_that.zodiac,_that.profession,_that.mbti,_that.hobbies,_that.idealLife,_that.city,_that.industry,_that.company,_that.personalityTags,_that.birthday);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateUserProfileRequestDto extends UpdateUserProfileRequestDto {
  const _UpdateUserProfileRequestDto({required this.id, this.nickname, this.gender, this.zodiac, this.profession, this.mbti, this.hobbies, this.idealLife, this.city, this.industry, this.company, this.personalityTags, this.birthday}): super._();
  factory _UpdateUserProfileRequestDto.fromJson(Map<String, dynamic> json) => _$UpdateUserProfileRequestDtoFromJson(json);

@override final  String id;
@override final  String? nickname;
@override final  String? gender;
@override final  String? zodiac;
/// 职业。领域实体里叫 `occupation`。
@override final  String? profession;
@override final  String? mbti;
/// JSON 文本形式的字符串数组。
@override final  String? hobbies;
@override final  String? idealLife;
@override final  String? city;
@override final  String? industry;
@override final  String? company;
/// JSON 文本形式的字符串数组。
@override final  String? personalityTags;
/// 生日（`yyyy-MM-dd`）。
@override final  String? birthday;

/// Create a copy of UpdateUserProfileRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateUserProfileRequestDtoCopyWith<_UpdateUserProfileRequestDto> get copyWith => __$UpdateUserProfileRequestDtoCopyWithImpl<_UpdateUserProfileRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateUserProfileRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateUserProfileRequestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.zodiac, zodiac) || other.zodiac == zodiac)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.mbti, mbti) || other.mbti == mbti)&&(identical(other.hobbies, hobbies) || other.hobbies == hobbies)&&(identical(other.idealLife, idealLife) || other.idealLife == idealLife)&&(identical(other.city, city) || other.city == city)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.company, company) || other.company == company)&&(identical(other.personalityTags, personalityTags) || other.personalityTags == personalityTags)&&(identical(other.birthday, birthday) || other.birthday == birthday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nickname,gender,zodiac,profession,mbti,hobbies,idealLife,city,industry,company,personalityTags,birthday);

@override
String toString() {
  return 'UpdateUserProfileRequestDto(id: $id, nickname: $nickname, gender: $gender, zodiac: $zodiac, profession: $profession, mbti: $mbti, hobbies: $hobbies, idealLife: $idealLife, city: $city, industry: $industry, company: $company, personalityTags: $personalityTags, birthday: $birthday)';
}


}

/// @nodoc
abstract mixin class _$UpdateUserProfileRequestDtoCopyWith<$Res> implements $UpdateUserProfileRequestDtoCopyWith<$Res> {
  factory _$UpdateUserProfileRequestDtoCopyWith(_UpdateUserProfileRequestDto value, $Res Function(_UpdateUserProfileRequestDto) _then) = __$UpdateUserProfileRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String? nickname, String? gender, String? zodiac, String? profession, String? mbti, String? hobbies, String? idealLife, String? city, String? industry, String? company, String? personalityTags, String? birthday
});




}
/// @nodoc
class __$UpdateUserProfileRequestDtoCopyWithImpl<$Res>
    implements _$UpdateUserProfileRequestDtoCopyWith<$Res> {
  __$UpdateUserProfileRequestDtoCopyWithImpl(this._self, this._then);

  final _UpdateUserProfileRequestDto _self;
  final $Res Function(_UpdateUserProfileRequestDto) _then;

/// Create a copy of UpdateUserProfileRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nickname = freezed,Object? gender = freezed,Object? zodiac = freezed,Object? profession = freezed,Object? mbti = freezed,Object? hobbies = freezed,Object? idealLife = freezed,Object? city = freezed,Object? industry = freezed,Object? company = freezed,Object? personalityTags = freezed,Object? birthday = freezed,}) {
  return _then(_UpdateUserProfileRequestDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,zodiac: freezed == zodiac ? _self.zodiac : zodiac // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,mbti: freezed == mbti ? _self.mbti : mbti // ignore: cast_nullable_to_non_nullable
as String?,hobbies: freezed == hobbies ? _self.hobbies : hobbies // ignore: cast_nullable_to_non_nullable
as String?,idealLife: freezed == idealLife ? _self.idealLife : idealLife // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,personalityTags: freezed == personalityTags ? _self.personalityTags : personalityTags // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
