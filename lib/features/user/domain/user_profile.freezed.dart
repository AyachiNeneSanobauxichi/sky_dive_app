// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserProfile {

 String get nickname;/// 档案 id（不是用户 id）。
///
/// `PUT /user-profile/update` **必传**它，所以实体必须带着走——只在 UI 层留一份
/// 展示数据，保存时就没有 id 可回传了。新建号且从未建档时为 null，
/// 此时保存要走 `create` 而不是 `update`。
 String? get id;/// 头像地址。为空时 UI 退化成"昵称首字 + 品牌渐变"的字母头像。
 String? get avatarUrl;/// 深度觉醒等级。
 int get awakeningLevel;/// 当前等级内的进度（0–1），用于等级卡的进度条。
 double get awakeningProgress;/// 星厉契合度（0–1）。
 double get starAffinity;// ── 个人档案 ──
 String? get gender; int? get age; DateTime? get birthday; String? get zodiac; String? get city; String? get occupation; String? get industry; String? get company; List<String> get hobbies;/// MBTI 人格类型（如 `ENFJ`）。
 String? get mbti;/// 用户自述的"理想生活"，可含换行。story 生成时最有信息量的一段素材。
 String? get idealLife;/// 性格标签（如 理性 / 乐观）。
 List<String> get personalityTags;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.id, id) || other.id == id)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.awakeningLevel, awakeningLevel) || other.awakeningLevel == awakeningLevel)&&(identical(other.awakeningProgress, awakeningProgress) || other.awakeningProgress == awakeningProgress)&&(identical(other.starAffinity, starAffinity) || other.starAffinity == starAffinity)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.age, age) || other.age == age)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.zodiac, zodiac) || other.zodiac == zodiac)&&(identical(other.city, city) || other.city == city)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.company, company) || other.company == company)&&const DeepCollectionEquality().equals(other.hobbies, hobbies)&&(identical(other.mbti, mbti) || other.mbti == mbti)&&(identical(other.idealLife, idealLife) || other.idealLife == idealLife)&&const DeepCollectionEquality().equals(other.personalityTags, personalityTags));
}


@override
int get hashCode => Object.hash(runtimeType,nickname,id,avatarUrl,awakeningLevel,awakeningProgress,starAffinity,gender,age,birthday,zodiac,city,occupation,industry,company,const DeepCollectionEquality().hash(hobbies),mbti,idealLife,const DeepCollectionEquality().hash(personalityTags));

