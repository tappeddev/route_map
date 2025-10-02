// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_map_user_location_indicator.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RouteMapUserLocationIndicator {

 LatLng get location; double get accuracyWidth; RouteMapUserLocationIndicatorTheme get theme; RouteMapUserLocationIndicatorTheme? get darkTheme;
/// Create a copy of RouteMapUserLocationIndicator
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteMapUserLocationIndicatorCopyWith<RouteMapUserLocationIndicator> get copyWith => _$RouteMapUserLocationIndicatorCopyWithImpl<RouteMapUserLocationIndicator>(this as RouteMapUserLocationIndicator, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteMapUserLocationIndicator&&(identical(other.location, location) || other.location == location)&&(identical(other.accuracyWidth, accuracyWidth) || other.accuracyWidth == accuracyWidth)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.darkTheme, darkTheme) || other.darkTheme == darkTheme));
}


@override
int get hashCode => Object.hash(runtimeType,location,accuracyWidth,theme,darkTheme);

@override
String toString() {
  return 'RouteMapUserLocationIndicator(location: $location, accuracyWidth: $accuracyWidth, theme: $theme, darkTheme: $darkTheme)';
}


}

/// @nodoc
abstract mixin class $RouteMapUserLocationIndicatorCopyWith<$Res>  {
  factory $RouteMapUserLocationIndicatorCopyWith(RouteMapUserLocationIndicator value, $Res Function(RouteMapUserLocationIndicator) _then) = _$RouteMapUserLocationIndicatorCopyWithImpl;
@useResult
$Res call({
 LatLng location, double accuracyWidth, RouteMapUserLocationIndicatorTheme theme, RouteMapUserLocationIndicatorTheme? darkTheme
});


$RouteMapUserLocationIndicatorThemeCopyWith<$Res> get theme;$RouteMapUserLocationIndicatorThemeCopyWith<$Res>? get darkTheme;

}
/// @nodoc
class _$RouteMapUserLocationIndicatorCopyWithImpl<$Res>
    implements $RouteMapUserLocationIndicatorCopyWith<$Res> {
  _$RouteMapUserLocationIndicatorCopyWithImpl(this._self, this._then);

  final RouteMapUserLocationIndicator _self;
  final $Res Function(RouteMapUserLocationIndicator) _then;

/// Create a copy of RouteMapUserLocationIndicator
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? location = null,Object? accuracyWidth = null,Object? theme = null,Object? darkTheme = freezed,}) {
  return _then(_self.copyWith(
location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LatLng,accuracyWidth: null == accuracyWidth ? _self.accuracyWidth : accuracyWidth // ignore: cast_nullable_to_non_nullable
as double,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as RouteMapUserLocationIndicatorTheme,darkTheme: freezed == darkTheme ? _self.darkTheme : darkTheme // ignore: cast_nullable_to_non_nullable
as RouteMapUserLocationIndicatorTheme?,
  ));
}
/// Create a copy of RouteMapUserLocationIndicator
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapUserLocationIndicatorThemeCopyWith<$Res> get theme {
  
  return $RouteMapUserLocationIndicatorThemeCopyWith<$Res>(_self.theme, (value) {
    return _then(_self.copyWith(theme: value));
  });
}/// Create a copy of RouteMapUserLocationIndicator
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapUserLocationIndicatorThemeCopyWith<$Res>? get darkTheme {
    if (_self.darkTheme == null) {
    return null;
  }

  return $RouteMapUserLocationIndicatorThemeCopyWith<$Res>(_self.darkTheme!, (value) {
    return _then(_self.copyWith(darkTheme: value));
  });
}
}


/// Adds pattern-matching-related methods to [RouteMapUserLocationIndicator].
extension RouteMapUserLocationIndicatorPatterns on RouteMapUserLocationIndicator {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteMapUserLocationIndicator value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteMapUserLocationIndicator() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteMapUserLocationIndicator value)  $default,){
final _that = this;
switch (_that) {
case _RouteMapUserLocationIndicator():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteMapUserLocationIndicator value)?  $default,){
final _that = this;
switch (_that) {
case _RouteMapUserLocationIndicator() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LatLng location,  double accuracyWidth,  RouteMapUserLocationIndicatorTheme theme,  RouteMapUserLocationIndicatorTheme? darkTheme)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteMapUserLocationIndicator() when $default != null:
return $default(_that.location,_that.accuracyWidth,_that.theme,_that.darkTheme);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LatLng location,  double accuracyWidth,  RouteMapUserLocationIndicatorTheme theme,  RouteMapUserLocationIndicatorTheme? darkTheme)  $default,) {final _that = this;
switch (_that) {
case _RouteMapUserLocationIndicator():
return $default(_that.location,_that.accuracyWidth,_that.theme,_that.darkTheme);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LatLng location,  double accuracyWidth,  RouteMapUserLocationIndicatorTheme theme,  RouteMapUserLocationIndicatorTheme? darkTheme)?  $default,) {final _that = this;
switch (_that) {
case _RouteMapUserLocationIndicator() when $default != null:
return $default(_that.location,_that.accuracyWidth,_that.theme,_that.darkTheme);case _:
  return null;

}
}

}

