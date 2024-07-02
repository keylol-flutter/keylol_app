extension ListUtils<E> on List<E> {
  void addAllDistinct<T>(List<E> list, T Function(E) uniqueKeyExtractor,
      {bool Function(E)? filter}) {
    for (var e in list) {
      if (filter != null && !filter(e)) {
        continue;
      }
      final existed =
          any((i) => uniqueKeyExtractor(i) == uniqueKeyExtractor(e));
      if (existed) {
        continue;
      }

      add(e);
    }
  }
}
