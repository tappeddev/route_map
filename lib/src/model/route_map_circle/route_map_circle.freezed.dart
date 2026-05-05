// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_map_circle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RouteMapCircle {

 String get identifier; LatLng get latLng; RouteMapCircleTheme get theme; RouteMapCircleTheme? get darkTheme;
/// Create a copy of RouteMapCircle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteMapCircleCopyWith<RouteMapCircle> get copyWith => _$RouteMapCircleCopyWithImpl<RouteMapCircle>(this as RouteMapCircle, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteMapCircle&&(identical(other.identifier, identifier) || other.identifier == identifier)&&(identical(other.latLng, latLng) || other.latLng == latLng)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.darkTheme, darkTheme) || other.darkTheme == darkTheme));
}


@override
int get hashCode => Object.hash(runtimeType,identifier,latLng,theme,darkTheme);

@override
String toString() {
  return 'RouteMapCircle(identifier: $identifier, latLng: $latLng, theme: $theme, darkTheme: $darkTheme)';
}


}

/// @nodoc
abstract mixin class $RouteMapCircleCopyWith<$Res>  {
  factory $RouteMapCircleCopyWith(RouteMapCircle value, $Res Function(RouteMapCircle) _then) = _$RouteMapCircleCopyWithImpl;
@useResult
$Res call({
 String identifier, LatLng latLng, RouteMapCircleTheme theme, RouteMapCircleTheme? darkTheme
});


$RouteMapCircleThemeCopyWith<$Res> get theme;$RouteMapCircleThemeCopyWith<$Res>? get darkTheme;

}
/// @nodoc
class _$RouteMapCircleCopyWithImpl<$Res>
    implements $RouteMapCircleCopyWith<$Res> {
  _$RouteMapCircleCopyWithImpl(this._self, this._then);

  final RouteMapCircle _self;
  final $Res Function(RouteMapCircle) _then;

/// Create a copy of RouteMapCircle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? identifier = null,Object? latLng = null,Object? theme = null,Object? darkTheme = freezed,}) {
  return _then(_self.copyWith(
identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,latLng: null == latLng ? _self.latLng : latLng // ignore: cast_nullable_to_non_nullable
as LatLng,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as RouteMapCircleTheme,darkTheme: freezed == darkTheme ? _self.darkTheme : darkTheme // ignore: cast_nullable_to_non_nullable
as RouteMapCircleTheme?,
  ));
}
/// Create a copy of RouteMapCircle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapCircleThemeCopyWith<$Res> get theme {
  
  return $RouteMapCircleThemeCopyWith<$Res>(_self.theme, (value) {
    return _then(_self.copyWith(theme: value));
  });
}/// Create a copy of RouteMapCircle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapCircleThemeCopyWith<$Res>? get darkTheme {
    if (_self.darkTheme == null) {
    return null;
  }

  return $RouteMapCircleThemeCopyWith<$Res>(_self.darkTheme!, (value) {
    return _then(_self.copyWith(darkTheme: value));
  });
}
}


/// Adds pattern-matching-related methods to [RouteMapCircle].
extension RouteMapCirclePatterns on RouteMapCircle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteMapCircle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteMapCircle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteMapCircle value)  $default,){
final _that = this;
switch (_that) {
case _RouteMapCircle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteMapCircle value)?  $default,){
final _that = this;
switch (_that) {
case _RouteMapCircle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String identifier,  LatLng latLng,  RouteMapCircleTheme theme,  RouteMapCircleTheme? darkTheme)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteMapCircle() when $default != null:
return $default(_that.identifier,_that.latLng,_that.theme,_that.darkTheme);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String identifier,  LatLng latLng,  RouteMapCircleTheme theme,  RouteMapCircleTheme? darkTheme)  $default,) {final _that = this;
switch (_that) {
case _RouteMapCircle():
return $default(_that.identifier,_that.latLng,_that.theme,_that.darkTheme);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String identifier,  LatLng latLng,  RouteMapCircleTheme theme,  RouteMapCircleTheme? darkTheme)?  $default,) {final _that = this;
switch (_that) {
case _RouteMapCircle() when $default != null:
return $default(_that.identifier,_that.latLng,_that.theme,_that.darkTheme);case _:
  return null;

}
}

}

/// @nodoc


class _RouteMapCircle implements RouteMapCircle {
  const _RouteMapCircle({required this.identifier, required this.latLng, required this.theme, this.darkTheme});
  

@override final  String identifier;
@override final  LatLng latLng;
@override final  RouteMapCircleTheme theme;
@override final  RouteMapCircleTheme? darkTheme;

/// Create a copy of RouteMapCircle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteMapCircleCopyWith<_RouteMapCircle> get copyWith => __$RouteMapCircleCopyWithImpl<_RouteMapCircle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteMapCircle&&(identical(other.identifier, identifier) || other.identifier == identifier)&&(identical(other.latLng, latLng) || other.latLng == latLng)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.darkTheme, darkTheme) || other.darkTheme == darkTheme));
}


