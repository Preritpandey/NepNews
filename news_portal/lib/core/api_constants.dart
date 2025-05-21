String ipAddress = "192.168.1.105";

// const String ipAddress = "192.168.172.148"; //phone

// String ipAddress = "localhost";
String baseUrl = 'http://$ipAddress:8080';
String signUpUrl = "$baseUrl/api/auth/register";
String loginUrl = "$baseUrl/api/auth/login";
String articleUrl = "$baseUrl/api/articles";
String approveArticleUrl = "$baseUrl/api/articles/publish";
String articleStatusUrl = "$baseUrl/api/articles/editor/drafts";

String getAdsUrl = "$baseUrl/ad";
