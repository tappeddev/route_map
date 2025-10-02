// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_map_route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RouteMapRoute {

 List<LatLng> get points; RouteMapRouteTheme get theme; RouteMapRouteTheme? get darkTheme;
/// Create a copy of RouteMapRoute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteMapRouteCopyWith<RouteMapRoute> get copyWith => _$RouteMapRouteCopyWithImpl<RouteMapRoute>(this as RouteMapRoute, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteMapRoute&&const DeepCollectionEquality().equals(other.points, points)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.darkTheme, darkTheme) || other.darkTheme == darkTheme));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(points),theme,darkTheme);

@override
String toString() {
  return 'RouteMapRoute(points: $points, theme: $theme, darkTheme: $darkTheme)';
}


}

/// @nodoc
abstract mixin class $RouteMapRouteCopyWith<$Res>  {
  factory $RouteMapRouteCopyWith(RouteMapRoute value, $Res Function(RouteMapRoute) _then) = _$RouteMapRouteCopyWithImpl;
@useResult
$Res call({
 List<LatLng> points, RouteMapRouteTheme theme, RouteMapRouteTheme? darkTheme
});


$RouteMapRouteThemeCopyWith<$Res> get theme;$RouteMapRouteThemeCopyWith<$Res>? get darkTheme;

}
/// @nodoc
class _$RouteMapRouteCopyWithImpl<$Res>
    implements $RouteMapRouteCopyWith<$Res> {
  _$RouteMapRouteCopyWithImpl(this._self, this._then);

  final RouteMapRoute _self;
  final $Res Function(RouteMapRoute) _then;

/// Create a copy of RouteMapRoute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? points = null,Object? theme = null,Object? darkTheme = freezed,}) {
  return _then(_self.copyWith(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<LatLng>,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as RouteMapRouteTheme,darkTheme: freezed == darkTheme ? _self.darkTheme : darkTheme // ignore: cast_nullable_to_non_nullable
as RouteMapRouteTheme?,
  ));
}
/// Create a copy of RouteMapRoute
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapRouteThemeCopyWith<$Res> get theme {
  
  return $RouteMapRouteThemeCopyWith<$Res>(_self.theme, (value) {
    return _then(_self.copyWith(theme: value));
  });
}/// Create a copy of RouteMapRoute
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapRouteThemeCopyWith<$Res>? get darkTheme {
    if (_self.darkTheme == null) {
    return null;
  }

  return $RouteMapRouteThemeCopyWith<$Res>(_self.darkTheme!, (value) {
    return _then(_self.copyWith(darkTheme: value));
  });
}
}


/// Adds pattern-matching-related methods to [RouteMapRoute].
extension RouteMapRoutePatterns on RouteMapRoute {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteMapRoute value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteMapRoute() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteMapRoute value)  $default,){
final _that = this;
switch (_that) {
case _RouteMapRoute():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteMapRoute value)?  $default,){
final _that = this;
switch (_that) {
case _RouteMapRoute() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LatLng> points,  RouteMapRouteTheme theme,  RouteMapRouteTheme? darkTheme)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteMapRoute() when $default != null:
return $default(_that.points,_that.theme,_that.darkTheme);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LatLng> points,  RouteMapRouteTheme theme,  RouteMapRouteTheme? darkTheme)  $default,) {final _that = this;
switch (_that) {
case _RouteMapRoute():
return $default(_that.points,_that.theme,_that.darkTheme);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LatLng> points,  RouteMapRouteTheme theme,  RouteMapRouteTheme? darkTheme)?  $default,) {final _that = this;
switch (_that) {
case _RouteMapRoute() when $default != null:
return $default(_that.points,_that.theme,_that.darkTheme);case _:
  return null;

}
}

}

/// @nodoc


class _RouteMapRoute implements RouteMapRoute {
  const _RouteMapRoute({required final  List<LatLng> points, required this.theme, this.darkTheme}): _points = points;
  

 final  List<LatLng> _points;
@override List<LatLng> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

@override final  RouteMapRouteTheme theme;
@override final  RouteMapRouteTheme? darkTheme;

/// Create a copy of RouteMapRoute
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteMapRouteCopyWith<_RouteMapRoute> get copyWith => __$RouteMapRouteCopyWithImpl<_RouteMapRoute>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteMapRoute&&const DeepCollectionEquality().equals(other._points, _points)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.darkTheme, darkTheme) || other.darkTheme == darkTheme));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_points),theme,darkTheme);

