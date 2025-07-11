class ApiConfig {
  static const String baseUrl = 'http://sai.runasp.net';
  static const String loginEndpoint = '/api/auth/login';
  static const String registerCustomerEndpoint =
      '/api/auth/register/customer';
  static const String confirmOtpEndpoint =
      '/api/auth/verify/otp';
  static const String confirmEmailEndpoint =
      '/api/emails/verify';
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
  static const String enrollCourseEndpoint = '/api/courses';
  static const String getEnrolledCourseTopicEndpoint =
      '/api/courses/enrollments/';
  static const String submitAnswerEndpoint =
      '/api/courses/exercises/';
  static const String getEnrolledCoursesEndpoint =
      '/api/courses/user';
  static const String checkPremiumEndpoint =
      '/api/premium/check-access';
  static const String createOrderEndpoint =
      '/api/premium/upgrade';
  static const String createPaymentEndpoint =
      '/api/payments/requests';
  static const String handlePaymentResponseEndpoint =
      '/api/payments/handle-response';
  static const String confirmPaymentEndpoint =
      '/api/premium/confirm-upgrade';
}
