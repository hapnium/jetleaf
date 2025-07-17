/// The order value for CORS filter execution.
///
/// This constant defines the execution order for CORS-related filters
/// within the application. A higher value indicates a lower priority,
/// meaning the CORS filter will execute later compared to filters with
/// lower order values. This is useful for ensuring that CORS checks are
/// applied after other filters have been processed.
const int CORS_FILTER_ORDER = 100_000_000_000_000_000;