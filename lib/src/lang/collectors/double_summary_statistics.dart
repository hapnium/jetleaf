/// A state object for collecting statistics such as count, min, max, sum, and
/// average for double values.
class DoubleSummaryStatistics {
  final int count;
  final double sum;
  final double min;
  final double max;
  final double average;

  const DoubleSummaryStatistics(
    this.count,
    this.sum,
    this.min,
    this.max,
    this.average,
  );

  @override
  String toString() {
    return 'DoubleSummaryStatistics{count=$count, sum=$sum, min=$min, max=$max, average=$average}';
  }
}