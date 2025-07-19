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

// import 'package:jetleaf/reflection.dart';

// import '../annotations/lazy.dart';
// import '../annotations/primary.dart';
// import '../annotations/scope.dart';

// class BeanDefinition<BeanType> {
//   /// The unique name of the bean in the context.
//   final String name;

//   /// The class of the bean being defined.
//   final Class<BeanType> beanClass;

//   /// The lifecycle scope of the bean (e.g., singleton, prototype).
//   ///
//   /// Default is [BeanScope.SINGLETON].
//   final Scope scope;

//   /// Whether the bean should be lazily initialized.
//   ///
//   /// Lazy beans are only instantiated when first accessed.
//   final Lazy? lazy;

//   /// Whether this bean is the primary candidate when multiple beans match a type.
//   final Primary? primary;

//   /// Alternate names for the bean that can be used for resolution.
//   final List<String> aliases;
// }