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

/// {@template lang_library}
/// 🔡 JetLeaf Language & Utility Core
/// 
/// This library exposes extended Dart primitives, collections, optional types,
/// I/O streams, date/time utilities, math types, regex, and more.
/// 
/// ---
/// 
/// ### 🧩 Key Areas:
/// - Extended primitives and collections
/// - Custom numeric types (Integer, BigDecimal, etc.)
/// - I/O abstractions (InputStream, OutputStream, FileReader)
/// - Streams API similar to Java's Stream
/// - Date and time (LocalDateTime, ZonedDateTime)
/// 
/// {@endtemplate}
/// 
/// @author Evaristus Adimonyemma
/// @emailAddress evaristusadimonyemma@hapnium.com
/// @organization Hapnium
library;

export 'src/lang/byte/byte_array.dart';
export 'src/lang/byte/byte_stream.dart';
export 'src/lang/byte/byte.dart';

export 'src/lang/collections/array_list.dart';
export 'src/lang/collections/linked_list.dart';
export 'src/lang/collections/stack.dart';
export 'src/lang/collections/queue.dart';
export 'src/lang/collections/linked_queue.dart';
export 'src/lang/collections/linked_stack.dart';
export 'src/lang/collections/hash_map.dart';
export 'src/lang/collections/hash_set.dart';

export 'src/lang/collectors/collectors.dart';
export 'src/lang/collectors/collector.dart';

export 'src/lang/comparator/comparator.dart';

export 'src/lang/extensions/others/date_time.dart';
export 'src/lang/extensions/others/duration.dart';
export 'src/lang/extensions/others/dynamic.dart';
export 'src/lang/extensions/others/t.dart';
export 'src/lang/extensions/others/type.dart';

export 'src/lang/extensions/primitives/bool.dart';
export 'src/lang/extensions/primitives/double.dart';
export 'src/lang/extensions/primitives/int.dart';
export 'src/lang/extensions/primitives/iterable.dart';
export 'src/lang/extensions/primitives/list.dart';
export 'src/lang/extensions/primitives/map.dart';
export 'src/lang/extensions/primitives/num.dart';
export 'src/lang/extensions/primitives/set.dart';
export 'src/lang/extensions/primitives/string.dart';

export 'src/lang/io/input_stream/buffered_input_stream.dart';
export 'src/lang/io/input_stream/file_input_stream.dart';
export 'src/lang/io/input_stream/input_stream.dart';
export 'src/lang/io/input_stream/byte_array_input_stream.dart';
export 'src/lang/io/input_stream/input_stream_source.dart';

export 'src/lang/io/output_stream/buffered_output_stream.dart';
export 'src/lang/io/output_stream/byte_array_output_stream.dart';
export 'src/lang/io/output_stream/file_output_stream.dart';
export 'src/lang/io/output_stream/output_stream.dart';

export 'src/lang/io/reader/reader.dart';
export 'src/lang/io/reader/file_reader.dart';
export 'src/lang/io/reader/buffered_reader.dart';

export 'src/lang/io/writer/writer.dart';
export 'src/lang/io/writer/file_writer.dart';
export 'src/lang/io/writer/buffered_writer.dart';

export 'src/lang/io/base_stream/base_stream.dart';
export 'src/lang/io/base_stream/double/double_stream.dart';
export 'src/lang/io/base_stream/int/int_stream.dart';
export 'src/lang/io/base_stream/generic/generic_stream.dart';

export 'src/lang/io/print_stream/print_stream.dart';
export 'src/lang/io/print_stream/console_print_stream.dart';

export 'src/lang/io/auto_closeable.dart';
export 'src/lang/io/streaming.dart';
export 'src/lang/io/stream_builder.dart';
export 'src/lang/io/closeable.dart';
export 'src/lang/io/flushable.dart';

export 'src/lang/math/big_decimal.dart';
export 'src/lang/math/big_integer.dart';

export 'src/lang/primitives/integer.dart';
export 'src/lang/primitives/long.dart';
export 'src/lang/primitives/float.dart';
export 'src/lang/primitives/double.dart';
export 'src/lang/primitives/character.dart';
export 'src/lang/primitives/boolean.dart';
export 'src/lang/primitives/short.dart';

export 'src/lang/time/zoned_date_time.dart';
export 'src/lang/time/local_date_time.dart';
export 'src/lang/time/local_date.dart';
export 'src/lang/time/local_time.dart';
export 'src/lang/time/zone_id.dart';

export 'src/lang/synchronized/synchronized.dart';
export 'src/lang/synchronized/synchronized_lock.dart';

export 'src/lang/optional.dart';
export 'src/lang/string_builder.dart';
export 'src/lang/exceptions.dart';
export 'src/lang/instance.dart';
export 'src/lang/regex_utils.dart';
export 'src/lang/typedefs.dart';
export 'src/lang/try_with.dart';