@override
String toString() {
  return 'RouteMapRoute(points: $points, theme: $theme, darkTheme: $darkTheme)';
}


}

/// @nodoc
abstract mixin class _$RouteMapRouteCopyWith<$Res> implements $RouteMapRouteCopyWith<$Res> {
  factory _$RouteMapRouteCopyWith(_RouteMapRoute value, $Res Function(_RouteMapRoute) _then) = __$RouteMapRouteCopyWithImpl;
@override @useResult
$Res call({
 List<LatLng> points, RouteMapRouteTheme theme, RouteMapRouteTheme? darkTheme
});


@override $RouteMapRouteThemeCopyWith<$Res> get theme;@override $RouteMapRouteThemeCopyWith<$Res>? get darkTheme;

}
/// @nodoc
class __$RouteMapRouteCopyWithImpl<$Res>
    implements _$RouteMapRouteCopyWith<$Res> {
  __$RouteMapRouteCopyWithImpl(this._self, this._then);

  final _RouteMapRoute _self;
  final $Res Function(_RouteMapRoute) _then;

/// Create a copy of RouteMapRoute
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? theme = null,Object? darkTheme = freezed,}) {
  return _then(_RouteMapRoute(
points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<LatLng>,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as RouteMapRouteTheme,darkTheme: freezed == darkTheme ? _self.darkTheme : darkTheme // ignore: cast_nullable_to_non_nullable
as RouteMapRouteTheme?,
  ));
}

/// Create a copy of RouteMapRoute
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapRouteThemeCopyWith<$Res> get theme {
  
  return $RouteMapRouteThemeCopyWith<$Res>(_self.theme, (value) {
    return _then(_self.copyWith(theme: value));
  });
}/// Create a copy of RouteMapRoute
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapRouteThemeCopyWith<$Res>? get darkTheme {
    if (_self.darkTheme == null) {
    return null;
  }

  return $RouteMapRouteThemeCopyWith<$Res>(_self.darkTheme!, (value) {
    return _then(_self.copyWith(darkTheme: value));
  });
}
}

/// @nodoc
mixin _$RouteMapRouteTheme {

 double get lineWidth; Color get color; double? get backLineWidth; Color? get backLineColor;
/// Create a copy of RouteMapRouteTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteMapRouteThemeCopyWith<RouteMapRouteTheme> get copyWith => _$RouteMapRouteThemeCopyWithImpl<RouteMapRouteTheme>(this as RouteMapRouteTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteMapRouteTheme&&(identical(other.lineWidth, lineWidth) || other.lineWidth == lineWidth)&&(identical(other.color, color) || other.color == color)&&(identical(other.backLineWidth, backLineWidth) || other.backLineWidth == backLineWidth)&&(identical(other.backLineColor, backLineColor) || other.backLineColor == backLineColor));
}


@override
int get hashCode => Object.hash(runtimeType,lineWidth,color,backLineWidth,backLineColor);

@override
String toString() {
  return 'RouteMapRouteTheme(lineWidth: $lineWidth, color: $color, backLineWidth: $backLineWidth, backLineColor: $backLineColor)';
}


}

