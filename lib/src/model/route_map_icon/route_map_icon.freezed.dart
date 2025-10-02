// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_map_icon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RouteMapIcon {

 Size get size; LatLng get latLng; String get identifier; RouteMapIconTheme get theme; RouteMapIconTheme? get darkTheme; String? get svgIconPath; String? get text; Path Function(Size) get drawPath; String? get label; bool get draggable; RouteMapIconAnchor get anchor;
/// Create a copy of RouteMapIcon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteMapIconCopyWith<RouteMapIcon> get copyWith => _$RouteMapIconCopyWithImpl<RouteMapIcon>(this as RouteMapIcon, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteMapIcon&&(identical(other.size, size) || other.size == size)&&(identical(other.latLng, latLng) || other.latLng == latLng)&&(identical(other.identifier, identifier) || other.identifier == identifier)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.darkTheme, darkTheme) || other.darkTheme == darkTheme)&&(identical(other.svgIconPath, svgIconPath) || other.svgIconPath == svgIconPath)&&(identical(other.text, text) || other.text == text)&&(identical(other.drawPath, drawPath) || other.drawPath == drawPath)&&(identical(other.label, label) || other.label == label)&&(identical(other.draggable, draggable) || other.draggable == draggable)&&(identical(other.anchor, anchor) || other.anchor == anchor));
}


@override
int get hashCode => Object.hash(runtimeType,size,latLng,identifier,theme,darkTheme,svgIconPath,text,drawPath,label,draggable,anchor);

@override
String toString() {
  return 'RouteMapIcon(size: $size, latLng: $latLng, identifier: $identifier, theme: $theme, darkTheme: $darkTheme, svgIconPath: $svgIconPath, text: $text, drawPath: $drawPath, label: $label, draggable: $draggable, anchor: $anchor)';
}


}

/// @nodoc
abstract mixin class $RouteMapIconCopyWith<$Res>  {
  factory $RouteMapIconCopyWith(RouteMapIcon value, $Res Function(RouteMapIcon) _then) = _$RouteMapIconCopyWithImpl;
@useResult
$Res call({
 Size size, LatLng latLng, String identifier, RouteMapIconTheme theme, RouteMapIconTheme? darkTheme, String? svgIconPath, String? text, Path Function(Size) drawPath, String? label, bool draggable, RouteMapIconAnchor anchor
});


$RouteMapIconThemeCopyWith<$Res> get theme;$RouteMapIconThemeCopyWith<$Res>? get darkTheme;

}
/// @nodoc
class _$RouteMapIconCopyWithImpl<$Res>
    implements $RouteMapIconCopyWith<$Res> {
  _$RouteMapIconCopyWithImpl(this._self, this._then);

  final RouteMapIcon _self;
  final $Res Function(RouteMapIcon) _then;

/// Create a copy of RouteMapIcon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? size = null,Object? latLng = null,Object? identifier = null,Object? theme = null,Object? darkTheme = freezed,Object? svgIconPath = freezed,Object? text = freezed,Object? drawPath = null,Object? label = freezed,Object? draggable = null,Object? anchor = null,}) {
  return _then(_self.copyWith(
size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as Size,latLng: null == latLng ? _self.latLng : latLng // ignore: cast_nullable_to_non_nullable
as LatLng,identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as RouteMapIconTheme,darkTheme: freezed == darkTheme ? _self.darkTheme : darkTheme // ignore: cast_nullable_to_non_nullable
as RouteMapIconTheme?,svgIconPath: freezed == svgIconPath ? _self.svgIconPath : svgIconPath // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,drawPath: null == drawPath ? _self.drawPath : drawPath // ignore: cast_nullable_to_non_nullable
as Path Function(Size),label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,draggable: null == draggable ? _self.draggable : draggable // ignore: cast_nullable_to_non_nullable
as bool,anchor: null == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as RouteMapIconAnchor,
  ));
}
/// Create a copy of RouteMapIcon
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapIconThemeCopyWith<$Res> get theme {
  
  return $RouteMapIconThemeCopyWith<$Res>(_self.theme, (value) {
    return _then(_self.copyWith(theme: value));
  });
}/// Create a copy of RouteMapIcon
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapIconThemeCopyWith<$Res>? get darkTheme {
    if (_self.darkTheme == null) {
    return null;
  }

  return $RouteMapIconThemeCopyWith<$Res>(_self.darkTheme!, (value) {
    return _then(_self.copyWith(darkTheme: value));
  });
}
}


