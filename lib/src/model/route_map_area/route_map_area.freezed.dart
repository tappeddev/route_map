// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_map_area.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RouteMapArea {

 String get identifier; List<RouteMapAreaPolygon> get polygons; RouteMapAreaTheme get theme; RouteMapAreaTheme? get darkTheme;/// Preferred style layer to insert the area below, e.g. to keep the labels
/// of the map readable. The area is always placed below drawn routes and
/// icons.
 String? get belowLayerId;
/// Create a copy of RouteMapArea
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteMapAreaCopyWith<RouteMapArea> get copyWith => _$RouteMapAreaCopyWithImpl<RouteMapArea>(this as RouteMapArea, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteMapArea&&(identical(other.identifier, identifier) || other.identifier == identifier)&&const DeepCollectionEquality().equals(other.polygons, polygons)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.darkTheme, darkTheme) || other.darkTheme == darkTheme)&&(identical(other.belowLayerId, belowLayerId) || other.belowLayerId == belowLayerId));
}


@override
int get hashCode => Object.hash(runtimeType,identifier,const DeepCollectionEquality().hash(polygons),theme,darkTheme,belowLayerId);

@override
String toString() {
  return 'RouteMapArea(identifier: $identifier, polygons: $polygons, theme: $theme, darkTheme: $darkTheme, belowLayerId: $belowLayerId)';
}


}

/// @nodoc
abstract mixin class $RouteMapAreaCopyWith<$Res>  {
  factory $RouteMapAreaCopyWith(RouteMapArea value, $Res Function(RouteMapArea) _then) = _$RouteMapAreaCopyWithImpl;
@useResult
$Res call({
 String identifier, List<RouteMapAreaPolygon> polygons, RouteMapAreaTheme theme, RouteMapAreaTheme? darkTheme, String? belowLayerId
});


$RouteMapAreaThemeCopyWith<$Res> get theme;$RouteMapAreaThemeCopyWith<$Res>? get darkTheme;

}
/// @nodoc
class _$RouteMapAreaCopyWithImpl<$Res>
    implements $RouteMapAreaCopyWith<$Res> {
  _$RouteMapAreaCopyWithImpl(this._self, this._then);

  final RouteMapArea _self;
  final $Res Function(RouteMapArea) _then;

/// Create a copy of RouteMapArea
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? identifier = null,Object? polygons = null,Object? theme = null,Object? darkTheme = freezed,Object? belowLayerId = freezed,}) {
  return _then(_self.copyWith(
identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,polygons: null == polygons ? _self.polygons : polygons // ignore: cast_nullable_to_non_nullable
as List<RouteMapAreaPolygon>,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as RouteMapAreaTheme,darkTheme: freezed == darkTheme ? _self.darkTheme : darkTheme // ignore: cast_nullable_to_non_nullable
as RouteMapAreaTheme?,belowLayerId: freezed == belowLayerId ? _self.belowLayerId : belowLayerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RouteMapArea
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapAreaThemeCopyWith<$Res> get theme {
  
  return $RouteMapAreaThemeCopyWith<$Res>(_self.theme, (value) {
    return _then(_self.copyWith(theme: value));
  });
}/// Create a copy of RouteMapArea
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapAreaThemeCopyWith<$Res>? get darkTheme {
    if (_self.darkTheme == null) {
    return null;
  }

  return $RouteMapAreaThemeCopyWith<$Res>(_self.darkTheme!, (value) {
    return _then(_self.copyWith(darkTheme: value));
  });
}
}


/// Adds pattern-matching-related methods to [RouteMapArea].
extension RouteMapAreaPatterns on RouteMapArea {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteMapArea value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteMapArea() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteMapArea value)  $default,){
final _that = this;
switch (_that) {
case _RouteMapArea():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteMapArea value)?  $default,){
final _that = this;
switch (_that) {
case _RouteMapArea() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String identifier,  List<RouteMapAreaPolygon> polygons,  RouteMapAreaTheme theme,  RouteMapAreaTheme? darkTheme,  String? belowLayerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteMapArea() when $default != null:
return $default(_that.identifier,_that.polygons,_that.theme,_that.darkTheme,_that.belowLayerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String identifier,  List<RouteMapAreaPolygon> polygons,  RouteMapAreaTheme theme,  RouteMapAreaTheme? darkTheme,  String? belowLayerId)  $default,) {final _that = this;
switch (_that) {
case _RouteMapArea():
return $default(_that.identifier,_that.polygons,_that.theme,_that.darkTheme,_that.belowLayerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String identifier,  List<RouteMapAreaPolygon> polygons,  RouteMapAreaTheme theme,  RouteMapAreaTheme? darkTheme,  String? belowLayerId)?  $default,) {final _that = this;
switch (_that) {
case _RouteMapArea() when $default != null:
return $default(_that.identifier,_that.polygons,_that.theme,_that.darkTheme,_that.belowLayerId);case _:
  return null;

}
}

}

/// @nodoc


class _RouteMapArea implements RouteMapArea {
  const _RouteMapArea({required this.identifier, required final  List<RouteMapAreaPolygon> polygons, required this.theme, this.darkTheme, this.belowLayerId}): _polygons = polygons;
  

@override final  String identifier;
 final  List<RouteMapAreaPolygon> _polygons;
@override List<RouteMapAreaPolygon> get polygons {
  if (_polygons is EqualUnmodifiableListView) return _polygons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_polygons);
}

@override final  RouteMapAreaTheme theme;
@override final  RouteMapAreaTheme? darkTheme;
/// Preferred style layer to insert the area below, e.g. to keep the labels
/// of the map readable. The area is always placed below drawn routes and
/// icons.
@override final  String? belowLayerId;

/// Create a copy of RouteMapArea
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteMapAreaCopyWith<_RouteMapArea> get copyWith => __$RouteMapAreaCopyWithImpl<_RouteMapArea>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteMapArea&&(identical(other.identifier, identifier) || other.identifier == identifier)&&const DeepCollectionEquality().equals(other._polygons, _polygons)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.darkTheme, darkTheme) || other.darkTheme == darkTheme)&&(identical(other.belowLayerId, belowLayerId) || other.belowLayerId == belowLayerId));
}