/// @nodoc
abstract mixin class $RouteMapRouteThemeCopyWith<$Res>  {
  factory $RouteMapRouteThemeCopyWith(RouteMapRouteTheme value, $Res Function(RouteMapRouteTheme) _then) = _$RouteMapRouteThemeCopyWithImpl;
@useResult
$Res call({
 double lineWidth, Color color, double? backLineWidth, Color? backLineColor
});




}
/// @nodoc
class _$RouteMapRouteThemeCopyWithImpl<$Res>
    implements $RouteMapRouteThemeCopyWith<$Res> {
  _$RouteMapRouteThemeCopyWithImpl(this._self, this._then);

  final RouteMapRouteTheme _self;
  final $Res Function(RouteMapRouteTheme) _then;

/// Create a copy of RouteMapRouteTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lineWidth = null,Object? color = null,Object? backLineWidth = freezed,Object? backLineColor = freezed,}) {
  return _then(_self.copyWith(
lineWidth: null == lineWidth ? _self.lineWidth : lineWidth // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color,backLineWidth: freezed == backLineWidth ? _self.backLineWidth : backLineWidth // ignore: cast_nullable_to_non_nullable
as double?,backLineColor: freezed == backLineColor ? _self.backLineColor : backLineColor // ignore: cast_nullable_to_non_nullable
as Color?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteMapRouteTheme].
extension RouteMapRouteThemePatterns on RouteMapRouteTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteMapRouteTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteMapRouteTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteMapRouteTheme value)  $default,){
final _that = this;
switch (_that) {
case _RouteMapRouteTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteMapRouteTheme value)?  $default,){
final _that = this;
switch (_that) {
case _RouteMapRouteTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lineWidth,  Color color,  double? backLineWidth,  Color? backLineColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteMapRouteTheme() when $default != null:
return $default(_that.lineWidth,_that.color,_that.backLineWidth,_that.backLineColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lineWidth,  Color color,  double? backLineWidth,  Color? backLineColor)  $default,) {final _that = this;
switch (_that) {
case _RouteMapRouteTheme():
return $default(_that.lineWidth,_that.color,_that.backLineWidth,_that.backLineColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lineWidth,  Color color,  double? backLineWidth,  Color? backLineColor)?  $default,) {final _that = this;
switch (_that) {
case _RouteMapRouteTheme() when $default != null:
return $default(_that.lineWidth,_that.color,_that.backLineWidth,_that.backLineColor);case _:
  return null;

}
}

}

/// @nodoc


class _RouteMapRouteTheme implements RouteMapRouteTheme {
  const _RouteMapRouteTheme({required this.lineWidth, required this.color, this.backLineWidth, this.backLineColor});
  

@override final  double lineWidth;
@override final  Color color;
@override final  double? backLineWidth;
@override final  Color? backLineColor;

/// Create a copy of RouteMapRouteTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteMapRouteThemeCopyWith<_RouteMapRouteTheme> get copyWith => __$RouteMapRouteThemeCopyWithImpl<_RouteMapRouteTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteMapRouteTheme&&(identical(other.lineWidth, lineWidth) || other.lineWidth == lineWidth)&&(identical(other.color, color) || other.color == color)&&(identical(other.backLineWidth, backLineWidth) || other.backLineWidth == backLineWidth)&&(identical(other.backLineColor, backLineColor) || other.backLineColor == backLineColor));
}


@override
int get hashCode => Object.hash(runtimeType,lineWidth,color,backLineWidth,backLineColor);

@override
String toString() {
  return 'RouteMapRouteTheme(lineWidth: $lineWidth, color: $color, backLineWidth: $backLineWidth, backLineColor: $backLineColor)';
}


}

/// @nodoc
abstract mixin class _$RouteMapRouteThemeCopyWith<$Res> implements $RouteMapRouteThemeCopyWith<$Res> {
  factory _$RouteMapRouteThemeCopyWith(_RouteMapRouteTheme value, $Res Function(_RouteMapRouteTheme) _then) = __$RouteMapRouteThemeCopyWithImpl;
@override @useResult
$Res call({
 double lineWidth, Color color, double? backLineWidth, Color? backLineColor
});




}
/// @nodoc
class __$RouteMapRouteThemeCopyWithImpl<$Res>
    implements _$RouteMapRouteThemeCopyWith<$Res> {
  __$RouteMapRouteThemeCopyWithImpl(this._self, this._then);

  final _RouteMapRouteTheme _self;
  final $Res Function(_RouteMapRouteTheme) _then;

/// Create a copy of RouteMapRouteTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lineWidth = null,Object? color = null,Object? backLineWidth = freezed,Object? backLineColor = freezed,}) {
  return _then(_RouteMapRouteTheme(
lineWidth: null == lineWidth ? _self.lineWidth : lineWidth // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color,backLineWidth: freezed == backLineWidth ? _self.backLineWidth : backLineWidth // ignore: cast_nullable_to_non_nullable
as double?,backLineColor: freezed == backLineColor ? _self.backLineColor : backLineColor // ignore: cast_nullable_to_non_nullable
as Color?,
  ));
}


}

// dart format on