/// Adds pattern-matching-related methods to [RouteMapIcon].
extension RouteMapIconPatterns on RouteMapIcon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteMapIcon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteMapIcon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteMapIcon value)  $default,){
final _that = this;
switch (_that) {
case _RouteMapIcon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteMapIcon value)?  $default,){
final _that = this;
switch (_that) {
case _RouteMapIcon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Size size,  LatLng latLng,  String identifier,  RouteMapIconTheme theme,  RouteMapIconTheme? darkTheme,  String? svgIconPath,  String? text,  Path Function(Size) drawPath,  String? label,  bool draggable,  RouteMapIconAnchor anchor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteMapIcon() when $default != null:
return $default(_that.size,_that.latLng,_that.identifier,_that.theme,_that.darkTheme,_that.svgIconPath,_that.text,_that.drawPath,_that.label,_that.draggable,_that.anchor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Size size,  LatLng latLng,  String identifier,  RouteMapIconTheme theme,  RouteMapIconTheme? darkTheme,  String? svgIconPath,  String? text,  Path Function(Size) drawPath,  String? label,  bool draggable,  RouteMapIconAnchor anchor)  $default,) {final _that = this;
switch (_that) {
case _RouteMapIcon():
return $default(_that.size,_that.latLng,_that.identifier,_that.theme,_that.darkTheme,_that.svgIconPath,_that.text,_that.drawPath,_that.label,_that.draggable,_that.anchor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Size size,  LatLng latLng,  String identifier,  RouteMapIconTheme theme,  RouteMapIconTheme? darkTheme,  String? svgIconPath,  String? text,  Path Function(Size) drawPath,  String? label,  bool draggable,  RouteMapIconAnchor anchor)?  $default,) {final _that = this;
switch (_that) {
case _RouteMapIcon() when $default != null:
return $default(_that.size,_that.latLng,_that.identifier,_that.theme,_that.darkTheme,_that.svgIconPath,_that.text,_that.drawPath,_that.label,_that.draggable,_that.anchor);case _:
  return null;

}
}

}

/// @nodoc


class _RouteMapIcon implements RouteMapIcon {
  const _RouteMapIcon({required this.size, required this.latLng, required this.identifier, required this.theme, this.darkTheme, this.svgIconPath, this.text, required this.drawPath, this.label, this.draggable = false, this.anchor = RouteMapIconAnchor.bottom}): assert(svgIconPath == null || text == null, 'Either svgIcon or text must be provided, not both.');
  

@override final  Size size;
@override final  LatLng latLng;
@override final  String identifier;
@override final  RouteMapIconTheme theme;
@override final  RouteMapIconTheme? darkTheme;
@override final  String? svgIconPath;
@override final  String? text;
@override final  Path Function(Size) drawPath;
@override final  String? label;
@override@JsonKey() final  bool draggable;
@override@JsonKey() final  RouteMapIconAnchor anchor;

/// Create a copy of RouteMapIcon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteMapIconCopyWith<_RouteMapIcon> get copyWith => __$RouteMapIconCopyWithImpl<_RouteMapIcon>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteMapIcon&&(identical(other.size, size) || other.size == size)&&(identical(other.latLng, latLng) || other.latLng == latLng)&&(identical(other.identifier, identifier) || other.identifier == identifier)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.darkTheme, darkTheme) || other.darkTheme == darkTheme)&&(identical(other.svgIconPath, svgIconPath) || other.svgIconPath == svgIconPath)&&(identical(other.text, text) || other.text == text)&&(identical(other.drawPath, drawPath) || other.drawPath == drawPath)&&(identical(other.label, label) || other.label == label)&&(identical(other.draggable, draggable) || other.draggable == draggable)&&(identical(other.anchor, anchor) || other.anchor == anchor));
}


@override
int get hashCode => Object.hash(runtimeType,size,latLng,identifier,theme,darkTheme,svgIconPath,text,drawPath,label,draggable,anchor);

@override
String toString() {
  return 'RouteMapIcon(size: $size, latLng: $latLng, identifier: $identifier, theme: $theme, darkTheme: $darkTheme, svgIconPath: $svgIconPath, text: $text, drawPath: $drawPath, label: $label, draggable: $draggable, anchor: $anchor)';
}


}