@override
int get hashCode => Object.hash(runtimeType,identifier,const DeepCollectionEquality().hash(_polygons),theme,darkTheme,belowLayerId);

@override
String toString() {
  return 'RouteMapArea(identifier: $identifier, polygons: $polygons, theme: $theme, darkTheme: $darkTheme, belowLayerId: $belowLayerId)';
}


}

/// @nodoc
abstract mixin class _$RouteMapAreaCopyWith<$Res> implements $RouteMapAreaCopyWith<$Res> {
  factory _$RouteMapAreaCopyWith(_RouteMapArea value, $Res Function(_RouteMapArea) _then) = __$RouteMapAreaCopyWithImpl;
@override @useResult
$Res call({
 String identifier, List<RouteMapAreaPolygon> polygons, RouteMapAreaTheme theme, RouteMapAreaTheme? darkTheme, String? belowLayerId
});


@override $RouteMapAreaThemeCopyWith<$Res> get theme;@override $RouteMapAreaThemeCopyWith<$Res>? get darkTheme;

}
/// @nodoc
class __$RouteMapAreaCopyWithImpl<$Res>
    implements _$RouteMapAreaCopyWith<$Res> {
  __$RouteMapAreaCopyWithImpl(this._self, this._then);

  final _RouteMapArea _self;
  final $Res Function(_RouteMapArea) _then;

/// Create a copy of RouteMapArea
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? identifier = null,Object? polygons = null,Object? theme = null,Object? darkTheme = freezed,Object? belowLayerId = freezed,}) {
  return _then(_RouteMapArea(
identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,polygons: null == polygons ? _self._polygons : polygons // ignore: cast_nullable_to_non_nullable
as List<RouteMapAreaPolygon>,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as RouteMapAreaTheme,darkTheme: freezed == darkTheme ? _self.darkTheme : darkTheme // ignore: cast_nullable_to_non_nullable
as RouteMapAreaTheme?,belowLayerId: freezed == belowLayerId ? _self.belowLayerId : belowLayerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RouteMapArea
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapAreaThemeCopyWith<$Res> get theme {
  
  return $RouteMapAreaThemeCopyWith<$Res>(_self.theme, (value) {
    return _then(_self.copyWith(theme: value));
  });
}/// Create a copy of RouteMapArea
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapAreaThemeCopyWith<$Res>? get darkTheme {
    if (_self.darkTheme == null) {
    return null;
  }

  return $RouteMapAreaThemeCopyWith<$Res>(_self.darkTheme!, (value) {
    return _then(_self.copyWith(darkTheme: value));
  });
}
}

/// @nodoc
mixin _$RouteMapAreaPolygon {

/// The outline of the polygon. It doesn't need to be closed, the first
/// point is repeated at the end if needed.
 List<LatLng> get outline;/// Areas cut out of the polygon.
 List<List<LatLng>> get holes;
/// Create a copy of RouteMapAreaPolygon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteMapAreaPolygonCopyWith<RouteMapAreaPolygon> get copyWith => _$RouteMapAreaPolygonCopyWithImpl<RouteMapAreaPolygon>(this as RouteMapAreaPolygon, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteMapAreaPolygon&&const DeepCollectionEquality().equals(other.outline, outline)&&const DeepCollectionEquality().equals(other.holes, holes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(outline),const DeepCollectionEquality().hash(holes));

@override
String toString() {
  return 'RouteMapAreaPolygon(outline: $outline, holes: $holes)';
}


}

/// @nodoc
abstract mixin class $RouteMapAreaPolygonCopyWith<$Res>  {
  factory $RouteMapAreaPolygonCopyWith(RouteMapAreaPolygon value, $Res Function(RouteMapAreaPolygon) _then) = _$RouteMapAreaPolygonCopyWithImpl;
@useResult
$Res call({
 List<LatLng> outline, List<List<LatLng>> holes
});




}
/// @nodoc
class _$RouteMapAreaPolygonCopyWithImpl<$Res>
    implements $RouteMapAreaPolygonCopyWith<$Res> {
  _$RouteMapAreaPolygonCopyWithImpl(this._self, this._then);

  final RouteMapAreaPolygon _self;
  final $Res Function(RouteMapAreaPolygon) _then;

/// Create a copy of RouteMapAreaPolygon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outline = null,Object? holes = null,}) {
  return _then(_self.copyWith(
outline: null == outline ? _self.outline : outline // ignore: cast_nullable_to_non_nullable
as List<LatLng>,holes: null == holes ? _self.holes : holes // ignore: cast_nullable_to_non_nullable
as List<List<LatLng>>,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteMapAreaPolygon].
extension RouteMapAreaPolygonPatterns on RouteMapAreaPolygon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteMapAreaPolygon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteMapAreaPolygon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteMapAreaPolygon value)  $default,){
final _that = this;
switch (_that) {
case _RouteMapAreaPolygon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteMapAreaPolygon value)?  $default,){
final _that = this;
switch (_that) {
case _RouteMapAreaPolygon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LatLng> outline,  List<List<LatLng>> holes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteMapAreaPolygon() when $default != null:
return $default(_that.outline,_that.holes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LatLng> outline,  List<List<LatLng>> holes)  $default,) {final _that = this;
switch (_that) {
case _RouteMapAreaPolygon():
return $default(_that.outline,_that.holes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LatLng> outline,  List<List<LatLng>> holes)?  $default,) {final _that = this;
switch (_that) {
case _RouteMapAreaPolygon() when $default != null:
return $default(_that.outline,_that.holes);case _:
  return null;

}
}

}

/// @nodoc


class _RouteMapAreaPolygon extends RouteMapAreaPolygon {
  const _RouteMapAreaPolygon({required final  List<LatLng> outline, final  List<List<LatLng>> holes = const <List<LatLng>>[]}): _outline = outline,_holes = holes,super._();
  

/// The outline of the polygon. It doesn't need to be closed, the first
/// point is repeated at the end if needed.
 final  List<LatLng> _outline;
/// The outline of the polygon. It doesn't need to be closed, the first
/// point is repeated at the end if needed.
@override List<LatLng> get outline {
  if (_outline is EqualUnmodifiableListView) return _outline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_outline);
}

/// Areas cut out of the polygon.
 final  List<List<LatLng>> _holes;
/// Areas cut out of the polygon.
@override@JsonKey() List<List<LatLng>> get holes {
  if (_holes is EqualUnmodifiableListView) return _holes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_holes);
}


/// Create a copy of RouteMapAreaPolygon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteMapAreaPolygonCopyWith<_RouteMapAreaPolygon> get copyWith => __$RouteMapAreaPolygonCopyWithImpl<_RouteMapAreaPolygon>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteMapAreaPolygon&&const DeepCollectionEquality().equals(other._outline, _outline)&&const DeepCollectionEquality().equals(other._holes, _holes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_outline),const DeepCollectionEquality().hash(_holes));

@override
String toString() {
  return 'RouteMapAreaPolygon(outline: $outline, holes: $holes)';
}


}

/// @nodoc
abstract mixin class _$RouteMapAreaPolygonCopyWith<$Res> implements $RouteMapAreaPolygonCopyWith<$Res> {
  factory _$RouteMapAreaPolygonCopyWith(_RouteMapAreaPolygon value, $Res Function(_RouteMapAreaPolygon) _then) = __$RouteMapAreaPolygonCopyWithImpl;
@override @useResult
$Res call({
 List<LatLng> outline, List<List<LatLng>> holes
});




}
/// @nodoc
class __$RouteMapAreaPolygonCopyWithImpl<$Res>
    implements _$RouteMapAreaPolygonCopyWith<$Res> {
  __$RouteMapAreaPolygonCopyWithImpl(this._self, this._then);

  final _RouteMapAreaPolygon _self;
  final $Res Function(_RouteMapAreaPolygon) _then;

/// Create a copy of RouteMapAreaPolygon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outline = null,Object? holes = null,}) {
  return _then(_RouteMapAreaPolygon(
outline: null == outline ? _self._outline : outline // ignore: cast_nullable_to_non_nullable
as List<LatLng>,holes: null == holes ? _self._holes : holes // ignore: cast_nullable_to_non_nullable
as List<List<LatLng>>,
  ));
}


}

