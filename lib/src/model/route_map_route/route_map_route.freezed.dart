// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_map_route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RouteMapRoute {
  String get identifier => throw _privateConstructorUsedError;
  List<LatLng> get points => throw _privateConstructorUsedError;
  RouteMapRouteTheme get theme => throw _privateConstructorUsedError;
  RouteMapRouteTheme? get darkTheme => throw _privateConstructorUsedError;

  /// Create a copy of RouteMapRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteMapRouteCopyWith<RouteMapRoute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteMapRouteCopyWith<$Res> {
  factory $RouteMapRouteCopyWith(
    RouteMapRoute value,
    $Res Function(RouteMapRoute) then,
  ) = _$RouteMapRouteCopyWithImpl<$Res, RouteMapRoute>;
  @useResult
  $Res call({
    String identifier,
    List<LatLng> points,
    RouteMapRouteTheme theme,
    RouteMapRouteTheme? darkTheme,
  });

  $RouteMapRouteThemeCopyWith<$Res> get theme;
  $RouteMapRouteThemeCopyWith<$Res>? get darkTheme;
}

/// @nodoc
class _$RouteMapRouteCopyWithImpl<$Res, $Val extends RouteMapRoute>
    implements $RouteMapRouteCopyWith<$Res> {
  _$RouteMapRouteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteMapRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
    Object? points = null,
    Object? theme = null,
    Object? darkTheme = freezed,
  }) {
    return _then(
      _value.copyWith(
            identifier: null == identifier
                ? _value.identifier
                : identifier // ignore: cast_nullable_to_non_nullable
                      as String,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as List<LatLng>,
            theme: null == theme
                ? _value.theme
                : theme // ignore: cast_nullable_to_non_nullable
                      as RouteMapRouteTheme,
            darkTheme: freezed == darkTheme
                ? _value.darkTheme
                : darkTheme // ignore: cast_nullable_to_non_nullable
                      as RouteMapRouteTheme?,
          )
          as $Val,
    );
  }

  /// Create a copy of RouteMapRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RouteMapRouteThemeCopyWith<$Res> get theme {
    return $RouteMapRouteThemeCopyWith<$Res>(_value.theme, (value) {
      return _then(_value.copyWith(theme: value) as $Val);
    });
  }

  /// Create a copy of RouteMapRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RouteMapRouteThemeCopyWith<$Res>? get darkTheme {
    if (_value.darkTheme == null) {
      return null;
    }

    return $RouteMapRouteThemeCopyWith<$Res>(_value.darkTheme!, (value) {
      return _then(_value.copyWith(darkTheme: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RouteMapRouteImplCopyWith<$Res>
    implements $RouteMapRouteCopyWith<$Res> {
  factory _$$RouteMapRouteImplCopyWith(
    _$RouteMapRouteImpl value,
    $Res Function(_$RouteMapRouteImpl) then,
  ) = __$$RouteMapRouteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String identifier,
    List<LatLng> points,
    RouteMapRouteTheme theme,
    RouteMapRouteTheme? darkTheme,
  });

  @override
  $RouteMapRouteThemeCopyWith<$Res> get theme;
  @override
  $RouteMapRouteThemeCopyWith<$Res>? get darkTheme;
}

/// @nodoc
class __$$RouteMapRouteImplCopyWithImpl<$Res>
    extends _$RouteMapRouteCopyWithImpl<$Res, _$RouteMapRouteImpl>
    implements _$$RouteMapRouteImplCopyWith<$Res> {
  __$$RouteMapRouteImplCopyWithImpl(
    _$RouteMapRouteImpl _value,
    $Res Function(_$RouteMapRouteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RouteMapRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
    Object? points = null,
    Object? theme = null,
    Object? darkTheme = freezed,
  }) {
    return _then(
      _$RouteMapRouteImpl(
        identifier: null == identifier
            ? _value.identifier
            : identifier // ignore: cast_nullable_to_non_nullable
                  as String,
        points: null == points
            ? _value._points
            : points // ignore: cast_nullable_to_non_nullable
                  as List<LatLng>,
        theme: null == theme
            ? _value.theme
            : theme // ignore: cast_nullable_to_non_nullable
                  as RouteMapRouteTheme,
        darkTheme: freezed == darkTheme
            ? _value.darkTheme
            : darkTheme // ignore: cast_nullable_to_non_nullable
                  as RouteMapRouteTheme?,
      ),
    );
  }
}

/// @nodoc

class _$RouteMapRouteImpl implements _RouteMapRoute {
  const _$RouteMapRouteImpl({
    required this.identifier,
    required final List<LatLng> points,
    required this.theme,
    this.darkTheme,
  }) : _points = points;

  @override
  final String identifier;
  final List<LatLng> _points;
  @override
  List<LatLng> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  @override
  final RouteMapRouteTheme theme;
  @override
  final RouteMapRouteTheme? darkTheme;

  @override
  String toString() {
    return 'RouteMapRoute(identifier: $identifier, points: $points, theme: $theme, darkTheme: $darkTheme)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteMapRouteImpl &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            const DeepCollectionEquality().equals(other._points, _points) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.darkTheme, darkTheme) ||
                other.darkTheme == darkTheme));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    identifier,
    const DeepCollectionEquality().hash(_points),
    theme,
    darkTheme,
  );

  /// Create a copy of RouteMapRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteMapRouteImplCopyWith<_$RouteMapRouteImpl> get copyWith =>
      __$$RouteMapRouteImplCopyWithImpl<_$RouteMapRouteImpl>(this, _$identity);
}

abstract class _RouteMapRoute implements RouteMapRoute {
  const factory _RouteMapRoute({
    required final String identifier,
    required final List<LatLng> points,
    required final RouteMapRouteTheme theme,
    final RouteMapRouteTheme? darkTheme,
  }) = _$RouteMapRouteImpl;