/// @nodoc
abstract mixin class _$RouteMapIconCopyWith<$Res> implements $RouteMapIconCopyWith<$Res> {
  factory _$RouteMapIconCopyWith(_RouteMapIcon value, $Res Function(_RouteMapIcon) _then) = __$RouteMapIconCopyWithImpl;
@override @useResult
$Res call({
 Size size, LatLng latLng, String identifier, RouteMapIconTheme theme, RouteMapIconTheme? darkTheme, String? svgIconPath, String? text, Path Function(Size) drawPath, String? label, bool draggable, RouteMapIconAnchor anchor
});


@override $RouteMapIconThemeCopyWith<$Res> get theme;@override $RouteMapIconThemeCopyWith<$Res>? get darkTheme;

}
/// @nodoc
class __$RouteMapIconCopyWithImpl<$Res>
    implements _$RouteMapIconCopyWith<$Res> {
  __$RouteMapIconCopyWithImpl(this._self, this._then);

  final _RouteMapIcon _self;
  final $Res Function(_RouteMapIcon) _then;

/// Create a copy of RouteMapIcon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? size = null,Object? latLng = null,Object? identifier = null,Object? theme = null,Object? darkTheme = freezed,Object? svgIconPath = freezed,Object? text = freezed,Object? drawPath = null,Object? label = freezed,Object? draggable = null,Object? anchor = null,}) {
  return _then(_RouteMapIcon(
size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as Size,latLng: null == latLng ? _self.latLng : latLng // ignore: cast_nullable_to_non_nullable
as LatLng,identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as RouteMapIconTheme,darkTheme: freezed == darkTheme ? _self.darkTheme : darkTheme // ignore: cast_nullable_to_non_nullable
as RouteMapIconTheme?,svgIconPath: freezed == svgIconPath ? _self.svgIconPath : svgIconPath // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,drawPath: null == drawPath ? _self.drawPath : drawPath // ignore: cast_nullable_to_non_nullable
as Path Function(Size),label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,draggable: null == draggable ? _self.draggable : draggable // ignore: cast_nullable_to_non_nullable
as bool,anchor: null == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as RouteMapIconAnchor,
  ));
}

/// Create a copy of RouteMapIcon
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapIconThemeCopyWith<$Res> get theme {
  
  return $RouteMapIconThemeCopyWith<$Res>(_self.theme, (value) {
    return _then(_self.copyWith(theme: value));
  });
}/// Create a copy of RouteMapIcon
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteMapIconThemeCopyWith<$Res>? get darkTheme {
    if (_self.darkTheme == null) {
    return null;
  }

  return $RouteMapIconThemeCopyWith<$Res>(_self.darkTheme!, (value) {
    return _then(_self.copyWith(darkTheme: value));
  });
}
}

/// @nodoc
mixin _$RouteMapIconTheme {

 Color get background; Color get foreground; bool get drawCircleAroundIcon; double get strokeWidth; double get padding;
/// Create a copy of RouteMapIconTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteMapIconThemeCopyWith<RouteMapIconTheme> get copyWith => _$RouteMapIconThemeCopyWithImpl<RouteMapIconTheme>(this as RouteMapIconTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteMapIconTheme&&(identical(other.background, background) || other.background == background)&&(identical(other.foreground, foreground) || other.foreground == foreground)&&(identical(other.drawCircleAroundIcon, drawCircleAroundIcon) || other.drawCircleAroundIcon == drawCircleAroundIcon)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.padding, padding) || other.padding == padding));
}


@override
int get hashCode => Object.hash(runtimeType,background,foreground,drawCircleAroundIcon,strokeWidth,padding);

@override
String toString() {
  return 'RouteMapIconTheme(background: $background, foreground: $foreground, drawCircleAroundIcon: $drawCircleAroundIcon, strokeWidth: $strokeWidth, padding: $padding)';
}


}

