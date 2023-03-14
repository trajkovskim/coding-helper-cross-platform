import 'package:coding_helper_cross_platform/src/components/common/SearchSettings.dart';
import 'package:coding_helper_cross_platform/src/components/common/grid_view.dart';
import 'package:coding_helper_cross_platform/src/components/common/list_options.dart';
import 'package:coding_helper_cross_platform/src/components/common/search_input.dart';
import 'package:coding_helper_cross_platform/src/components/common/vertical_list_view.dart';
import 'package:coding_helper_cross_platform/src/services/forum/CommunityService.dart';
import 'package:coding_helper_cross_platform/src/i18n/i18n.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumCommunityPage.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';
import 'package:flutter/material.dart';

class ForumCommunitySearchPage extends StatefulWidget {
  const ForumCommunitySearchPage({Key? key}) : super(key: key);

  static const String routeName = "/community-search";

  static navigate(BuildContext context) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  State<ForumCommunitySearchPage> createState() => _ForumCommunitySearchPageState();
}

class _ForumCommunitySearchPageState extends State<ForumCommunitySearchPage> {
  String? searchTerm;
  View view = View.LIST;
  List<String> options = [];
  final _communityService = CommunityService.getInstance();

  handleSearch(String term) {
    final option = createCommand(Command.SEARCH, term);
    options.removeWhere((element) => element == option);
    setState(() {
      searchTerm = term;
      options.add(createCommand(Command.SEARCH, term));
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

  handleCommunityCreation(BuildContext context) async {
    final communityData = await showCommentDialog(context);

    if (communityData == null) {
      return;
    }

    if (communityData is CommunityModalData) {
      await _communityService.createCommunity(communityData.name, communityData.description);
      triggerRebuild();
    }
  }

  showCommentDialog(BuildContext context) async {
    return await showDialog(context: context, builder: (context) => createModalDialog(context));
  }

  triggerRebuild() {
    setState(() {});
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
        child: SingleChildScrollView(
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
                    if (snapshot.hasError) {
                      throw 'No data';
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }

                    return ViewList(
                      communities: snapshot.data!,
                      view: view,
                    );
                  })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => handleCommunityCreation(context),
        child: const Icon(Icons.add),
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
        child: VerticalListView(
          children: communities.communities
              .map(
                (entry) => ListItem.withSubContent(
                  title: entry.name,
                  onTap: () => ForumCommunityPage.navigate(context, CommunityPageArguments(communityName: entry.name)),
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
      );
    }

    if (view == View.GRID) {
      return CustomGridView(
        children: communities.communities
            .map(
              (entry) => GridItem(
                title: entry.name,
                onTap: () => {},
                subtitle: entry.description,
              ),
            )
            .toList(),
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
  }
}

createModalDialog(context) {
  final textController = TextEditingController();
  final titleController = TextEditingController();

  return Dialog(
    child: Container(
      padding: const EdgeInsets.all(20),
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "New community",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox.fromSize(size: const Size.fromHeight(20)),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Community name', border: OutlineInputBorder()),
              ),
              TextFormField(
                controller: textController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description', border: UnderlineInputBorder()),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).errorColor.withAlpha(150),
                ),
                child: const Text("cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context,
                      CommunityModalData(name: titleController.value.text, description: textController.value.text));
                },
                child: const Text("Submit"),
              )
            ],
          )
        ],
      ),
    ),
  );
}

class CommunityModalData {
  final String name;
  final String description;

  const CommunityModalData({
    required this.name,
    required this.description,
  });
}