@override
int get hashCode => Object.hash(runtimeType,identifier,latLng,theme,darkTheme);

@override
String toString() {
  return 'RouteMapCircle(identifier: $identifier, latLng: $latLng, theme: $theme, darkTheme: $darkTheme)';
}


}

/// @nodoc
abstract mixin class _$RouteMapCircleCopyWith<$Res> implements $RouteMapCircleCopyWith<$Res> {
  factory _$RouteMapCircleCopyWith(_RouteMapCircle value, $Res Function(_RouteMapCircle) _then) = __$RouteMapCircleCopyWithImpl;
@override @useResult
$Res call({
 String identifier, LatLng latLng, RouteMapCircleTheme theme, RouteMapCircleTheme? darkTheme
});


@override $RouteMapCircleThemeCopyWith<$Res> get theme;@override $RouteMapCircleThemeCopyWith<$Res>? get darkTheme;

}
/// @nodoc
class __$RouteMapCircleCopyWithImpl<$Res>
    implements _$RouteMapCircleCopyWith<$Res> {
  __$RouteMapCircleCopyWithImpl(this._self, this._then);

  final _RouteMapCircle _self;
  final $Res Function(_RouteMapCircle) _then;

/// Create a copy of RouteMapCircle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? identifier = null,Object? latLng = null,Object? theme = null,Object? darkTheme = freezed,}) {
  return _then(_RouteMapCircle(
identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,latLng: null == latLng ? _self.latLng : latLng // ignore: cast_nullable_to_non_nullable
as LatLng,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as RouteMapCircleTheme,darkTheme: freezed == darkTheme ? _self.darkTheme : darkTheme // ignore: cast_nullable_to_non_nullable
as RouteMapCircleTheme?,
  ));
}

/// Create a copy of RouteMapCircle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapCircleThemeCopyWith<$Res> get theme {
  
  return $RouteMapCircleThemeCopyWith<$Res>(_self.theme, (value) {
    return _then(_self.copyWith(theme: value));
  });
}/// Create a copy of RouteMapCircle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapCircleThemeCopyWith<$Res>? get darkTheme {
    if (_self.darkTheme == null) {
    return null;
  }

  return $RouteMapCircleThemeCopyWith<$Res>(_self.darkTheme!, (value) {
    return _then(_self.copyWith(darkTheme: value));
  });
}
}

/// @nodoc
mixin _$RouteMapCircleTheme {

 double get radius; Color get color; double? get opacity; double? get blur; double? get strokeWidth; Color? get strokeColor; double? get strokeOpacity; bool get draggable;
/// Create a copy of RouteMapCircleTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteMapCircleThemeCopyWith<RouteMapCircleTheme> get copyWith => _$RouteMapCircleThemeCopyWithImpl<RouteMapCircleTheme>(this as RouteMapCircleTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteMapCircleTheme&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.color, color) || other.color == color)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.blur, blur) || other.blur == blur)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.strokeColor, strokeColor) || other.strokeColor == strokeColor)&&(identical(other.strokeOpacity, strokeOpacity) || other.strokeOpacity == strokeOpacity)&&(identical(other.draggable, draggable) || other.draggable == draggable));
}


@override
int get hashCode => Object.hash(runtimeType,radius,color,opacity,blur,strokeWidth,strokeColor,strokeOpacity,draggable);

@override
String toString() {
  return 'RouteMapCircleTheme(radius: $radius, color: $color, opacity: $opacity, blur: $blur, strokeWidth: $strokeWidth, strokeColor: $strokeColor, strokeOpacity: $strokeOpacity, draggable: $draggable)';
}


}