/// @nodoc


class _RouteMapUserLocationIndicator implements RouteMapUserLocationIndicator {
  const _RouteMapUserLocationIndicator({required this.location, required this.accuracyWidth, required this.theme, this.darkTheme});
  

@override final  LatLng location;
@override final  double accuracyWidth;
@override final  RouteMapUserLocationIndicatorTheme theme;
@override final  RouteMapUserLocationIndicatorTheme? darkTheme;

/// Create a copy of RouteMapUserLocationIndicator
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteMapUserLocationIndicatorCopyWith<_RouteMapUserLocationIndicator> get copyWith => __$RouteMapUserLocationIndicatorCopyWithImpl<_RouteMapUserLocationIndicator>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteMapUserLocationIndicator&&(identical(other.location, location) || other.location == location)&&(identical(other.accuracyWidth, accuracyWidth) || other.accuracyWidth == accuracyWidth)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.darkTheme, darkTheme) || other.darkTheme == darkTheme));
}


@override
int get hashCode => Object.hash(runtimeType,location,accuracyWidth,theme,darkTheme);

@override
String toString() {
  return 'RouteMapUserLocationIndicator(location: $location, accuracyWidth: $accuracyWidth, theme: $theme, darkTheme: $darkTheme)';
}


}

/// @nodoc
abstract mixin class _$RouteMapUserLocationIndicatorCopyWith<$Res> implements $RouteMapUserLocationIndicatorCopyWith<$Res> {
  factory _$RouteMapUserLocationIndicatorCopyWith(_RouteMapUserLocationIndicator value, $Res Function(_RouteMapUserLocationIndicator) _then) = __$RouteMapUserLocationIndicatorCopyWithImpl;
@override @useResult
$Res call({
 LatLng location, double accuracyWidth, RouteMapUserLocationIndicatorTheme theme, RouteMapUserLocationIndicatorTheme? darkTheme
});


@override $RouteMapUserLocationIndicatorThemeCopyWith<$Res> get theme;@override $RouteMapUserLocationIndicatorThemeCopyWith<$Res>? get darkTheme;

}
/// @nodoc
class __$RouteMapUserLocationIndicatorCopyWithImpl<$Res>
    implements _$RouteMapUserLocationIndicatorCopyWith<$Res> {
  __$RouteMapUserLocationIndicatorCopyWithImpl(this._self, this._then);

  final _RouteMapUserLocationIndicator _self;
  final $Res Function(_RouteMapUserLocationIndicator) _then;

/// Create a copy of RouteMapUserLocationIndicator
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? location = null,Object? accuracyWidth = null,Object? theme = null,Object? darkTheme = freezed,}) {
  return _then(_RouteMapUserLocationIndicator(
location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as LatLng,accuracyWidth: null == accuracyWidth ? _self.accuracyWidth : accuracyWidth // ignore: cast_nullable_to_non_nullable
as double,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as RouteMapUserLocationIndicatorTheme,darkTheme: freezed == darkTheme ? _self.darkTheme : darkTheme // ignore: cast_nullable_to_non_nullable
as RouteMapUserLocationIndicatorTheme?,
  ));
}

/// Create a copy of RouteMapUserLocationIndicator
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapUserLocationIndicatorThemeCopyWith<$Res> get theme {
  
  return $RouteMapUserLocationIndicatorThemeCopyWith<$Res>(_self.theme, (value) {
    return _then(_self.copyWith(theme: value));
  });
}/// Create a copy of RouteMapUserLocationIndicator
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapUserLocationIndicatorThemeCopyWith<$Res>? get darkTheme {
    if (_self.darkTheme == null) {
    return null;
  }

  return $RouteMapUserLocationIndicatorThemeCopyWith<$Res>(_self.darkTheme!, (value) {
    return _then(_self.copyWith(darkTheme: value));
  });
}
}

