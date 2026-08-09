extension IterableExtensions<T> on Iterable<T> {
  T? get firstOrNull => isNotEmpty ? first : null;
}