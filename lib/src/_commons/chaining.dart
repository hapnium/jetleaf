/// {@template next_chain_delay_seconds}
/// The delay duration (in seconds) before the next chain operation is executed.
///
/// This constant is typically used to control timing between retries,
/// reconnection attempts, or scheduled executions.
///
/// ### Example:
/// ```dart
/// await Future.delayed(Duration(seconds: NEXT_CHAIN_DELAYED_DURATION_IN_SECONDS));
/// ```
/// {@endtemplate}
const int NEXT_CHAIN_DELAYED_DURATION_IN_SECONDS = 10;

/// {@macro next_chain_delay_seconds}
///
/// Also available as a [Duration] object:
///
/// ### Example:
/// ```dart
/// await Future.delayed(NEXT_CHAIN_DELAYED_DURATION);
/// ```
const Duration NEXT_CHAIN_DELAYED_DURATION = Duration(seconds: NEXT_CHAIN_DELAYED_DURATION_IN_SECONDS);