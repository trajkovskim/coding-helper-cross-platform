import 'package:coding_helper_cross_platform/src/components/common/SearchSettings.dart';
import 'package:coding_helper_cross_platform/src/components/common/grid_view.dart';
import 'package:coding_helper_cross_platform/src/components/common/list_options.dart';
import 'package:coding_helper_cross_platform/src/components/common/search_input.dart';
import 'package:coding_helper_cross_platform/src/components/common/vertical_list_view.dart';
import 'package:coding_helper_cross_platform/src/forum/service/CommunityService.dart';
import 'package:coding_helper_cross_platform/src/i18n/i18n.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumCommunityPage.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';
import 'package:flutter/material.dart';

class ForumCommunitySearchPage extends StatefulWidget {
  const ForumCommunitySearchPage({Key? key}) : super(key: key);

  @override
  State<ForumCommunitySearchPage> createState() => _ForumCommunitySearchPageState();
}

class _ForumCommunitySearchPageState extends State<ForumCommunitySearchPage> {
  String? searchTerm;
  View view = View.LIST;
  List<String> options = [];

  handleSearch(String term) {
    setState(() {
      searchTerm = term;
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
    final ft = getTranslation(context, 'forum');
    final communityService = CommunityService.getInstance();

    return Scaffold(
      appBar: SearchAppBar(
        title: ft("community.search"),
        onSearch: handleSearch,
      ),
      body: Padding(
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
                  FutureBuilder<ShortCommunities?>(
                      future: communityService.getAllCommunities(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ViewList(
                            communities: snapshot.data!,
                            view: view,
                          );
                        }

                        return const Text("No data");
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ViewList extends StatelessWidget {
  const ViewList({Key? key, required this.view, required this.communities}) : super(key: key);

  final View view;
  final ShortCommunities communities;

  @override
  Widget build(BuildContext context) {
    if (view == View.LIST) {
      return Container(
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Expanded(
          child: VerticalListView(
            children: communities.communities
                .map(
                  (entry) => ListItem.withSubContent(
                    title: entry.name,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForumCommunityPage(
                                  communityName: entry.name,
                                ))),
                    subContent: Row(
                      children: [
                        const Text("Tags: "),
                        Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: entry.categories?.map((tag) => TagChip(category: tag)).toList() ?? []),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }

    if (view == View.GRID) {
      return Expanded(
        child: CustomGridView(
          children: communities.communities
              .map(
                (entry) => GridItem(
                  title: entry.name,
                  onTap: () => {},
                  subtitle: entry.description.substring(0, 20),
                ),
              )
              .toList(),
        ),
      );
    }

    return const Text("No data");
  }
}

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  SearchAppBar({Key? key, required this.title, this.onSearch}) : super(key: key);
  final String title;
  final Function(String term)? onSearch;

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size preferredSize = AppBar().preferredSize;
}

class _SearchAppBarState extends State<SearchAppBar> {
  final TextEditingController searchController = TextEditingController();
  var showSearch = true;

  handleClearSearch() {
    setState(() {
      showSearch = false;
    });
  }

  handleTapSearch() {
    setState(() {
      showSearch = true;
    });

    if (searchController.text.isEmpty) {
      return;
    }

    widget.onSearch!(searchController.text);

    searchController.clear();
  }

  handleSearch() {
    if (!showSearch) {
      setState(() {
        showSearch = true;
      });
    } else {
      handleTapSearch();
    }
  }

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: !showSearch
          ? Text(widget.title)
          : SearchInput(controller: searchController, onClear: handleClearSearch, onSubmit: handleTapSearch),
      actions: [
        IconButton(
          onPressed: handleSearch,
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}

class TagChip extends StatelessWidget {
  const TagChip({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 1),
              spreadRadius: -4,
              blurStyle: BlurStyle.normal),
        ],
      ),
      child: Card(
        shadowColor: Colors.transparent,
        color: const Color.fromRGBO(226, 233, 255, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 3,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
