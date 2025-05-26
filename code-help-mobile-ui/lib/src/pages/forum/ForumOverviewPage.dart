import 'package:coding_helper_cross_platform/src/context/index.dart';
import 'package:coding_helper_cross_platform/src/services/codehelp/contests_service.dart';
import 'package:coding_helper_cross_platform/src/services/forum/CommunityService.dart';
import 'package:coding_helper_cross_platform/src/services/forum/PostService.dart';
import 'package:coding_helper_cross_platform/src/i18n/i18n.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumCommunitySearch.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumPostPage.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';
import 'package:flutter/material.dart';

import '../../components/common/horizontal_list_view.dart';
import 'ForumCommunityPage.dart';

class ForumOverviewPage extends StatelessWidget {
  ForumOverviewPage({super.key});

  final postService = PostService.getInstance();
  final communityService = CommunityService.getInstance();

  handlePostDelete(BuildContext context, String postUid) async {
    await postService.deletePost(postUid);
    triggerReset(context);
  }

  triggerReset(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/forum-overview');
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final t = getTranslation(context, 'message.forum');
    final ft = getTranslation(context, 'forum');

    handleSearch() {
      ForumCommunitySearchPage.navigate(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(ft("title")),
        actions: [
          IconButton(
            onPressed: handleSearch,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: constraints.maxHeight * 0.235,
                child: FutureBuilder(
                    future: communityService.getAllCommunities(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        throw ErrorCode.HOME;
                      }

                      if (!snapshot.hasData) {
                        return const Card(
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }
                      final entries = snapshot.data!;

                      return HorizontalListView(
                        title: ft('communities'),
                        items: entries.communities
                            .map(
                              (entry) => Item(
                                title: entry.name,
                                image: Icon(Icons.book),
                                onTap: () => ForumCommunityPage.navigate(context, CommunityPageArguments(communityName: entry.name)),
                              ),
                        )
                            .toList(),
                      );
                    },
                  )
                ),
                Padding(padding: EdgeInsets.only(left: 20, top: 10),
                    child: Text(ft('recentPosts'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                FutureBuilder<ShortPosts?>(
                  future: postService.getAllPosts(),
                  builder: (BuildContext context, AsyncSnapshot<ShortPosts?> snapshot) {
                    if (snapshot.hasError) {
                      throw ErrorCode.FORUM_OVERVIEW;
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    return PaddedList<ShortPost>(
                      items: snapshot.data?.posts.toList() ?? [],
                      builder: (context, item) => ForumPostCard(
                        post: item,
                        tapDelete: () => handlePostDelete(context, item.uid),
                      ),
                    );
                  },
                ),
            ],
          ),
        ));
      })
    );
  }
}

class PaddedWidgetList extends StatelessWidget {
  const PaddedWidgetList({
    super.key,
    required this.children,
    this.spacing = 15,
    this.padding = const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    this.controller,
  });

  final List<Widget> children;
  final double spacing;
  final EdgeInsets padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return PaddedList(
      controller: controller,
      items: children,
      padding: padding,
      spacing: spacing,
      builder: (context, item) => item,
    );
  }
}

class PaddedList<T> extends StatelessWidget {
  const PaddedList({
    super.key,
    required this.items,
    required this.builder,
    this.spacing = 15,
    this.padding = const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    this.controller,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item) builder;
  final double spacing;
  final EdgeInsets padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: items.map((item) {
          return [builder(context, item), SizedBox(height: spacing)];
        }).expand((element) => element).toList()
      ),
    );
    // ListView.separated(
    //   physics: const AlwaysScrollableScrollPhysics(),
    //   controller: controller,
    //   itemCount: items.length,
    //   scrollDirection: Axis.vertical,
    //   padding: padding,
    //   shrinkWrap: true,
    //   itemBuilder: (context, index) => builder(context, items[index]),
    //   separatorBuilder: (BuildContext context, int index) => SizedBox(height: spacing),
    // );
  }
}

class ForumPostCard extends StatelessWidget {
  const ForumPostCard({super.key, required this.post, this.tapDelete});

  final ShortPost post;
  final Function()? tapDelete;

  @override
  Widget build(BuildContext context) {
    handleTap(String uid) {
      ForumPostPage.navigate(context, PostPageArguments(postUid: uid));
    }

    return ForumCard(
      onTap: () => handleTap(post.uid),
      child: ForumCardPostData(
        title: post.title,
        content: post.title,
        username: post.user.username,
        tapDelete: tapDelete,
      ),
    );
  }
}

class ForumCard extends StatelessWidget {
  const ForumCard(
      {super.key,
      this.onTap,
      required this.child,
      this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10)});

  final Function()? onTap;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Card(
        shadowColor: theme.primaryColor,
        child: Container(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class ForumCardPostData extends StatelessWidget {
  const ForumCardPostData(
      {super.key, required this.title, required this.content, required this.username, this.tapDelete});

  final String title;
  final String content;
  final String username;

  final Function()? tapDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Wrap(
        spacing: 15,
        direction: Axis.vertical,
        children: [
          SizedBox(
            width: constraints.maxWidth,
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.black12,
                      radius: 15,
                    ),
                    Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: PopupMenuButton(
                    padding: const EdgeInsets.only(left: 15),
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        onTap: tapDelete,
                        child: Container(
                          alignment: Alignment.center,
                          child: const Icon(Icons.delete),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(content),
        ],
      ),
    );
  }
}
