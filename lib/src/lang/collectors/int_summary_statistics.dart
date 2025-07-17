/// A state object for collecting statistics such as count, min, max, sum, and
/// average for integer values.
class IntSummaryStatistics {
  final int count;
  final int sum;
  final int min;
  final int max;
  final double average;

  const IntSummaryStatistics(
    this.count,
    this.sum,
    this.min,
    this.max,
    this.average,
  );

  @override
  String toString() {
    return 'IntSummaryStatistics{count=$count, sum=$sum, min=$min, max=$max, average=$average}';
  }
}