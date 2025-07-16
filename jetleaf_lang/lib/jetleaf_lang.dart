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

export 'src/collections/array_list.dart';
export 'src/collections/linked_list.dart';
export 'src/collections/stack.dart';
export 'src/collections/queue.dart';
export 'src/collections/linked_queue.dart';
export 'src/collections/linked_stack.dart';
export 'src/collections/hash_map.dart';
export 'src/collections/hash_set.dart';

export 'src/collectors/collectors.dart';
export 'src/collectors/collector.dart';

export 'src/extensions/others/date_time.dart';
export 'src/extensions/others/duration.dart';
export 'src/extensions/others/dynamic.dart';
export 'src/extensions/others/t.dart';
export 'src/extensions/others/type.dart';

export 'src/extensions/primitives/bool.dart';
export 'src/extensions/primitives/double.dart';
export 'src/extensions/primitives/int.dart';
export 'src/extensions/primitives/iterable.dart';
export 'src/extensions/primitives/list.dart';
export 'src/extensions/primitives/map.dart';
export 'src/extensions/primitives/num.dart';
export 'src/extensions/primitives/set.dart';
export 'src/extensions/primitives/string.dart';

export 'src/byte/byte_array.dart';
export 'src/byte/byte_stream.dart';
export 'src/byte/byte.dart';

export 'src/io/input_stream/buffered_input_stream.dart';
export 'src/io/input_stream/file_input_stream.dart';
export 'src/io/input_stream/input_stream.dart';
export 'src/io/input_stream/byte_array_input_stream.dart';

export 'src/io/output_stream/buffered_output_stream.dart';
export 'src/io/output_stream/byte_array_output_stream.dart';
export 'src/io/output_stream/file_output_stream.dart';
export 'src/io/output_stream/output_stream.dart';

export 'src/io/reader/reader.dart';
export 'src/io/reader/file_reader.dart';
export 'src/io/reader/buffered_reader.dart';

export 'src/io/writer/writer.dart';
export 'src/io/writer/file_writer.dart';
export 'src/io/writer/buffered_writer.dart';

export 'src/io/base_stream/base_stream.dart';
export 'src/io/base_stream/double/double_stream.dart';
export 'src/io/base_stream/int/int_stream.dart';
export 'src/io/base_stream/generic/generic_stream.dart';

export 'src/io/print_stream/print_stream.dart';
export 'src/io/print_stream/console_print_stream.dart';

export 'src/io/auto_closeable.dart';
export 'src/io/streaming.dart';
export 'src/io/stream_builder.dart';

export 'src/io/closeable.dart';
export 'src/io/flushable.dart';

export 'src/math/big_decimal.dart';
export 'src/math/big_integer.dart';

export 'src/primitives/integer.dart';
export 'src/primitives/long.dart';
export 'src/primitives/float.dart';
export 'src/primitives/double.dart';
export 'src/primitives/character.dart';
export 'src/primitives/boolean.dart';
export 'src/primitives/short.dart';

export 'src/time/zoned_date_time.dart';
export 'src/time/local_date_time.dart';
export 'src/time/local_date.dart';
export 'src/time/local_time.dart';
export 'src/time/zone_id.dart';

export 'src/optional.dart';
export 'src/string_builder.dart';
export 'src/exceptions.dart';
export 'src/instance.dart';
export 'src/regex_utils.dart';
export 'src/typedefs.dart';