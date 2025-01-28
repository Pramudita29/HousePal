class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // Base URL of your backend (ensure this IP is correct and accessible)
  static const String baseUrl = "http://10.0.2.2:3000/api/";

  //*************Authentication Route***********
  static const String register = "auth/register"; // POST: /auth/register
  static const String login = "auth/login"; // POST: /auth/login

  //*************Helper Route***********
  static String getAllHelper = "${baseUrl}helper"; // GET: /helper
  static String getHelperById(String id) =>
      "${baseUrl}helper/$id"; // GET: /helper/:id
  static String updateHelper(String id) =>
      "${baseUrl}helper/$id"; // PUT: /helper/:id
  static String deleteHelper(String id) =>
      "${baseUrl}helper/$id"; // DELETE: /helper/:id
  static String markTaskAsCompleted(String taskId) =>
      "${baseUrl}helper/task/$taskId/complete"; // PATCH: /helper/task/:taskId/complete
  static const String getHelperDashboard =
      "${baseUrl}helper/dashboard"; // GET: /helper/dashboard
  static const String getCurrentHelper = "${baseUrl}helper/current"; // GET: /helper/current

  //*************Seeker Route***********
  static String getAllSeeker = "${baseUrl}seeker"; // GET: /seeker
  static String getSeekerById(String id) =>
      "${baseUrl}seeker/$id"; // GET: /seeker/:id
  static String updateSeeker(String id) =>
      "${baseUrl}seeker/$id"; // PUT: /seeker/:id
  static String deleteSeeker(String id) =>
      "${baseUrl}seeker/$id"; // DELETE: /seeker/:id
  static const String getCurrentSeeker = "${baseUrl}seeker/current"; // GET: /seeker/current

  //*************Image Upload Route***********
  static String uploadHelperImage =
      "${baseUrl}helper/uploadImage"; // POST: /helper/uploadImage
  static String uploadSeekerImage =
      "${baseUrl}seeker/uploadImage"; // POST: /seeker/uploadImage
  static String imageUrl(String imagePath) =>
      "${baseUrl}uploads/$imagePath"; // Base URL for images
}
