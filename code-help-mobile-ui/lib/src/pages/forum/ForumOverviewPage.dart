import 'package:coding_helper_cross_platform/src/context/index.dart';
import 'package:coding_helper_cross_platform/src/services/forum/PostService.dart';
import 'package:coding_helper_cross_platform/src/i18n/i18n.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumCommunitySearch.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumPostPage.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';
import 'package:flutter/material.dart';

class ForumOverviewPage extends StatelessWidget {
  ForumOverviewPage({Key? key}) : super(key: key);

  final postService = PostService.getInstance();

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
      body: FutureBuilder<ShortPosts?>(
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
            items: snapshot.data?.posts?.toList() ?? [],
            builder: (context, item) => ForumPostCard(
              post: item,
              tapDelete: () => handlePostDelete(context, item.uid),
            ),
          );
        },
      ),
    );
  }
}

class PaddedWidgetList extends StatelessWidget {
  const PaddedWidgetList({
    Key? key,
    required this.children,
    this.spacing = 15,
    this.padding = const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    this.controller,
  }) : super(key: key);

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
    Key? key,
    required this.items,
    required this.builder,
    this.spacing = 15,
    this.padding = const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    this.controller,
  }) : super(key: key);

  final List<T> items;
  final Widget Function(BuildContext context, T item) builder;
  final double spacing;
  final EdgeInsets padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: controller,
      itemCount: items.length,
      scrollDirection: Axis.vertical,
      padding: padding,
      shrinkWrap: true,
      itemBuilder: (context, index) => builder(context, items[index]),
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: spacing),
    );
  }
}

class ForumPostCard extends StatelessWidget {
  const ForumPostCard({Key? key, required this.post, this.tapDelete}) : super(key: key);

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
      {Key? key,
      this.onTap,
      required this.child,
      this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10)})
      : super(key: key);

  final Function()? onTap;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Card(
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            child: Container(
              padding: padding,
              color: Colors.transparent,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class ForumCardPostData extends StatelessWidget {
  const ForumCardPostData(
      {Key? key, required this.title, required this.content, required this.username, this.tapDelete})
      : super(key: key);

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
                          alignment: Alignment.centerRight,
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