  @override
  String get identifier;
  @override
  List<LatLng> get points;
  @override
  RouteMapRouteTheme get theme;
  @override
  RouteMapRouteTheme? get darkTheme;

  /// Create a copy of RouteMapRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteMapRouteImplCopyWith<_$RouteMapRouteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RouteMapRouteTheme {
  double get lineWidth => throw _privateConstructorUsedError;
  Color get color => throw _privateConstructorUsedError;
  double? get backLineWidth => throw _privateConstructorUsedError;
  Color? get backLineColor => throw _privateConstructorUsedError;

  /// Create a copy of RouteMapRouteTheme
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteMapRouteThemeCopyWith<RouteMapRouteTheme> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteMapRouteThemeCopyWith<$Res> {
  factory $RouteMapRouteThemeCopyWith(
    RouteMapRouteTheme value,
    $Res Function(RouteMapRouteTheme) then,
  ) = _$RouteMapRouteThemeCopyWithImpl<$Res, RouteMapRouteTheme>;
  @useResult
  $Res call({
    double lineWidth,
    Color color,
    double? backLineWidth,
    Color? backLineColor,
  });
}

/// @nodoc
class _$RouteMapRouteThemeCopyWithImpl<$Res, $Val extends RouteMapRouteTheme>
    implements $RouteMapRouteThemeCopyWith<$Res> {
  _$RouteMapRouteThemeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteMapRouteTheme
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lineWidth = null,
    Object? color = null,
    Object? backLineWidth = freezed,
    Object? backLineColor = freezed,
  }) {
    return _then(
      _value.copyWith(
            lineWidth: null == lineWidth
                ? _value.lineWidth
                : lineWidth // ignore: cast_nullable_to_non_nullable
                      as double,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as Color,
            backLineWidth: freezed == backLineWidth
                ? _value.backLineWidth
                : backLineWidth // ignore: cast_nullable_to_non_nullable
                      as double?,
            backLineColor: freezed == backLineColor
                ? _value.backLineColor
                : backLineColor // ignore: cast_nullable_to_non_nullable
                      as Color?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RouteMapRouteThemeImplCopyWith<$Res>
    implements $RouteMapRouteThemeCopyWith<$Res> {
  factory _$$RouteMapRouteThemeImplCopyWith(
    _$RouteMapRouteThemeImpl value,
    $Res Function(_$RouteMapRouteThemeImpl) then,
  ) = __$$RouteMapRouteThemeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double lineWidth,
    Color color,
    double? backLineWidth,
    Color? backLineColor,
  });
}

/// @nodoc
class __$$RouteMapRouteThemeImplCopyWithImpl<$Res>
    extends _$RouteMapRouteThemeCopyWithImpl<$Res, _$RouteMapRouteThemeImpl>
    implements _$$RouteMapRouteThemeImplCopyWith<$Res> {
  __$$RouteMapRouteThemeImplCopyWithImpl(
    _$RouteMapRouteThemeImpl _value,
    $Res Function(_$RouteMapRouteThemeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RouteMapRouteTheme
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lineWidth = null,
    Object? color = null,
    Object? backLineWidth = freezed,
    Object? backLineColor = freezed,
  }) {
    return _then(
      _$RouteMapRouteThemeImpl(
        lineWidth: null == lineWidth
            ? _value.lineWidth
            : lineWidth // ignore: cast_nullable_to_non_nullable
                  as double,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as Color,
        backLineWidth: freezed == backLineWidth
            ? _value.backLineWidth
            : backLineWidth // ignore: cast_nullable_to_non_nullable
                  as double?,
        backLineColor: freezed == backLineColor
            ? _value.backLineColor
            : backLineColor // ignore: cast_nullable_to_non_nullable
                  as Color?,
      ),
    );
  }
}

/// @nodoc

class _$RouteMapRouteThemeImpl implements _RouteMapRouteTheme {
  const _$RouteMapRouteThemeImpl({
    required this.lineWidth,
    required this.color,
    this.backLineWidth,
    this.backLineColor,
  });

  @override
  final double lineWidth;
  @override
  final Color color;
  @override
  final double? backLineWidth;
  @override
  final Color? backLineColor;

  @override
  String toString() {
    return 'RouteMapRouteTheme(lineWidth: $lineWidth, color: $color, backLineWidth: $backLineWidth, backLineColor: $backLineColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteMapRouteThemeImpl &&
            (identical(other.lineWidth, lineWidth) ||
                other.lineWidth == lineWidth) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.backLineWidth, backLineWidth) ||
                other.backLineWidth == backLineWidth) &&
            (identical(other.backLineColor, backLineColor) ||
                other.backLineColor == backLineColor));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, lineWidth, color, backLineWidth, backLineColor);

  /// Create a copy of RouteMapRouteTheme
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteMapRouteThemeImplCopyWith<_$RouteMapRouteThemeImpl> get copyWith =>
      __$$RouteMapRouteThemeImplCopyWithImpl<_$RouteMapRouteThemeImpl>(
        this,
        _$identity,
      );
}

abstract class _RouteMapRouteTheme implements RouteMapRouteTheme {
  const factory _RouteMapRouteTheme({
    required final double lineWidth,
    required final Color color,
    final double? backLineWidth,
    final Color? backLineColor,
  }) = _$RouteMapRouteThemeImpl;

  @override
  double get lineWidth;
  @override
  Color get color;
  @override
  double? get backLineWidth;
  @override
  Color? get backLineColor;

  /// Create a copy of RouteMapRouteTheme
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteMapRouteThemeImplCopyWith<_$RouteMapRouteThemeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
