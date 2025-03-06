class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  static const String baseUrl = "http://192.168.1.68:3000/api/";


  //************* Authentication Routes ***********
  static const String register = "${baseUrl}auth/register"; // POST
  static const String login = "${baseUrl}auth/login"; // POST
  static const String getCurrentUser = "${baseUrl}auth/user"; // GET
  static const String getMe = "${baseUrl}auth/me"; // GET
  static const String updateProfile = "${baseUrl}auth/update"; // PUT

  //************* Helper Routes ***********
  static const String getAllHelper = "${baseUrl}helper"; // GET
  static String getHelperById(String id) => "${baseUrl}helper/$id"; // GET
  static String updateHelper(String id) => "${baseUrl}helper/$id"; // PUT
  static String deleteHelper(String id) => "${baseUrl}helper/$id"; // DELETE
  static String markTaskAsCompleted(String taskId) =>
      "${baseUrl}helper/task/$taskId/complete"; // PATCH
  static const String getHelperDashboard = "${baseUrl}helper/dashboard"; // GET
  static const String uploadHelperImage =
      "${baseUrl}helper/uploadImage"; // POST
  static const String getSavedJobs = "${baseUrl}helper/saved-jobs"; // GET
  static String saveJob(String jobId) =>
      "${baseUrl}helper/saved-jobs/$jobId"; // POST
  static String removeSavedJob(String jobId) =>
      "${baseUrl}helper/saved-jobs/$jobId"; // DELETE
  static const String getRecommendedJobs =
      "${baseUrl}helper/recommended-jobs"; // GET
  static const String getHelperApplicationHistory =
      "${baseUrl}helper/application-history"; // GET

  //************* Seeker Routes ***********
  static const String getAllSeeker = "${baseUrl}seeker"; // GET
  static String getSeekerById(String id) => "${baseUrl}seeker/$id"; // GET
  static String updateSeeker(String id) => "${baseUrl}seeker/$id"; // PUT
  static String deleteSeeker(String id) => "${baseUrl}seeker/$id"; // DELETE
  static const String uploadSeekerImage =
      "${baseUrl}seeker/uploadImage"; // POST
  static const String getAllApplications =
      "${baseUrl}seeker/all-applications"; // GET

  //************* Image URL ***********
  static String imageUrl(String imagePath) => "$baseUrl$imagePath"; // GET

  //************* Job Routes ***********
  static const String createJob = "${baseUrl}jobs"; // POST
  static const String getAllJobs = "${baseUrl}jobs"; // GET
  static String getJobById(String id) => "${baseUrl}jobs/$id"; // GET
  static String updateJob(String id) => "${baseUrl}jobs/$id"; // PUT
  static String deleteJob(String id) => "${baseUrl}jobs/$id"; // DELETE
  static const String filterJobs = "${baseUrl}jobs/filter"; // GET
  static const String getPublicJobs = "${baseUrl}jobs/public"; // GET
  static String getJobApplications(String id) =>
      "${baseUrl}jobs/$id/applications"; // GET

  //************* Job Application Routes ***********
  static String applyForJob(String jobId) =>
      "${baseUrl}job-applications/$jobId/apply"; // POST
  static String getApplicationsForJob(String jobId) =>
      "${baseUrl}job-applications/$jobId/applications"; // GET
  static String updateApplicationStatus(String jobId, String applicationId) =>
      "${baseUrl}job-applications/$jobId/applications/$applicationId/status"; // PUT
  static const String getJobApplicationHistory =
      "${baseUrl}job-applications/history"; // GET
  static String deleteApplication(String jobId, String applicationId) =>
      "${baseUrl}job-applications/$jobId/applications/$applicationId"; // DELETE
  static String rescheduleApplication(String jobId) =>
      "${baseUrl}job-applications/$jobId/reschedule"; // POST

  //************* Notification Routes ***********
  static const String getNotifications = "${baseUrl}notifications"; // GET
  static const String markAllNotificationsAsRead =
      "${baseUrl}notifications/mark-all-as-read"; // PATCH
  static const String addNotification = "${baseUrl}notifications/add"; // POST

  //************* Task Routes ***********
  static const String createTask = "${baseUrl}tasks/create"; // POST
  static String getHelperTasks(String helperEmail) =>
      "${baseUrl}tasks/helper/$helperEmail"; // GET
  static String updateTaskStatus(String taskId) =>
      "${baseUrl}tasks/$taskId/status"; // PUT
  static const String getSeekerBookings = "${baseUrl}tasks/seeker"; // GET
  static const String createCheckoutSession =
      "${baseUrl}create-checkout-session"; // POST

  //************* Review Routes ***********
  static const String createReview = "${baseUrl}review/create"; // POST
  static String getHelperReviews(String helperId) =>
      "${baseUrl}review/helper/$helperId"; // GET
  static String getSeekerReviews(String seekerId) =>
      "${baseUrl}review/seeker/$seekerId"; // GET
}
