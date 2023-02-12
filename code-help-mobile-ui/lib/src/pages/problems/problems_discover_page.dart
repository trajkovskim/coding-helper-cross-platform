import 'package:coding_helper_cross_platform/src/components/common/SearchSettings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/common/grid_view.dart';
import '../../components/common/list_options.dart';
import '../../components/common/search_input.dart';
import '../../components/common/vertical_list_view.dart';
import '../../context/index.dart';
import '../../i18n/i18n.dart';
import '../../services/index.dart';

class ProblemsDiscoverPage extends StatefulWidget {
  const ProblemsDiscoverPage({super.key});

  @override
  State<ProblemsDiscoverPage> createState() => _ProblemsDiscoverPageState();
}

class _ProblemsDiscoverPageState extends State<ProblemsDiscoverPage> {
  final problemsService = const ProblemsService();

  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  bool init = false;
  bool loading = false;
  View view = View.LIST;

  List<String> options = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      return;
    }
    setState(() {
      loading = true;
    });
    final problemsContext = Provider.of<ProblemsContext>(context, listen: false);
    problemsService
        .getProblemEntries()
        .then((entries) => problemsContext.setProblems(entries))
        .onError(
          (error, stackTrace) => handleError(context, ErrorCode.PROBLEMS),
        )
        .whenComplete(
      () {
        init = true;
        setState(() {
          loading = false;
        });
      },
    );
  }

  void handleTapSearch() {
    if (searchController.text.isEmpty) {
      return;
    }

    String command = createCommand(Command.SEARCH, searchController.text.trim());
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

  void handleFilterSubmit(List<String> commands) {
    setState(() {
      options.removeWhere((element) => commands.contains(element));
      options.addAll(commands);
    });
  }

  void handleSortSubmit(List<String> commands) {
    setState(() {
      options.removeWhere((element) => commands.contains(element));
      options.addAll(commands);
    });
  }

  void handleViewModeChange(View newViewMode) {
    setState(() {
      view = newViewMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final problemsContext = Provider.of<ProblemsContext>(context);
    final navigator = Navigator.of(context);
    final problems = problemsContext.entries;

    final t = getTranslation(context, 'problems.discover');

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
      body: loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: const EdgeInsets.all(15).copyWith(bottom: 0),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SearchSettingsRow(
                          handleFilterSubmit: handleFilterSubmit,
                          handleSortSubmit: handleSortSubmit,
                          handleViewModeChange: handleViewModeChange,
                          viewMode: view,
                        ),
                        SizedBox.fromSize(size: const Size.fromHeight(15)),
                        ListOptions(
                          options: options,
                          onRemove: handleRemoveOption,
                        ),
                        SizedBox.fromSize(size: const Size.fromHeight(15)),
                        if (view == View.LIST)
                          Container(
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Expanded(
                              child: VerticalListView(
                                children: problems
                                    .map(
                                      (entry) => ListItem(
                                        title: entry.title,
                                        onTap: () => navigator.pushNamed(
                                          '/problem-overview',
                                          arguments: {'id': entry.id.toString()},
                                        ),
                                        subtitle: entry.markdown,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        if (view == View.GRID)
                          Expanded(
                            child: CustomGridView(
                              children: problems
                                  .map(
                                    (entry) => GridItem(
                                      title: entry.title,
                                      onTap: () => navigator.pushNamed(
                                        '/problem-overview',
                                        arguments: {'id': entry.id.toString()},
                                      ),
                                      subtitle: entry.markdown,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