/// @nodoc
mixin _$RouteMapUserLocationIndicatorTheme {

 Color get color;
/// Create a copy of RouteMapUserLocationIndicatorTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteMapUserLocationIndicatorThemeCopyWith<RouteMapUserLocationIndicatorTheme> get copyWith => _$RouteMapUserLocationIndicatorThemeCopyWithImpl<RouteMapUserLocationIndicatorTheme>(this as RouteMapUserLocationIndicatorTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteMapUserLocationIndicatorTheme&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,color);

@override
String toString() {
  return 'RouteMapUserLocationIndicatorTheme(color: $color)';
}


}

/// @nodoc
abstract mixin class $RouteMapUserLocationIndicatorThemeCopyWith<$Res>  {
  factory $RouteMapUserLocationIndicatorThemeCopyWith(RouteMapUserLocationIndicatorTheme value, $Res Function(RouteMapUserLocationIndicatorTheme) _then) = _$RouteMapUserLocationIndicatorThemeCopyWithImpl;
@useResult
$Res call({
 Color color
});




}
/// @nodoc
class _$RouteMapUserLocationIndicatorThemeCopyWithImpl<$Res>
    implements $RouteMapUserLocationIndicatorThemeCopyWith<$Res> {
  _$RouteMapUserLocationIndicatorThemeCopyWithImpl(this._self, this._then);

  final RouteMapUserLocationIndicatorTheme _self;
  final $Res Function(RouteMapUserLocationIndicatorTheme) _then;

/// Create a copy of RouteMapUserLocationIndicatorTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? color = null,}) {
  return _then(_self.copyWith(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteMapUserLocationIndicatorTheme].
extension RouteMapUserLocationIndicatorThemePatterns on RouteMapUserLocationIndicatorTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteMapUserLocationIndicatorTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteMapUserLocationIndicatorTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteMapUserLocationIndicatorTheme value)  $default,){
final _that = this;
switch (_that) {
case _RouteMapUserLocationIndicatorTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteMapUserLocationIndicatorTheme value)?  $default,){
final _that = this;
switch (_that) {
case _RouteMapUserLocationIndicatorTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Color color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteMapUserLocationIndicatorTheme() when $default != null:
return $default(_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Color color)  $default,) {final _that = this;
switch (_that) {
case _RouteMapUserLocationIndicatorTheme():
return $default(_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Color color)?  $default,) {final _that = this;
switch (_that) {
case _RouteMapUserLocationIndicatorTheme() when $default != null:
return $default(_that.color);case _:
  return null;

}
}

}

/// @nodoc


class _RouteMapUserLocationIndicatorTheme implements RouteMapUserLocationIndicatorTheme {
  const _RouteMapUserLocationIndicatorTheme({required this.color});
  

@override final  Color color;

/// Create a copy of RouteMapUserLocationIndicatorTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteMapUserLocationIndicatorThemeCopyWith<_RouteMapUserLocationIndicatorTheme> get copyWith => __$RouteMapUserLocationIndicatorThemeCopyWithImpl<_RouteMapUserLocationIndicatorTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteMapUserLocationIndicatorTheme&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,color);

@override
String toString() {
  return 'RouteMapUserLocationIndicatorTheme(color: $color)';
}


}

/// @nodoc
abstract mixin class _$RouteMapUserLocationIndicatorThemeCopyWith<$Res> implements $RouteMapUserLocationIndicatorThemeCopyWith<$Res> {
  factory _$RouteMapUserLocationIndicatorThemeCopyWith(_RouteMapUserLocationIndicatorTheme value, $Res Function(_RouteMapUserLocationIndicatorTheme) _then) = __$RouteMapUserLocationIndicatorThemeCopyWithImpl;
@override @useResult
$Res call({
 Color color
});




}
/// @nodoc
class __$RouteMapUserLocationIndicatorThemeCopyWithImpl<$Res>
    implements _$RouteMapUserLocationIndicatorThemeCopyWith<$Res> {
  __$RouteMapUserLocationIndicatorThemeCopyWithImpl(this._self, this._then);

  final _RouteMapUserLocationIndicatorTheme _self;
  final $Res Function(_RouteMapUserLocationIndicatorTheme) _then;

/// Create a copy of RouteMapUserLocationIndicatorTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? color = null,}) {
  return _then(_RouteMapUserLocationIndicatorTheme(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}


}

// dart format on
