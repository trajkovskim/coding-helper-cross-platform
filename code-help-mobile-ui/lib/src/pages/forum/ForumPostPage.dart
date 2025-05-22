import 'package:coding_helper_cross_platform/src/services/forum/CommentService.dart';
import 'package:coding_helper_cross_platform/src/services/forum/PostService.dart';
import 'package:coding_helper_cross_platform/src/i18n/i18n.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumOverviewPage.dart';
import 'package:coding_helper_cross_platform/src/services/interceptors.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostPageArguments {
  final String postUid;

  PostPageArguments({required this.postUid});
}

class ForumPostPage extends StatefulWidget {
  const ForumPostPage({super.key});

  static const routeName = "/post";

  static navigate(BuildContext context, PostPageArguments args) {
    Navigator.pushNamed(context, ForumPostPage.routeName, arguments: args);
  }

  @override
  State<ForumPostPage> createState() => _ForumPostPageState();
}

class _ForumPostPageState extends State<ForumPostPage> {
  final postService = PostService.getInstance();

  final commentService = CommentService.getInstance();

  triggerRebuild() {
    setState(() {});
  }


  showCommentDialog(BuildContext context) async {
    return await showDialog(context: context, builder: (context) => createModalDialog(context));
  }

  handleCommentCreation(BuildContext context, String postUid) async {
    var data = await showCommentDialog(context);

    if (data != null) {
      await commentService.createComment(postUid, data);
      triggerRebuild();
    }
  }



  handleCommentReply(BuildContext context, String commentUid) async {
    var data = await showCommentDialog(context);

    if (data != null) {
      await commentService.replyToComment(commentUid, data);
      triggerRebuild();
    }
  }

  handleCommentDelete(String commentUid) async {
    await commentService.deleteComment(commentUid);
    triggerRebuild();
  }

  handlePostDelete(BuildContext context, String postUid) async {
    await postService.deletePost(postUid);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'message.forum');
    final ft = getTranslation(context, 'forum');
    final args = ModalRoute.of(context)!.settings.arguments as PostPageArguments;

    ScrollController controller = ScrollController();
    ScrollController commentController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text(ft("title")),
      ),
      body: FutureBuilder<PostWithComments>(
        future: Future.wait([postService.getPostByUid(args.postUid), commentService.getPostComments(args.postUid)])
            .then((value) => PostWithComments(value[0] as Post, value[1] as Comments)),
        builder: (BuildContext context, AsyncSnapshot<PostWithComments> snapshot) {
          if (snapshot.hasError) {
            throw t("posts-not-loaded");
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          final post = snapshot.data!.post;
          final comments = snapshot.data!.comments;

          return SingleChildScrollView(child: PaddedWidgetList(
            controller: controller,
            spacing: 25,
            children: [
              ForumCard(
                child: ForumCardPostData(
                    title: post.title,
                    content: post.content,
                    username: post.user.username,
                    tapDelete: () => handlePostDelete(context, post.uid)),
              ),
              ForumCard(
                child: SizedBox(
                  height: 38,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Comments",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      IconButton(
                        onPressed: () => handleCommentCreation(context, args.postUid),
                        icon: const Icon(Icons.add_comment),
                      )
                    ],
                  ),
                ),
              ),
              NotificationListener<OverscrollNotification>(
                onNotification: (OverscrollNotification value) => handleInnerListScroll(value, controller),
                child: PaddedWidgetList(
                  controller: commentController,
                  padding: EdgeInsets.zero,
                  children: comments.comments!
                      .map((comment) => CommentWithReplies(
                            comment: comment,
                            onReply: (commentUid) => handleCommentReply(context, commentUid),
                            onDelete: (commentUid) => handleCommentDelete(commentUid),
                          ))
                      .toList(),
                ),
              )
            ],
          ));
        },
      ),
    );
  }
}

class ForumCardCommentData extends StatelessWidget {
  const ForumCardCommentData(
      {super.key, required this.comment, this.onTap, required this.onReply, required this.onDelete});

  final Comment comment;

  final Function()? onTap;
  final Function(String commentUid) onReply;
  final Function(String commentUid) onDelete;

