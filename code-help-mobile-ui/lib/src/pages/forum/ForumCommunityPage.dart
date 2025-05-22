import 'package:coding_helper_cross_platform/src/i18n/i18n.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumCommunitySearch.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumOverviewPage.dart';
import 'package:coding_helper_cross_platform/src/services/forum/index.dart';
import 'package:coding_helper_cross_platform/src/services/interceptors.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';
import 'package:flutter/material.dart';

class CommunityPageArguments {
  final String communityName;

  CommunityPageArguments({required this.communityName});
}

class ForumCommunityPage extends StatefulWidget {
  const ForumCommunityPage({super.key});

  static const String routeName = "/community";

  static navigate(BuildContext context, CommunityPageArguments arguments) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  @override
  State<ForumCommunityPage> createState() => _ForumCommunityPageState();
}

class _ForumCommunityPageState extends State<ForumCommunityPage> {
  final _communityService = CommunityService.getInstance();

  final _postService = PostService.getInstance();

  triggerRebuild() {
    setState(() {});
  }

  // triggerReset(String name) {
  //   Navigator.pop(context);
  //   Navigator.pushNamed(context, ForumCommunityPage.routeName, arguments: CommunityPageArguments(communityName: name));
  // }

  showCommentDialog(BuildContext context) async {
    return await showDialog(context: context, builder: (context) => createModalDialog(context));
  }

  Future<bool> showCommunityDeleteDialog(BuildContext context) async {
    return await showDialog(context: context, builder: (context) => createConfirmModalDialog(context));
  }

  handlePost(BuildContext context, String communityName) async {
    final postData = await showCommentDialog(context);

    if (postData == null) {
      return;
    }

    if (postData is PostModalData) {
      await _postService.createPost(communityName, postData.title, postData.text);
      triggerRebuild();
    }
  }

  handleCommunityDelete(BuildContext context, String communityName) async {
    final confirmation = await showCommunityDeleteDialog(context);

    if (!confirmation) {
      return;
    }

    await _communityService.deleteCommunity(communityName);
    return goBack(context);
  }

  handlePostDelete(BuildContext context, String postUid) async {
    await _postService.deletePost(postUid);
    triggerRebuild();
  }

  goBack(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushNamed(context, ForumCommunitySearchPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'message.forum');
    final ft = getTranslation(context, 'forum');

    final CommunityPageArguments args = ModalRoute.of(context)!.settings.arguments as CommunityPageArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(ft("title")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15).copyWith(bottom: 0),
        child: LayoutBuilder(
          builder: (context, constraints) => FutureBuilder<Community?>(
            future: _communityService.getCommunityByName(args.communityName),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                throw t("posts-not-loaded");
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              return SingleChildScrollView(child: PaddedWidgetList(
                padding: const EdgeInsets.all(10),
                children: [
                  Container(
                    height: constraints.maxHeight * 0.5,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: const Offset(0, 0))
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, innerConstraints) => Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: innerConstraints.maxHeight * 0.5,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.25),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                ),
                              ),
                              Container(
                                height: innerConstraints.maxHeight * 0.5,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                CommunityJoinButton(
                                                  communityName: snapshot.data!.name,
                                                  isJoined: snapshot.data!.joined,
                                                ),
                                                SizedBox.fromSize(size: const Size(2, 0)),
                                                CommunityDeleteButton(
                                                  community: snapshot.data!,
                                                  onTap: () => handleCommunityDelete(context, snapshot.data!.name),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 35).copyWith(bottom: 5),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data!.name,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 35),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data!.description,
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 35),
                                        child: Row(
                                          children: [
                                            const Text("Tags: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                            Wrap(
                                              alignment: WrapAlignment.start,
                                              crossAxisAlignment: WrapCrossAlignment.end,
                                              children: snapshot.data?.categories
                                                      ?.map((tag) => TagChip(category: tag))
                                                      .toList() ??
                                                  [],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: (innerConstraints.maxHeight * 0.5) - 45,
                            left: 30,
                            height: 90,
                            width: 90,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ForumCard(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Posts",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () => handlePost(context, args.communityName),
                            icon: const Icon(Icons.add),
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                        ],
                      )),
                  ...((snapshot.data?.posts
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: ForumPostCard(
                                  post: e,
                                  tapDelete: () => handlePostDelete(context, e.uid),
                                ),
                              ))
                          .toList()) ??
                      []),
                ],
              ));
            },
          ),
        ),
      ),
    );
  }
}

class CommunityJoinButton extends StatefulWidget {
  CommunityJoinButton({super.key, required this.communityName, this.isJoined = false});

  final String communityName;
  final bool isJoined;
  final _communityService = CommunityService.getInstance();

  @override
  State<CommunityJoinButton> createState() => _CommunityJoinButtonState();
}

class CommunityDeleteButton extends StatelessWidget {
  const CommunityDeleteButton({super.key, this.onTap, required this.community});

  final Function()? onTap;
  final Community community;

  isAdmin(String username) {
    return username == UserToken.get().getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return isAdmin(community.admin.username)
        ? SizedBox(
            width: 32,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: const Icon(Icons.delete),
            ),
          )
        : Container();
  }
}

class _CommunityJoinButtonState extends State<CommunityJoinButton> {
  bool joined = false;

  @override
  void initState() {
    super.initState();

    joined = widget.isJoined;
  }

  changeJoinStatus(bool newStatus) {
    setState(() {
      joined = newStatus;
    });
  }

  void handleJoin() async {
    widget._communityService
        .joinCommunity(widget.communityName)
        .then((value) => changeJoinStatus(true))
        .catchError(() => print("Some error"));
  }

  void handleLeave() async {
    widget._communityService
        .leaveCommunity(widget.communityName)
        .then((value) => changeJoinStatus(false))
        .catchError(() => print("Some error"));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: joined ? () => handleLeave() : () => handleJoin(),
      child: Text(
        !joined ? "Join" : "Leave",
        style: const TextStyle(fontWeight: FontWeight.bold),
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
                  "New post",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox.fromSize(size: const Size.fromHeight(20)),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Post title', border: OutlineInputBorder()),
              ),
              TextFormField(
                controller: textController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Post content', border: UnderlineInputBorder()),
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
                  backgroundColor: Theme.of(context).colorScheme.error.withAlpha(150),
                ),
                child: const Text("cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context, PostModalData(text: textController.value.text, title: titleController.value.text));
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

createConfirmModalDialog(context) {
  return AlertDialog(
    title: const Text("Confirm Action"),
    content: const Text("This actions will delete the community forever"),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text("Cancel"),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: const Text("Confirm"),
      ),
    ],
  );
}

class PostModalData {
  const PostModalData({required this.text, required this.title});

  final String title;
  final String text;
}
