extension ListUtils<E> on List<E> {
  void addAllDistinct<T>(List<E> list, T Function(E) uniqueKeyExtractor) {
    for (var e in list) {
      final existed =
          any((i) => uniqueKeyExtractor(i) == uniqueKeyExtractor(e));
      if (!existed) {
        add(e);
      }
    }
  }
}
