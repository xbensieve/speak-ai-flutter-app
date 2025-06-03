import 'dart:core';

class QueryModel {
  late final int? pageNumber;
  late final int? pageSize;
  late final String? sortBy;
  late final bool? sortDescending;
  late final String? keyword;
  late final int? levelId;
  late final bool? isPremium;
  late final bool? isActive;

  QueryModel({
    this.pageNumber,
    this.pageSize,
    this.sortBy,
    this.sortDescending,
    this.keyword,
    this.levelId,
    this.isPremium,
    this.isActive,
  });
}
