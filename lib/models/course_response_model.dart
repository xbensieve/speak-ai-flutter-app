class CourseResponseModel<T> {
  final int pageNumber;
  final int pageSize;
  final int totalRecords;
  final int totalPages;
  final List<T> data;

  CourseResponseModel({
    required this.pageNumber,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
    required this.data,
  });

  factory CourseResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return CourseResponseModel<T>(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalRecords: json['totalRecords'],
      totalPages: json['totalPages'],
      data: List<T>.from(json['data'].map((item) => fromJsonT(item))),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'totalRecords': totalRecords,
      'totalPages': totalPages,
      'data': data.map((item) => toJsonT(item)).toList(),
    };
  }
}
