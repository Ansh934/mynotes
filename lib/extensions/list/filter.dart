extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) {
    return map<List<T>>(
      (items) => items.where(where).toList(),
    );
  }
}
