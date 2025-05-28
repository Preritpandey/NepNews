import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_portal/pages/Horoscope/horoscope_grid.dart';
import 'package:news_portal/widgets/article_search_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/get_article_controller.dart';
import '../../models/article_model.dart';
import '../../controllers/ads_controller.dart';
import '../../core/ScreenSizeConfig.dart';
import '../../resources/app_text.dart';
import '../../resources/text_heading.dart';
import '../../widgets/breaking_news_widget.dart';
import '../../widgets/forex_slideshow.dart';
import '../../widgets/trending_news_widget.dart';
import 'article_detail_page.dart';
import 'category_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AdController adController = Get.put(AdController());

  final GetArticleController articleController =
      Get.find<GetArticleController>();

  final RxBool isSearchExpanded = false.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeConfig.of(context);
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Obx(() => isSearchExpanded.value
            ? buildExpandedSearchBar(theme)
            : const SizedBox.shrink()),
        actions: [
          Obx(() => isSearchExpanded.value
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => _collapseSearch(),
                )
              : IconButton(
                  // icon: const Icon(Icons.search),
                  icon: ArticleSearchWidget(),
                  onPressed: () => expandSearch(),
                )),
        ],
      ),
      body: Stack(
        children: [
          // Main content with RefreshIndicator
          RefreshIndicator(
            onRefresh: () => _refreshData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: screenWidth * 0.95,
                    height: screenHeight * 0.085,
                    color: theme.colorScheme.background,
                    child: const ForexSlideshow(),
                  ),
                  ListTile(
                    leading: const TextHeading(text: 'Breaking News'),
                    trailing: GestureDetector(
                      onTap: () {
                        Get.to(() => CategoryPage());
                      },
                      child: AppText(
                        text: 'View all',
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: const BreakingNewsSlider(),
                  ),
                  ListTile(
                    leading: const TextHeading(text: 'Trending', fontSize: 15),
                    trailing: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage()),
                        );
                      },
                      child: AppText(
                        text: 'View all',
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.7,
                    child: TrendingNewsCard(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.to(() => const HoroscopeGridScreen());
                        },
                        icon: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/horoscope.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            "See Horoscope",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // Search Results Overlay
          Obx(() => isSearchExpanded.value &&
                  articleController.searchQuery.value.isNotEmpty
              ? _buildSearchOverlay(theme, screenHeight)
              : const SizedBox.shrink()),

          // Tap-outside-to-close overlay for search
          Obx(() {
            return isSearchExpanded.value
                ? Positioned.fill(
                    child: GestureDetector(
                      onTap: () => _collapseSearch(),
                      child: Container(color: Colors.transparent),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget buildExpandedSearchBar(ThemeData theme) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: searchController,
        autofocus: true,
        onChanged: (value) => articleController.searchQuery.value = value,
        decoration: InputDecoration(
          hintText: 'Search articles...',
          prefixIcon: const Icon(Icons.search, size: 20),
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
        ),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildSearchOverlay(ThemeData theme, double screenHeight) {
    return Positioned(
      top: kToolbarHeight + MediaQuery.of(Get.context!).padding.top,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Search header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Search Results',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Obx(() => Text(
                        '${articleController.searchResults.length} found',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      )),
                ],
              ),
            ),
            // Search results
            Expanded(
              child: Obx(() => buildSearchResults(theme)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchResults(ThemeData theme) {
    //  searching indicator
    if (articleController.isSearching.value) {
      return const Center(child: CircularProgressIndicator());
    }

    //  no results message
    if (articleController.searchResults.isEmpty &&
        articleController.searchQuery.value.isNotEmpty) {
      return buildNoResultsMessage(theme);
    }

    //  search results in a ListView
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articleController.searchResults.length,
      itemBuilder: (context, index) {
        final article = articleController.searchResults[index];
        return buildArticleCard(context, article, theme);
      },
    );
  }

  Widget buildNoResultsMessage(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 80,
            color: theme.colorScheme.error.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No articles found for "${articleController.searchQuery.value}"',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Try using different keywords',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildArticleCard(
      BuildContext context, ArticleModel article, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _collapseSearch(); // Close search when navigating
          Get.to(() => ArticleDetailPage(articleId: article.id));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: article.avatar.isNotEmpty
                    ? Image.network(
                        article.avatar,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 80,
                            width: 80,
                            color: theme.colorScheme.primaryContainer,
                            child: Icon(
                              Icons.image_not_supported,
                              color: theme.colorScheme.onPrimaryContainer,
                              size: 24,
                            ),
                          );
                        },
                      )
                    : Container(
                        height: 80,
                        width: 80,
                        color: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.newspaper,
                          color: theme.colorScheme.onPrimaryContainer,
                          size: 24,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              // Article content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        article.category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Title
                    Text(
                      article.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Content preview
                    Text(
                      _stripHtmlTags(article.content),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Author and date
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            article.author.name,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(article.publishDate ?? article.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void expandSearch() {
    isSearchExpanded.value = true;
  }

  void _collapseSearch() {
    isSearchExpanded.value = false;
    searchController.clear();
    articleController.clearSearch();
  }

  // Helper function to strip HTML tags from content
  String _stripHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  // Helper function to format date
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  // Method to refresh data when pulling down
  Future<void> _refreshData() async {
    articleController.refreshArticles();
    return Future.value();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Error',
        'Could not launch $url',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
