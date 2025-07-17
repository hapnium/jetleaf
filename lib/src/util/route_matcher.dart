import 'ant_path_matcher.dart';

/// Contract for matching routes to patterns
abstract class RouteMatcher {
  Route parseRoute(String routeValue);
  bool isPattern(String route);
  String combine(String pattern1, String pattern2);
  bool match(String pattern, Route route);
  Map<String, String>? matchAndExtract(String pattern, Route route);
}

/// A parsed representation of a route
abstract class Route {
  String get value;
}

/// Simple implementation of RouteMatcher that delegates to PathMatcher
class SimpleRouteMatcher implements RouteMatcher {
  final PathMatcher _pathMatcher;

  SimpleRouteMatcher(this._pathMatcher);

  PathMatcher get pathMatcher => _pathMatcher;

  @override
  Route parseRoute(String routeValue) => _DefaultRoute(routeValue);

  @override
  bool isPattern(String route) => _pathMatcher.isPattern(route);

  @override
  String combine(String pattern1, String pattern2) => _pathMatcher.combine(pattern1, pattern2);

  @override
  bool match(String pattern, Route route) => _pathMatcher.match(pattern, route.value);

  @override
  Map<String, String>? matchAndExtract(String pattern, Route route) {
    if (!match(pattern, route)) return null;
    return _pathMatcher.extractUriTemplateVariables(pattern, route.value);
  }
}

class _DefaultRoute implements Route {
  @override
  final String value;

  _DefaultRoute(this.value);

  @override
  String toString() => value;
}