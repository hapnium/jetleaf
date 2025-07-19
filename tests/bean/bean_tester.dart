/// ---------------------------------------------------------------------------
/// 🍃 JetLeaf Framework - https://jetleaf.hapnium.com
///
/// Copyright © 2025 Hapnium & JetLeaf Contributors. All rights reserved.
///
/// This source file is part of the JetLeaf Framework and is protected
/// under copyright law. You may not copy, modify, or distribute this file
/// except in compliance with the JetLeaf license.
///
/// For licensing terms, see the LICENSE file in the root of this project.
/// ---------------------------------------------------------------------------
/// 
/// 🔧 Powered by Hapnium — the Dart backend engine 🍃

// wild_bean_test.dart

class SuperClass {
  String inherited = 'from superclass';
  void inheritedMethod() => print('SuperClass');
}

mixin MixinA {
  String mixinField = 'MixinA';
  void mixinMethod() => print('MixinA method');
}

mixin MixinB on SuperClass {
  void mixinBMethod() => print('MixinB with SuperClass constraint');
}

enum Status { active, inactive, pending }

abstract class AbstractThing {
  void doSomething();
  int calculate(int a, int b);
}

class WildBean<T extends num> extends SuperClass with MixinA, MixinB implements AbstractThing {
  /// Fields
  static const String staticConst = 'STATIC_CONST';
  static final DateTime staticFinal = DateTime.now();
  final String id;
  late final String lateFinal;
  late String lateVar;
  T? genericValue;
  List<String> names = [];
  Map<String, dynamic> settings = {};
  Set<int> ids = {};

  /// Named constructors
  WildBean(this.id);
  WildBean.empty() : id = 'empty';
  WildBean.withGeneric(this.id, this.genericValue);
  WildBean.named({required this.id});
  WildBean.multiple(this.id, {this.genericValue});

  /// Factory constructor
  factory WildBean.fromJson(Map<String, dynamic> json) {
    final bean = WildBean(json['id'] ?? 'unknown');
    bean.genericValue = json['genericValue'] as T?;
    return bean as WildBean<T>;
  }

  /// Redirecting constructor
  WildBean.redirect(String id) : this(id);

  /// Methods
  void printStatus([Status? status = Status.active]) {
    print('Status: \$status');
  }

  String sayHello(String name, {bool excited = false}) {
    return excited ? 'Hello, \$name!' : 'Hello, \$name';
  }

  void noArgs() {}
  int add(int a, int b) => a + b;
  void multipleArgs(int a, String b, {double? c, bool? flag}) {}

  Future<void> asyncMethod() async {
    await Future.delayed(Duration(milliseconds: 10));
  }

  Stream<String> streamMethod() async* {
    yield 'streamed';
  }

  /// Operator overloads
  WildBean operator +(WildBean other) => this;
  bool operator ==(Object other) => other is WildBean && other.id == id;
  int get hashCode => id.hashCode;

  /// Callable
  String call(String input) => 'called with \$input';

  /// Generic method
  U genericMethod<U>(U value) => value;

  /// Extension fields (simulated via static access)
  static void staticHelper() => print('static helper');

  /// Overrides from abstract class
  @override
  void doSomething() {
    print('doing something');
  }

  @override
  int calculate(int a, int b) => a + b;

  /// Init logic
  void initialize() {
    lateVar = 'initialized';
    lateFinal = 'finalized';
  }

  /// Tear-off
  Function get printId => () => print(id);
}

/// Extension on WildBean
extension WildBeanExtension on WildBean {
  String get extended => 'extended-\$id';
  void log() => print('log: \$id');
}

/// Enum test usage
class EnumUser {
  final Status status;
  EnumUser(this.status);
  bool get isActive => status == Status.active;
}

/// Deeply nested generic class
class Container<A, B extends List<A>, C extends Map<A, B>> {
  final A first;
  final B second;
  final C third;
  Container(this.first, this.second, this.third);
}

void run() {
  final container = Container<int, List<int>, Map<int, List<int>>>(1, [1, 2, 3], {1: [1, 2, 3]});
  print(container);
}

/// Using typedefs
typedef IntFunction = int Function(int);
typedef GenericTransformer<T> = T Function(T);

class TypedefUser {
  IntFunction doubler = (x) => x * 2;
  GenericTransformer<String> capitalize = (s) => s.toUpperCase();
}

/// Class using dynamic and Function
class DynamicFunctionUser {
  dynamic anything;
  Function doAnything = () => print('did anything');
}

/// Function with default functions
void functionWithFunctionParam(void Function(String) callback) {
  callback('called');
}