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
    'language': ['java', 'javascript'],
    'status': ['OPEN', 'STARTED', 'CLOSED'],
  };

  final Map<String, List<String>> sortOptionsMap = {
    'Start date': ['ascending', 'descending'],
    'Status': ['ascending', 'descending'],
  };

  List<String> filterOptions = [];
  List<String> sortOptions = [];

  void handleTapSearch() {
    if (searchController.text.isEmpty) {
      return;
    }

    String command =
        createCommand(Command.SEARCH, searchController.text.trim());
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

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final t = getTranslation(context, 'contests');

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
          future: contestsService.getContestEntries(),
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
                      handleFilterSubmit: handleFilterSubmit,
                      handleSortSubmit: handleSortSubmit,
                      handleViewModeChange: handleViewModeChange,
                      viewMode: view,
                    ),
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
                      VerticalListView(
                        children: entries
                            .map(
                              (entry) => ListItem(
                                title: entry.name,
                                onTap: () => navigator.pushNamed(
                                  '/contest-overview',
                                  arguments: {'id': entry.id.toString()},
                                ),
                                subtitle:
                                    '${t('duration')}: ${entry.duration} ${t('startsOn')}: ${entry.startDate} ${t('status')}: ${entry.status}',
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
                                    '${t('duration')}: ${entry.duration} ${t('startsOn')}: ${entry.startDate} ${t('status')}: ${entry.status}',
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