@override
String toString() {
  return 'UserProfile(nickname: $nickname, id: $id, avatarUrl: $avatarUrl, awakeningLevel: $awakeningLevel, awakeningProgress: $awakeningProgress, starAffinity: $starAffinity, gender: $gender, age: $age, birthday: $birthday, zodiac: $zodiac, city: $city, occupation: $occupation, industry: $industry, company: $company, hobbies: $hobbies, mbti: $mbti, idealLife: $idealLife, personalityTags: $personalityTags)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String nickname, String? id, String? avatarUrl, int awakeningLevel, double awakeningProgress, double starAffinity, String? gender, int? age, DateTime? birthday, String? zodiac, String? city, String? occupation, String? industry, String? company, List<String> hobbies, String? mbti, String? idealLife, List<String> personalityTags
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nickname = null,Object? id = freezed,Object? avatarUrl = freezed,Object? awakeningLevel = null,Object? awakeningProgress = null,Object? starAffinity = null,Object? gender = freezed,Object? age = freezed,Object? birthday = freezed,Object? zodiac = freezed,Object? city = freezed,Object? occupation = freezed,Object? industry = freezed,Object? company = freezed,Object? hobbies = null,Object? mbti = freezed,Object? idealLife = freezed,Object? personalityTags = null,}) {
  return _then(_self.copyWith(
nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,awakeningLevel: null == awakeningLevel ? _self.awakeningLevel : awakeningLevel // ignore: cast_nullable_to_non_nullable
as int,awakeningProgress: null == awakeningProgress ? _self.awakeningProgress : awakeningProgress // ignore: cast_nullable_to_non_nullable
as double,starAffinity: null == starAffinity ? _self.starAffinity : starAffinity // ignore: cast_nullable_to_non_nullable
as double,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,zodiac: freezed == zodiac ? _self.zodiac : zodiac // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,hobbies: null == hobbies ? _self.hobbies : hobbies // ignore: cast_nullable_to_non_nullable
as List<String>,mbti: freezed == mbti ? _self.mbti : mbti // ignore: cast_nullable_to_non_nullable
as String?,idealLife: freezed == idealLife ? _self.idealLife : idealLife // ignore: cast_nullable_to_non_nullable
as String?,personalityTags: null == personalityTags ? _self.personalityTags : personalityTags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nickname,  String? id,  String? avatarUrl,  int awakeningLevel,  double awakeningProgress,  double starAffinity,  String? gender,  int? age,  DateTime? birthday,  String? zodiac,  String? city,  String? occupation,  String? industry,  String? company,  List<String> hobbies,  String? mbti,  String? idealLife,  List<String> personalityTags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.nickname,_that.id,_that.avatarUrl,_that.awakeningLevel,_that.awakeningProgress,_that.starAffinity,_that.gender,_that.age,_that.birthday,_that.zodiac,_that.city,_that.occupation,_that.industry,_that.company,_that.hobbies,_that.mbti,_that.idealLife,_that.personalityTags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nickname,  String? id,  String? avatarUrl,  int awakeningLevel,  double awakeningProgress,  double starAffinity,  String? gender,  int? age,  DateTime? birthday,  String? zodiac,  String? city,  String? occupation,  String? industry,  String? company,  List<String> hobbies,  String? mbti,  String? idealLife,  List<String> personalityTags)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.nickname,_that.id,_that.avatarUrl,_that.awakeningLevel,_that.awakeningProgress,_that.starAffinity,_that.gender,_that.age,_that.birthday,_that.zodiac,_that.city,_that.occupation,_that.industry,_that.company,_that.hobbies,_that.mbti,_that.idealLife,_that.personalityTags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nickname,  String? id,  String? avatarUrl,  int awakeningLevel,  double awakeningProgress,  double starAffinity,  String? gender,  int? age,  DateTime? birthday,  String? zodiac,  String? city,  String? occupation,  String? industry,  String? company,  List<String> hobbies,  String? mbti,  String? idealLife,  List<String> personalityTags)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.nickname,_that.id,_that.avatarUrl,_that.awakeningLevel,_that.awakeningProgress,_that.starAffinity,_that.gender,_that.age,_that.birthday,_that.zodiac,_that.city,_that.occupation,_that.industry,_that.company,_that.hobbies,_that.mbti,_that.idealLife,_that.personalityTags);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfile extends UserProfile {
  const _UserProfile({required this.nickname, this.id, this.avatarUrl, this.awakeningLevel = 1, this.awakeningProgress = 0, this.starAffinity = 0, this.gender, this.age, this.birthday, this.zodiac, this.city, this.occupation, this.industry, this.company, final  List<String> hobbies = const <String>[], this.mbti, this.idealLife, final  List<String> personalityTags = const <String>[]}): _hobbies = hobbies,_personalityTags = personalityTags,super._();
  

@override final  String nickname;
/// 档案 id（不是用户 id）。
///
/// `PUT /user-profile/update` **必传**它，所以实体必须带着走——只在 UI 层留一份
/// 展示数据，保存时就没有 id 可回传了。新建号且从未建档时为 null，
/// 此时保存要走 `create` 而不是 `update`。
@override final  String? id;
/// 头像地址。为空时 UI 退化成"昵称首字 + 品牌渐变"的字母头像。
@override final  String? avatarUrl;
/// 深度觉醒等级。
@override@JsonKey() final  int awakeningLevel;
/// 当前等级内的进度（0–1），用于等级卡的进度条。
@override@JsonKey() final  double awakeningProgress;
/// 星厉契合度（0–1）。
@override@JsonKey() final  double starAffinity;
// ── 个人档案 ──
@override final  String? gender;
@override final  int? age;
@override final  DateTime? birthday;
@override final  String? zodiac;
@override final  String? city;
@override final  String? occupation;
@override final  String? industry;
@override final  String? company;
 final  List<String> _hobbies;
@override@JsonKey() List<String> get hobbies {
  if (_hobbies is EqualUnmodifiableListView) return _hobbies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hobbies);
}