/// @nodoc
mixin _$RouteMapAreaTheme {

/// The opacity is taken from the alpha of the color.
 Color get fillColor;/// The opacity is taken from the alpha of the color.
 Color get borderColor; double get borderWidth;
/// Create a copy of RouteMapAreaTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteMapAreaThemeCopyWith<RouteMapAreaTheme> get copyWith => _$RouteMapAreaThemeCopyWithImpl<RouteMapAreaTheme>(this as RouteMapAreaTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteMapAreaTheme&&(identical(other.fillColor, fillColor) || other.fillColor == fillColor)&&(identical(other.borderColor, borderColor) || other.borderColor == borderColor)&&(identical(other.borderWidth, borderWidth) || other.borderWidth == borderWidth));
}


@override
int get hashCode => Object.hash(runtimeType,fillColor,borderColor,borderWidth);

@override
String toString() {
  return 'RouteMapAreaTheme(fillColor: $fillColor, borderColor: $borderColor, borderWidth: $borderWidth)';
}


}

/// @nodoc
abstract mixin class $RouteMapAreaThemeCopyWith<$Res>  {
  factory $RouteMapAreaThemeCopyWith(RouteMapAreaTheme value, $Res Function(RouteMapAreaTheme) _then) = _$RouteMapAreaThemeCopyWithImpl;
@useResult
$Res call({
 Color fillColor, Color borderColor, double borderWidth
});




}
/// @nodoc
class _$RouteMapAreaThemeCopyWithImpl<$Res>
    implements $RouteMapAreaThemeCopyWith<$Res> {
  _$RouteMapAreaThemeCopyWithImpl(this._self, this._then);

  final RouteMapAreaTheme _self;
  final $Res Function(RouteMapAreaTheme) _then;

/// Create a copy of RouteMapAreaTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fillColor = null,Object? borderColor = null,Object? borderWidth = null,}) {
  return _then(_self.copyWith(
fillColor: null == fillColor ? _self.fillColor : fillColor // ignore: cast_nullable_to_non_nullable
as Color,borderColor: null == borderColor ? _self.borderColor : borderColor // ignore: cast_nullable_to_non_nullable
as Color,borderWidth: null == borderWidth ? _self.borderWidth : borderWidth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteMapAreaTheme].
extension RouteMapAreaThemePatterns on RouteMapAreaTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteMapAreaTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteMapAreaTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteMapAreaTheme value)  $default,){
final _that = this;
switch (_that) {
case _RouteMapAreaTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteMapAreaTheme value)?  $default,){
final _that = this;
switch (_that) {
case _RouteMapAreaTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Color fillColor,  Color borderColor,  double borderWidth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteMapAreaTheme() when $default != null:
return $default(_that.fillColor,_that.borderColor,_that.borderWidth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Color fillColor,  Color borderColor,  double borderWidth)  $default,) {final _that = this;
switch (_that) {
case _RouteMapAreaTheme():
return $default(_that.fillColor,_that.borderColor,_that.borderWidth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Color fillColor,  Color borderColor,  double borderWidth)?  $default,) {final _that = this;
switch (_that) {
case _RouteMapAreaTheme() when $default != null:
return $default(_that.fillColor,_that.borderColor,_that.borderWidth);case _:
  return null;

}
}

}

/// @nodoc


class _RouteMapAreaTheme implements RouteMapAreaTheme {
  const _RouteMapAreaTheme({required this.fillColor, required this.borderColor, this.borderWidth = 2});
  

/// The opacity is taken from the alpha of the color.
@override final  Color fillColor;
/// The opacity is taken from the alpha of the color.
@override final  Color borderColor;
@override@JsonKey() final  double borderWidth;

/// Create a copy of RouteMapAreaTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteMapAreaThemeCopyWith<_RouteMapAreaTheme> get copyWith => __$RouteMapAreaThemeCopyWithImpl<_RouteMapAreaTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteMapAreaTheme&&(identical(other.fillColor, fillColor) || other.fillColor == fillColor)&&(identical(other.borderColor, borderColor) || other.borderColor == borderColor)&&(identical(other.borderWidth, borderWidth) || other.borderWidth == borderWidth));
}


@override
int get hashCode => Object.hash(runtimeType,fillColor,borderColor,borderWidth);

@override
String toString() {
  return 'RouteMapAreaTheme(fillColor: $fillColor, borderColor: $borderColor, borderWidth: $borderWidth)';
}


}

