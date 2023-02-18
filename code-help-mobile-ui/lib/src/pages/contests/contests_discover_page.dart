import 'package:coding_helper_cross_platform/src/components/common/SearchSettings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  View view = View.LIST;

  List<String> options = [];

  void handleTapSearch() {
    if (searchController.text.isEmpty) {
      return;
    }

    String command =
        createCommand(Command.SEARCH, searchController.text.trim());
    setState(() {
      options.add(command);
      showSearch = false;
    });
    searchController.clear();
  }

  void handleClearSearch() {
    setState(() {
      showSearch = false;
    });
  }

  void handleRemoveOption(int index) {
    setState(() {
      options.removeAt(index);
    });
  }

  void showFiltersModal(BuildContext context) async {
    final t = getTranslation(context, 'modal');

    final Map<String, String?>? values = await showModalBottomSheet(
      context: context,
      builder: (context) => Modal(
        options: const {
          'language': ['java', 'javascript']
        },
        submitButton: t('filter'),
      ),
    );

    if (values != null) {
      final commands = values.entries
          .map(
            (entry) => createCommand(
              Command.FILTER,
              '${entry.key}-${entry.value}',
            ),
          )
          .toList();
      setState(() {
        options.removeWhere((element) => commands.contains(element));
        options.addAll(commands);
      });
    }
  }

  void showSortModal(BuildContext context) async {
    final t = getTranslation(context, 'modal');

    final Map<String, String?>? values = await showModalBottomSheet(
      context: context,
      builder: (context) => Modal(
        options: const {
          'difficulty': ['ascending', 'descending']
        },
        submitButton: t('sort'),
      ),
    );

    if (values != null) {
      final commands = values.entries
          .map(
            (entry) => createCommand(
              Command.SORT,
              '${entry.key}-${entry.value}',
            ),
          )
          .toList();
      setState(() {
        options.removeWhere((element) => commands.contains(element));
        options.addAll(commands);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    final t = getTranslation(context, 'contests');
    final tListOptions = getTranslation(context, 'listOptions');

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
            return Padding(
              padding: const EdgeInsets.all(5).copyWith(bottom: 0),
              child: CustomScrollView(slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => showSortModal(context),
                            icon: const Icon(Icons.more_horiz_rounded),
                            label: Text(tListOptions('sort')),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => setState(() {
                              view = view == View.GRID ? View.LIST : View.GRID;
                            }),
                            icon: const Icon(Icons.settings),
                            label: Text(tListOptions('view')),
                          ),
                        ],
                      ),
                      ListOptions(
                        options: options,
                        onRemove: handleRemoveOption,
                      ),
                      if (view == View.LIST)
                        Expanded(
                          child: VerticalListView(
                            children: entries
                                .map(
                                  (entry) => ListItem(
                                    title: entry.name,
                                    onTap: () => navigator.pushNamed(
                                      '/contest-overview',
                                      arguments: {'id': entry.id.toString()},
                                    ),
                                    subtitle:
                                        'Duration: ${entry.duration} Starts on: ${entry.startsOn}',
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      if (view == View.GRID)
                        Expanded(
                          child: CustomGridView(
                            children: entries
                                .map(
                                  (entry) => GridItem(
                                    title: entry.name,
                                    onTap: () => navigator.pushNamed(
                                      '/contest-overview',
                                      arguments: {'id': entry.id.toString()},
                                    ),
                                    subtitle:
                                        'Duration: ${entry.duration} Starts on: ${entry.startsOn}',
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                )
              ]),
            );
          }),
    );
  }
}