/// @nodoc
abstract mixin class $RouteMapIconThemeCopyWith<$Res>  {
  factory $RouteMapIconThemeCopyWith(RouteMapIconTheme value, $Res Function(RouteMapIconTheme) _then) = _$RouteMapIconThemeCopyWithImpl;
@useResult
$Res call({
 Color background, Color foreground, bool drawCircleAroundIcon, double strokeWidth, double padding
});




}
/// @nodoc
class _$RouteMapIconThemeCopyWithImpl<$Res>
    implements $RouteMapIconThemeCopyWith<$Res> {
  _$RouteMapIconThemeCopyWithImpl(this._self, this._then);

  final RouteMapIconTheme _self;
  final $Res Function(RouteMapIconTheme) _then;

/// Create a copy of RouteMapIconTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? background = null,Object? foreground = null,Object? drawCircleAroundIcon = null,Object? strokeWidth = null,Object? padding = null,}) {
  return _then(_self.copyWith(
background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as Color,foreground: null == foreground ? _self.foreground : foreground // ignore: cast_nullable_to_non_nullable
as Color,drawCircleAroundIcon: null == drawCircleAroundIcon ? _self.drawCircleAroundIcon : drawCircleAroundIcon // ignore: cast_nullable_to_non_nullable
as bool,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,padding: null == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteMapIconTheme].
extension RouteMapIconThemePatterns on RouteMapIconTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteMapIconTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteMapIconTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteMapIconTheme value)  $default,){
final _that = this;
switch (_that) {
case _RouteMapIconTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteMapIconTheme value)?  $default,){
final _that = this;
switch (_that) {
case _RouteMapIconTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Color background,  Color foreground,  bool drawCircleAroundIcon,  double strokeWidth,  double padding)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteMapIconTheme() when $default != null:
return $default(_that.background,_that.foreground,_that.drawCircleAroundIcon,_that.strokeWidth,_that.padding);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Color background,  Color foreground,  bool drawCircleAroundIcon,  double strokeWidth,  double padding)  $default,) {final _that = this;
switch (_that) {
case _RouteMapIconTheme():
return $default(_that.background,_that.foreground,_that.drawCircleAroundIcon,_that.strokeWidth,_that.padding);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Color background,  Color foreground,  bool drawCircleAroundIcon,  double strokeWidth,  double padding)?  $default,) {final _that = this;
switch (_that) {
case _RouteMapIconTheme() when $default != null:
return $default(_that.background,_that.foreground,_that.drawCircleAroundIcon,_that.strokeWidth,_that.padding);case _:
  return null;

}
}

}

/// @nodoc


class _RouteMapIconTheme implements RouteMapIconTheme {
  const _RouteMapIconTheme({required this.background, required this.foreground, this.drawCircleAroundIcon = false, this.strokeWidth = 0, this.padding = 10});
  

@override final  Color background;
@override final  Color foreground;
@override@JsonKey() final  bool drawCircleAroundIcon;
@override@JsonKey() final  double strokeWidth;
@override@JsonKey() final  double padding;

/// Create a copy of RouteMapIconTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteMapIconThemeCopyWith<_RouteMapIconTheme> get copyWith => __$RouteMapIconThemeCopyWithImpl<_RouteMapIconTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteMapIconTheme&&(identical(other.background, background) || other.background == background)&&(identical(other.foreground, foreground) || other.foreground == foreground)&&(identical(other.drawCircleAroundIcon, drawCircleAroundIcon) || other.drawCircleAroundIcon == drawCircleAroundIcon)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.padding, padding) || other.padding == padding));
}


@override
int get hashCode => Object.hash(runtimeType,background,foreground,drawCircleAroundIcon,strokeWidth,padding);

@override
String toString() {
  return 'RouteMapIconTheme(background: $background, foreground: $foreground, drawCircleAroundIcon: $drawCircleAroundIcon, strokeWidth: $strokeWidth, padding: $padding)';
}


}

/// @nodoc
abstract mixin class _$RouteMapIconThemeCopyWith<$Res> implements $RouteMapIconThemeCopyWith<$Res> {
  factory _$RouteMapIconThemeCopyWith(_RouteMapIconTheme value, $Res Function(_RouteMapIconTheme) _then) = __$RouteMapIconThemeCopyWithImpl;
@override @useResult
$Res call({
 Color background, Color foreground, bool drawCircleAroundIcon, double strokeWidth, double padding
});




}
/// @nodoc
class __$RouteMapIconThemeCopyWithImpl<$Res>
    implements _$RouteMapIconThemeCopyWith<$Res> {
  __$RouteMapIconThemeCopyWithImpl(this._self, this._then);

  final _RouteMapIconTheme _self;
  final $Res Function(_RouteMapIconTheme) _then;

/// Create a copy of RouteMapIconTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? background = null,Object? foreground = null,Object? drawCircleAroundIcon = null,Object? strokeWidth = null,Object? padding = null,}) {
  return _then(_RouteMapIconTheme(
background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as Color,foreground: null == foreground ? _self.foreground : foreground // ignore: cast_nullable_to_non_nullable
as Color,drawCircleAroundIcon: null == drawCircleAroundIcon ? _self.drawCircleAroundIcon : drawCircleAroundIcon // ignore: cast_nullable_to_non_nullable
as bool,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,padding: null == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
