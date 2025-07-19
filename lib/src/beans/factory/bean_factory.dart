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

import 'package:jetleaf/lang.dart';
import 'package:jetleaf/reflection.dart';

import '../annotations/throws.dart';
import '../exceptions.dart';
import 'object_property.dart';

abstract interface class BeanFactory {
  @Throws([BeansException])
  Object getBean();

  @Throws([BeansException])
  T getBeanFromNameAndRequiredType<T>(String name, Class<T> requiredType);

  @Throws([BeansException])
  T getBeanFromRequiredType<T>(Class<T> requiredType);

  @Throws([BeansException])
  Object getBeanInstance(String name, [List<Object>? positionalArgs, Map<String, Object>? namedArgs]);

  @Throws([BeansException])
  Object getBeanInstanceFromRequiredType<T>(Class<T> requiredType, [List<Object>? positionalArgs, Map<String, Object>? namedArgs]);

  @Throws([BeansException])
  ObjectProvider<T> getBeanProvider<T>(Class<T> requiredType);

  Boolean containsBean(String name);

  @Throws([NoSuchBeanDefinitionException])
  Boolean isSingleton(String name);

  @Throws([NoSuchBeanDefinitionException])
  Boolean isPrototype(String name);

  @Throws([NoSuchBeanDefinitionException])
  Boolean isTypeMatch(String name, Class type);

  @Throws([NoSuchBeanDefinitionException])
  Class<dynamic> getType(String name);

  @Throws([NoSuchBeanDefinitionException])
  Class<dynamic> getTypeOrInitialize(String name, [Boolean allowFactoryBeanInit = Boolean.FALSE]);

  ArrayList<String> getAliases(String name);
}