/// A modular, enterprise-grade performance monitoring system for Dart applications.
///
/// This library provides core contracts, default implementations, and built-in
/// metric contributors to track application, system, runtime, class-level,
/// and bean-level metrics. It is designed for extensibility and low overhead.
library monitoring;

export 'src/monitoring/contrib/application_boot_metrics_contributor.dart';
export 'src/monitoring/contrib/async_metrics_contributor.dart';
export 'src/monitoring/contrib/event_loop_lag_monitor.dart';
export 'src/monitoring/contrib/gc_monitor.dart';
export 'src/monitoring/contrib/system_metrics_contributor.dart';

export 'src/monitoring/core/metric_contributor.dart';
export 'src/monitoring/core/metrics_registry.dart';
export 'src/monitoring/core/monitoring_service.dart';
export 'src/monitoring/core/performance_tracker.dart';

export 'src/monitoring/runtime/_runtime_monitoring.dart';
export 'src/monitoring/runtime/runtime_monitoring.dart';

export 'src/monitoring/timers/stopwatch_metric.dart';
export 'src/monitoring/timers/named_timer.dart';