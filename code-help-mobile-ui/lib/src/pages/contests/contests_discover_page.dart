import 'package:coding_helper_api/coding_helper_api.dart';
import 'package:coding_helper_cross_platform/src/components/common/SearchSettings.dart';
import 'package:flutter/material.dart';

import '../../components/common/grid_view.dart';
import '../../components/common/list_options.dart';
import '../../components/common/modal.dart';
import '../../components/common/search_input.dart';
import '../../components/common/vertical_list_view.dart';
import '../../context/index.dart';
import '../../i18n/i18n.dart';
import '../../services/codehelp/index.dart';

class ContestsDiscoverPage extends StatefulWidget {

  const ContestsDiscoverPage({super.key});

  @override
  State<ContestsDiscoverPage> createState() => _ContestsDiscoverPageState();
}

class _ContestsDiscoverPageState extends State<ContestsDiscoverPage> {
  final contestsService = const ContestsService();

  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  bool init = false;
  bool loading = false;
  ViewProfile view = ViewProfile.LIST;

  final Map<String, List<String>> filterOptionsMap = {
    'status': ['OPEN', 'STARTED', 'CLOSED'],
  };

  final Map<String, List<String>> sortOptionsMap = {
    'Start Date': ['Ascending', 'Descending'],
    'Status': ['Ascending', 'Descending'],
  };

  List<String> filterOptions = [];
  List<String> sortOptions = [];

  void handleTapSearch() {
    if (searchController.text.isEmpty) {
      return;
    }

    String command =
      createCommand(Command.SEARCH, 'Search: ${searchController.text.trim()}');
    filterOptions.removeWhere((element) => element.startsWith("Search: "));
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

  void handleRemoveOption(List<String> options, String option) {
    setState(() {
      options.remove(option);
    });
  }

  void handleSubmit(List<String> options, List<String> commands) {
    setState(() {
      options.removeWhere((element) => commands.contains(element));
      options.addAll(commands);
    });
  }

  void handleViewModeChange(ViewProfile newViewMode) {
    setState(() {
      view = newViewMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final t = getTranslation(context, 'contests');
    final tGlobal = getTranslation(context);

    final filters = transformFilterOptionsListToMap(filterOptions);
    final sorters = transformSortOptions(sortOptions).map((e) => 'contest.$e').toList();

    return Scaffold(
      appBar: AppBar(
        title: !showSearch
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
          future: contestsService.getContestEntries(
              name: filters['search'],
              status: filters['status'] != null
                  ? ContestStatus.valueOf(filters['status']!.toUpperCase())
                  : null,
              sortBy: sorters),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              throw ErrorCode.CONTESTS_DISCOVER;
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
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
                      handleFilterSubmit: (options) => handleSubmit(filterOptions, options),
                      handleSortSubmit: (options) => handleSubmit(sortOptions, options),
                      handleViewModeChange: handleViewModeChange,
                      viewMode: view,
                    ),
                    SizedBox.fromSize(size: const Size.fromHeight(15)),
                    ListOptions(
                      options: filterOptions,
                      onRemove: (option) => handleRemoveOption(filterOptions, option),
                    ),
                    ListOptions(
                      options: sortOptions,
                      onRemove: (option) => handleRemoveOption(sortOptions, option),
                    ),
                    SizedBox.fromSize(size: const Size.fromHeight(15)),
                    if (view == ViewProfile.LIST)
                      VerticalListView(
                        children: entries
                            .map(
                              (entry) => ListItem(
                                title: entry.name,
                                image: Icon(Icons.hourglass_bottom),
                                onTap: () => navigator.pushNamed(
                                  '/contest-overview',
                                  arguments: {'id': entry.id.toString()},
                                ),
                                subtitle:
                                    '${t('duration')}: ${entry.duration}\n${t('startsOn')}: ${entry.startDate.toLocal()}\n${t('status')}: ${tGlobal('contestStatus.${entry.status}')}',
                              ),
                            )
                            .toList(),
                      ),
                    if (view == ViewProfile.GRID)
                      CustomGridView(
                        children: entries
                            .map(
                              (entry) => GridItem(
                                title: entry.name,
                                onTap: () => navigator.pushNamed(
                                  '/contest-overview',
                                  arguments: {'id': entry.id.toString()},
                                ),
                                subtitle:
                                '${t('duration')}: ${entry.duration}\n${t('startsOn')}: ${entry.startDate.toLocal()}\n${t('status')}: ${tGlobal('contestStatus.${entry.status}')}',
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
