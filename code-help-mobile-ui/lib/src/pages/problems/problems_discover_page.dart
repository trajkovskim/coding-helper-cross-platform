import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:coding_helper_cross_platform/src/components/common/SearchSettings.dart';
import 'package:coding_helper_cross_platform/src/util.dart';
import 'package:flutter/material.dart';

import '../../components/common/grid_view.dart';
import '../../components/common/list_options.dart';
import '../../components/common/search_input.dart';
import '../../components/common/vertical_list_view.dart';
import '../../context/index.dart';
import '../../i18n/i18n.dart';
import '../../services/codehelp/index.dart';

class ProblemsDiscoverPage extends StatefulWidget {
  const ProblemsDiscoverPage({super.key});

  @override
  State<ProblemsDiscoverPage> createState() => _ProblemsDiscoverPageState();
}

class _ProblemsDiscoverPageState extends State<ProblemsDiscoverPage> {
  final problemsService = const ProblemsService();

  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  ViewProfile view = ViewProfile.LIST;
  bool initialized = false;

  List<String> filterOptions = [];
  List<String> sortOptions = [];

  final filterOptionsMap = {
    'Difficulty': ['EASY', 'MEDIUM', 'HARD'],
  };

  final sortOptionsMap = {
    'Difficulty': ['ascending', 'descending']
  };

  void handleTapSearch() {
    if (searchController.text.isEmpty) {
      return;
    }

    String command = createCommand(
      Command.SEARCH,
      searchController.text.trim(),
    );
    filterOptions.removeWhere((element) => element == command);
    setState(() {
      filterOptions.add(command);
      showSearch = false;
    });
    searchController.clear();
  }

  void handleClearSearch() {
    setState(() {
      showSearch = false;
    });
  }

  void handleRemoveFilterOption(String option) {
    setState(() {
      filterOptions.remove(option);
    });
  }

  void handleRemoveSortOption(String option) {
    setState(() {
      sortOptions.remove(option);
    });
  }

  void handleFilterSubmit(List<String> commands) {
    setState(() {
      filterOptions.removeWhere((element) => commands.contains(element));
      filterOptions.addAll(commands);
    });
  }

  void handleSortSubmit(List<String> commands) {
    setState(() {
      sortOptions.removeWhere((element) => commands.contains(element));
      sortOptions.addAll(commands);
    });
  }

  void handleViewModeChange(ViewProfile newViewMode) {
    setState(() {
      view = newViewMode;
    });
  }

  void init(BuildContext context) {
    final params = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (params?['category'] != null && !initialized) {
      filterOptions.add('category: ${params!['category']}');
    }

    problemsService.getCategories().then((categories) {
      final mapped = categories.map((e) => e.name).toList();
      filterOptionsMap.putIfAbsent("Category", () => mapped);
    });

    initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    init(context);
    
    final t = getTranslation(context, 'problems.discover');

    final filters = transformFilterOptionsListToMap(filterOptions);
    final sorters = transformSortOptions(sortOptions).map((e) => 'problem.$e').toList();

    return Scaffold(
      appBar: AppBar(
        title:
            !showSearch
                ? Text(t('title'))
                : SearchInput(
                  controller: searchController,
                  onClear: handleClearSearch,
                  onSubmit: handleTapSearch,
                ),
        actions: [
          IconButton(
            onPressed: () {
              if (!showSearch) {
                setState(() {
                  showSearch = true;
                });
              } else {
                handleTapSearch();
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder(
        future: problemsService.getProblemEntries(
          name: filters['name'],
          category: filters['category'],
          difficulty:
              filters['difficulty'] != null
                  ? Difficulty.valueOf(filters['difficulty']!.toUpperCase())
                  : null,
          sortBy: sorters,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            throw ErrorCode.PROBLEM_DISCOVER;
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final entries = snapshot.data!;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SearchSettingsRow(
                    filterOptions: filterOptionsMap,
                    sortOptions: sortOptionsMap,
                    handleFilterSubmit: handleFilterSubmit,
                    handleSortSubmit: handleSortSubmit,
                    handleViewModeChange: handleViewModeChange,
                    viewMode: view,
                  ),
                  SizedBox.fromSize(size: const Size.fromHeight(15)),
                  ListOptions(
                    options: filterOptions,
                    onRemove: handleRemoveFilterOption,
                  ),
                  ListOptions(
                    options: sortOptions,
                    onRemove: handleRemoveSortOption,
                  ),
                  SizedBox.fromSize(size: const Size.fromHeight(15)),
                  if (view == ViewProfile.LIST)
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: VerticalListView(
                        children:
                            entries
                                .map(
                                  (entry) => ListItem(
                                    title: entry.name,
                                    onTap:
                                        () => navigator.pushNamed(
                                          '/problem-overview',
                                          arguments: {
                                            'id': entry.id.toString(),
                                          },
                                        ),
                                    trailing: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          entry.difficulty.name,
                                          style: TextStyle(
                                            color: getDifficultyColor(
                                              entry.difficulty,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          getSubmissionStatusText(entry),
                                          style: TextStyle(
                                            color: getSubmissionStatusColor(
                                              entry,
                                            ),
                                          ),
                                        ),
                                        Text(entry.category.name),
                                      ],
                                    ),
                                    subtitle: entry.description,
                                    image: const CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        "https://dotnettutorials.net/wp-content/uploads/2020/10/word-image-4.png",
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  if (view == ViewProfile.GRID)
                    CustomGridView(
                      children:
                          entries
                              .map(
                                (entry) => GridItem(
                                  title: entry.name,
                                  onTap:
                                      () => navigator.pushNamed(
                                        '/problem-overview',
                                        arguments: {'id': entry.id.toString()},
                                      ),
                                  subtitle: entry.description,
                                  image: const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      "https://dotnettutorials.net/wp-content/uploads/2020/10/word-image-4.png",
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
