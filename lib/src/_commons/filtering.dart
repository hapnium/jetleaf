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

/// The order value for CORS filter execution.
///
/// This constant defines the execution order for CORS-related filters
/// within the application. A higher value indicates a lower priority,
/// meaning the CORS filter will execute later compared to filters with
/// lower order values. This is useful for ensuring that CORS checks are
/// applied after other filters have been processed.
const int CORS_FILTER_ORDER = 100_000_000_000_000_000;