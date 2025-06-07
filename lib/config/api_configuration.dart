class ApiConfig {
  static const String baseUrl = 'http://sai.runasp.net';
  static const String loginEndpoint = '/api/auth/login';
  static const String registerCustomerEndpoint =
      '/api/auth/register/customer';
  static const String loginGoogleEndpoint =
      '/api/auth/signin-google';
  static const String userInfoEndpoint = '/api/users';
  static const String coursesEndpoint =
      '/api/courses/paged';
  static const String topicsEndpoint = '/api/ai/start';
  static const String getCourseByIdEndpoint =
      '/api/courses/';
  static const String checkEnrolledCourseEndpoint =
      '/api/courses/users';
}