  isAuthorizedToDelete(String username) {
    return username == UserToken.get().getUsername();
  }

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'forum.comment');

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: Wrap(
            spacing: 15,
            direction: Axis.vertical,
            children: [
              Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.black12,
                    radius: 15,
                  ),
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                      Text(
                        comment.user.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${timeago.format(comment.modified)} ${comment.modified != comment.created ? "(${t("edited")})" : ""}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
              Text(comment.content, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(
                width: constraints.maxWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: onTap,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text("Replies ${comment.replies?.count ?? 0}"),
                      // TODO: add translation
                    ),
                    SizedBox(
                      width: 32,
                      child: IconButton(
                        onPressed: () => onReply(comment.uid),
                        padding: EdgeInsets.zero,
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(38, 38),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.comment),
                        // child: Text("Replies ${comment.replies?.count ?? 0}"),
                      ),
                    ),
                    ...(isAuthorizedToDelete(comment.user.username)
                        ? [
                            SizedBox(
                              width: 32,
                              child: IconButton(
                                onPressed: () => onDelete(comment.uid),
                                style: IconButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: const Icon(Icons.delete),
                                // child: Text("Replies ${comment.replies?.count ?? 0}"),
                              ),
                            )
                          ]
                        : []),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class CommentWithReplies extends StatefulWidget {
  CommentWithReplies({
    super.key,
    this.scrollController,
    required this.comment,
    this.level = 1,
    this.replies = false,
    required this.onReply,
    required this.onDelete,
  });

  final ScrollController? scrollController;
  final Comment comment;
  final double level;

  final Function(String commentUid) onReply;
  final Function(String commentUid) onDelete;

  bool replies = false;

  @override
  State<CommentWithReplies> createState() => _CommentWithRepliesState();
}

class _CommentWithRepliesState extends State<CommentWithReplies> {
  showReplies() {
    setState(() {
      widget.replies = !widget.replies;
    });
  }

  final commentService = CommentService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      spacing: widget.replies ? 8 : 0,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 60,
          padding: EdgeInsets.only(left: 12.5 * (widget.level - 1)),
          child: ForumCard(
            onTap: showReplies,
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 0),
            child: ForumCardCommentData(
              comment: widget.comment,
              onTap: showReplies,
              onReply: widget.onReply,
              onDelete: widget.onDelete,
            ),
          ),
        ),
        ...(widget.replies
            ? [
                FutureBuilder<Comments?>(
                  future: commentService.getCommentReplies(widget.comment.uid),
                  builder: (BuildContext context, AsyncSnapshot<Comments?> snapshot) {
                    if (!snapshot.hasData) {
                      return Container(padding: EdgeInsets.zero);
                    }

                    var replies = snapshot.data?.comments!;
                    return Column(
                      children: replies
                              ?.map(
                                (comment) => CommentWithReplies(
                                  comment: comment,
                                  replies: false,
                                  level: widget.level + 1,
                                  onReply: widget.onReply,
                                  onDelete: widget.onDelete,
                                ),
                              )
                              .toList() ??
                          [],
                    );
                  },
                )
              ]
            : [])
      ],
    );
  }
}

handleInnerListScroll(OverscrollNotification value, ScrollController controller) {
  if (value.overscroll < 0 && controller.offset + value.overscroll <= 0) {
    if (controller.offset != 0) controller.jumpTo(0);
    return true;
  }
  if (controller.offset + value.overscroll >= controller.position.maxScrollExtent) {
    if (controller.offset != controller.position.maxScrollExtent) {
      controller.jumpTo(controller.position.maxScrollExtent);
    }
    return true;
  }
  controller.jumpTo(controller.offset + value.overscroll);
  return true;
}

class PostWithComments {
  final Post post;
  final Comments comments;

  PostWithComments(this.post, this.comments);
}

createModalDialog(context) {
  final controller = TextEditingController();

  return Dialog(
    child: Container(
      padding: const EdgeInsets.all(20),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "New comment",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                controller: controller,
                maxLines: 3,
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
                  Navigator.pop(context, controller.value.text);
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
