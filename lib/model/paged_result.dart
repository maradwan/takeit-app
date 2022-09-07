class PagedResult<T, K> {
  List<T> content;
  K? lastEvaluatedKey;

  PagedResult(
    this.content,
    this.lastEvaluatedKey,
  );
}