/// @nodoc
abstract mixin class $RouteMapCircleThemeCopyWith<$Res>  {
  factory $RouteMapCircleThemeCopyWith(RouteMapCircleTheme value, $Res Function(RouteMapCircleTheme) _then) = _$RouteMapCircleThemeCopyWithImpl;
@useResult
$Res call({
 double radius, Color color, double? opacity, double? blur, double? strokeWidth, Color? strokeColor, double? strokeOpacity, bool draggable
});




}
/// @nodoc
class _$RouteMapCircleThemeCopyWithImpl<$Res>
    implements $RouteMapCircleThemeCopyWith<$Res> {
  _$RouteMapCircleThemeCopyWithImpl(this._self, this._then);

  final RouteMapCircleTheme _self;
  final $Res Function(RouteMapCircleTheme) _then;

/// Create a copy of RouteMapCircleTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? radius = null,Object? color = null,Object? opacity = freezed,Object? blur = freezed,Object? strokeWidth = freezed,Object? strokeColor = freezed,Object? strokeOpacity = freezed,Object? draggable = null,}) {
  return _then(_self.copyWith(
radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color,opacity: freezed == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double?,blur: freezed == blur ? _self.blur : blur // ignore: cast_nullable_to_non_nullable
as double?,strokeWidth: freezed == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double?,strokeColor: freezed == strokeColor ? _self.strokeColor : strokeColor // ignore: cast_nullable_to_non_nullable
as Color?,strokeOpacity: freezed == strokeOpacity ? _self.strokeOpacity : strokeOpacity // ignore: cast_nullable_to_non_nullable
as double?,draggable: null == draggable ? _self.draggable : draggable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteMapCircleTheme].
extension RouteMapCircleThemePatterns on RouteMapCircleTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteMapCircleTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteMapCircleTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteMapCircleTheme value)  $default,){
final _that = this;
switch (_that) {
case _RouteMapCircleTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteMapCircleTheme value)?  $default,){
final _that = this;
switch (_that) {
case _RouteMapCircleTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double radius,  Color color,  double? opacity,  double? blur,  double? strokeWidth,  Color? strokeColor,  double? strokeOpacity,  bool draggable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteMapCircleTheme() when $default != null:
return $default(_that.radius,_that.color,_that.opacity,_that.blur,_that.strokeWidth,_that.strokeColor,_that.strokeOpacity,_that.draggable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double radius,  Color color,  double? opacity,  double? blur,  double? strokeWidth,  Color? strokeColor,  double? strokeOpacity,  bool draggable)  $default,) {final _that = this;
switch (_that) {
case _RouteMapCircleTheme():
return $default(_that.radius,_that.color,_that.opacity,_that.blur,_that.strokeWidth,_that.strokeColor,_that.strokeOpacity,_that.draggable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double radius,  Color color,  double? opacity,  double? blur,  double? strokeWidth,  Color? strokeColor,  double? strokeOpacity,  bool draggable)?  $default,) {final _that = this;
switch (_that) {
case _RouteMapCircleTheme() when $default != null:
return $default(_that.radius,_that.color,_that.opacity,_that.blur,_that.strokeWidth,_that.strokeColor,_that.strokeOpacity,_that.draggable);case _:
  return null;

}
}

}

/// @nodoc


class _RouteMapCircleTheme implements RouteMapCircleTheme {
  const _RouteMapCircleTheme({required this.radius, required this.color, this.opacity, this.blur, this.strokeWidth, this.strokeColor, this.strokeOpacity, this.draggable = false});
  

@override final  double radius;
@override final  Color color;
@override final  double? opacity;
@override final  double? blur;
@override final  double? strokeWidth;
@override final  Color? strokeColor;
@override final  double? strokeOpacity;
@override@JsonKey() final  bool draggable;

/// Create a copy of RouteMapCircleTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteMapCircleThemeCopyWith<_RouteMapCircleTheme> get copyWith => __$RouteMapCircleThemeCopyWithImpl<_RouteMapCircleTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteMapCircleTheme&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.color, color) || other.color == color)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.blur, blur) || other.blur == blur)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.strokeColor, strokeColor) || other.strokeColor == strokeColor)&&(identical(other.strokeOpacity, strokeOpacity) || other.strokeOpacity == strokeOpacity)&&(identical(other.draggable, draggable) || other.draggable == draggable));
}


@override
int get hashCode => Object.hash(runtimeType,radius,color,opacity,blur,strokeWidth,strokeColor,strokeOpacity,draggable);

@override
String toString() {
  return 'RouteMapCircleTheme(radius: $radius, color: $color, opacity: $opacity, blur: $blur, strokeWidth: $strokeWidth, strokeColor: $strokeColor, strokeOpacity: $strokeOpacity, draggable: $draggable)';
}


}

/// @nodoc
abstract mixin class _$RouteMapCircleThemeCopyWith<$Res> implements $RouteMapCircleThemeCopyWith<$Res> {
  factory _$RouteMapCircleThemeCopyWith(_RouteMapCircleTheme value, $Res Function(_RouteMapCircleTheme) _then) = __$RouteMapCircleThemeCopyWithImpl;
@override @useResult
$Res call({
 double radius, Color color, double? opacity, double? blur, double? strokeWidth, Color? strokeColor, double? strokeOpacity, bool draggable
});




}
/// @nodoc
class __$RouteMapCircleThemeCopyWithImpl<$Res>
    implements _$RouteMapCircleThemeCopyWith<$Res> {
  __$RouteMapCircleThemeCopyWithImpl(this._self, this._then);

  final _RouteMapCircleTheme _self;
  final $Res Function(_RouteMapCircleTheme) _then;

/// Create a copy of RouteMapCircleTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? radius = null,Object? color = null,Object? opacity = freezed,Object? blur = freezed,Object? strokeWidth = freezed,Object? strokeColor = freezed,Object? strokeOpacity = freezed,Object? draggable = null,}) {
  return _then(_RouteMapCircleTheme(
radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color,opacity: freezed == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double?,blur: freezed == blur ? _self.blur : blur // ignore: cast_nullable_to_non_nullable
as double?,strokeWidth: freezed == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double?,strokeColor: freezed == strokeColor ? _self.strokeColor : strokeColor // ignore: cast_nullable_to_non_nullable
as Color?,strokeOpacity: freezed == strokeOpacity ? _self.strokeOpacity : strokeOpacity // ignore: cast_nullable_to_non_nullable
as double?,draggable: null == draggable ? _self.draggable : draggable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