/// @nodoc
abstract mixin class _$RouteMapAreaThemeCopyWith<$Res> implements $RouteMapAreaThemeCopyWith<$Res> {
  factory _$RouteMapAreaThemeCopyWith(_RouteMapAreaTheme value, $Res Function(_RouteMapAreaTheme) _then) = __$RouteMapAreaThemeCopyWithImpl;
@override @useResult
$Res call({
 Color fillColor, Color borderColor, double borderWidth
});




}
/// @nodoc
class __$RouteMapAreaThemeCopyWithImpl<$Res>
    implements _$RouteMapAreaThemeCopyWith<$Res> {
  __$RouteMapAreaThemeCopyWithImpl(this._self, this._then);

  final _RouteMapAreaTheme _self;
  final $Res Function(_RouteMapAreaTheme) _then;

/// Create a copy of RouteMapAreaTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fillColor = null,Object? borderColor = null,Object? borderWidth = null,}) {
  return _then(_RouteMapAreaTheme(
fillColor: null == fillColor ? _self.fillColor : fillColor // ignore: cast_nullable_to_non_nullable
as Color,borderColor: null == borderColor ? _self.borderColor : borderColor // ignore: cast_nullable_to_non_nullable
as Color,borderWidth: null == borderWidth ? _self.borderWidth : borderWidth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
