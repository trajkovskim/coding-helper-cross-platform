import 'package:coding_helper_cross_platform/src/forum/service/CommentService.dart';
import 'package:coding_helper_cross_platform/src/forum/service/PostService.dart';
import 'package:coding_helper_cross_platform/src/i18n/i18n.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumOverviewPage.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ForumPostPage extends StatelessWidget {
  ForumPostPage({Key? key, required this.postUid}) : super(key: key);

  final String postUid;
  final postService = PostService.getInstance();
  final commentService = CommentService.getInstance();

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'message.forum');

    ScrollController controller = ScrollController();
    ScrollController commentController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
      ),
      body: FutureBuilder<PostWithComments>(
        future: Future.wait([postService.getPostByUid(postUid), commentService.getPostComments(postUid)])
            .then((value) => PostWithComments(value[0] as Post, value[1] as Comments)),
        builder: (BuildContext context, AsyncSnapshot<PostWithComments> snapshot) {
          if (snapshot.hasData) {
            final post = snapshot.data!.post;
            final comments = snapshot.data!.comments;

            return PaddedWidgetList(
              controller: controller,
              spacing: 25,
              children: [
                ForumCard(
                  child: ForumCardPostData(title: post.title, content: post.content, username: post.user.username),
                ),
                const ForumCard(child: Text("Comments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                NotificationListener<OverscrollNotification>(
                  onNotification: (OverscrollNotification value) => handleInnerListScroll(value, controller),
                  child: PaddedWidgetList(
                    controller: commentController,
                    padding: EdgeInsets.zero,
                    children: comments.comments!.map((comment) => CommentWithReplies(comment: comment)).toList(),
                  ),
                )
              ],
            );
          }

          return Container(
            alignment: Alignment.center,
            child: Text(t("posts-not-loaded")),
          );
        },
      ),
    );
  }
}

class ForumCardCommentData extends StatelessWidget {
  const ForumCardCommentData({Key? key, required this.comment, this.onTap}) : super(key: key);

  final Comment comment;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'forum.comment');

    return Wrap(
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
        Container(
          // color: Colors.black,
          width: 310,
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text("Replies"),
            // TODO: add translation
          ),
        )
      ],
    );
  }
}

class CommentWithReplies extends StatefulWidget {
  CommentWithReplies({
    Key? key,
    this.scrollController,
    required this.comment,
    this.level = 1,
    this.replies = false,
  }) : super(key: key);
  final ScrollController? scrollController;
  final Comment comment;
  final double level;

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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      spacing: widget.replies ? 8 : 0,
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 60,
          padding: EdgeInsets.only(left: 10 * (widget.level - 1)),
          child: ForumCard(
            onTap: showReplies,
            child: ForumCardCommentData(comment: widget.comment),
          ),
        ),
        // replies ?
        //  CommentWithReplies(comment: comment) :
        widget.replies
            ? CommentWithReplies(
                comment: widget.comment,
                replies: false,
                level: widget.level + 1,
              )
            : Container(padding: EdgeInsets.zero)
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
