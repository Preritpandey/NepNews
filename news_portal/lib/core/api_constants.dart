const String ipAddress = "nepnewsbackend.onrender.com";

const String baseUrl = 'https://$ipAddress';

String signUpUrl = "$baseUrl/api/auth/register";
String loginUrl = "$baseUrl/api/auth/login";
String articleUrl = "$baseUrl/api/articles";
String approveArticleUrl = "$baseUrl/api/articles/publish";
String articleStatusUrl = "$baseUrl/api/articles/editor/drafts";
String getAdsUrl = "$baseUrl/ad";
String horoscopeUrl = "$baseUrl/api/horoscope";