/// MBTI 人格类型（如 `ENFJ`）。
@override final  String? mbti;
/// 用户自述的"理想生活"，可含换行。story 生成时最有信息量的一段素材。
@override final  String? idealLife;
/// 性格标签（如 理性 / 乐观）。
 final  List<String> _personalityTags;
/// 性格标签（如 理性 / 乐观）。
@override@JsonKey() List<String> get personalityTags {
  if (_personalityTags is EqualUnmodifiableListView) return _personalityTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_personalityTags);
}


/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.id, id) || other.id == id)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.awakeningLevel, awakeningLevel) || other.awakeningLevel == awakeningLevel)&&(identical(other.awakeningProgress, awakeningProgress) || other.awakeningProgress == awakeningProgress)&&(identical(other.starAffinity, starAffinity) || other.starAffinity == starAffinity)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.age, age) || other.age == age)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.zodiac, zodiac) || other.zodiac == zodiac)&&(identical(other.city, city) || other.city == city)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.company, company) || other.company == company)&&const DeepCollectionEquality().equals(other._hobbies, _hobbies)&&(identical(other.mbti, mbti) || other.mbti == mbti)&&(identical(other.idealLife, idealLife) || other.idealLife == idealLife)&&const DeepCollectionEquality().equals(other._personalityTags, _personalityTags));
}


@override
int get hashCode => Object.hash(runtimeType,nickname,id,avatarUrl,awakeningLevel,awakeningProgress,starAffinity,gender,age,birthday,zodiac,city,occupation,industry,company,const DeepCollectionEquality().hash(_hobbies),mbti,idealLife,const DeepCollectionEquality().hash(_personalityTags));

@override
String toString() {
  return 'UserProfile(nickname: $nickname, id: $id, avatarUrl: $avatarUrl, awakeningLevel: $awakeningLevel, awakeningProgress: $awakeningProgress, starAffinity: $starAffinity, gender: $gender, age: $age, birthday: $birthday, zodiac: $zodiac, city: $city, occupation: $occupation, industry: $industry, company: $company, hobbies: $hobbies, mbti: $mbti, idealLife: $idealLife, personalityTags: $personalityTags)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String nickname, String? id, String? avatarUrl, int awakeningLevel, double awakeningProgress, double starAffinity, String? gender, int? age, DateTime? birthday, String? zodiac, String? city, String? occupation, String? industry, String? company, List<String> hobbies, String? mbti, String? idealLife, List<String> personalityTags
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nickname = null,Object? id = freezed,Object? avatarUrl = freezed,Object? awakeningLevel = null,Object? awakeningProgress = null,Object? starAffinity = null,Object? gender = freezed,Object? age = freezed,Object? birthday = freezed,Object? zodiac = freezed,Object? city = freezed,Object? occupation = freezed,Object? industry = freezed,Object? company = freezed,Object? hobbies = null,Object? mbti = freezed,Object? idealLife = freezed,Object? personalityTags = null,}) {
  return _then(_UserProfile(
nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,awakeningLevel: null == awakeningLevel ? _self.awakeningLevel : awakeningLevel // ignore: cast_nullable_to_non_nullable
as int,awakeningProgress: null == awakeningProgress ? _self.awakeningProgress : awakeningProgress // ignore: cast_nullable_to_non_nullable
as double,starAffinity: null == starAffinity ? _self.starAffinity : starAffinity // ignore: cast_nullable_to_non_nullable
as double,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,zodiac: freezed == zodiac ? _self.zodiac : zodiac // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,industry: freezed == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,hobbies: null == hobbies ? _self._hobbies : hobbies // ignore: cast_nullable_to_non_nullable
as List<String>,mbti: freezed == mbti ? _self.mbti : mbti // ignore: cast_nullable_to_non_nullable
as String?,idealLife: freezed == idealLife ? _self.idealLife : idealLife // ignore: cast_nullable_to_non_nullable
as String?,personalityTags: null == personalityTags ? _self._personalityTags : personalityTags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
