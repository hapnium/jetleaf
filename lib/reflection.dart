/// {@template reflection_library}
/// 🔍 JetLeaf Reflection
/// 
/// A Dart reflection framework with annotation introspection and metadata modeling.
/// 
/// ---
/// 
/// ### 📦 Exports:
/// - [Class], [RuntimeClass], [FieldInfo], [MethodInfo], [ConstructorInfo]
/// - [ReflectableAnnotation], [AnnotationBuilder], [AnnotationFactory]
/// - [TypeDescriptor], [ClassContext]
/// 
/// Useful for dynamic frameworks like JSON, DI, ORM, and serialization.
/// {@endtemplate}
///
/// @author Evaristus Adimonyemma
/// @emailAddress evaristusadimonyemma@hapnium.com
/// @organization Hapnium
/// @website https://hapnium.com
library reflection;

export 'src/reflection/interfaces/accessible_object.dart';
export 'src/reflection/interfaces/annotated_element.dart';
export 'src/reflection/interfaces/annotation.dart';
export 'src/reflection/interfaces/executable.dart';
export 'src/reflection/interfaces/member.dart';
export 'src/reflection/interfaces/reflectable_annotation.dart';

export 'src/reflection/context/type_descriptor.dart';
export 'src/reflection/context/class_context.dart';

export 'src/reflection/mirrors/class_mirror.dart';
export 'src/reflection/mirrors/method_mirror.dart';
export 'src/reflection/mirrors/field_mirror.dart';
export 'src/reflection/mirrors/constructor_mirror.dart';
export 'src/reflection/mirrors/parameter_mirror.dart';

export 'src/reflection/models/constructor_info.dart';
export 'src/reflection/models/field_info.dart';
export 'src/reflection/models/method_info.dart';
export 'src/reflection/models/type_variable_info.dart';
export 'src/reflection/models/parameter_info.dart';
export 'src/reflection/models/handler_method.dart';

export 'src/reflection/class.dart';
export 'src/reflection/runtime_class.dart';
export 'src/reflection/exceptions.dart';
export 'src/reflection/reflection_utils.dart';