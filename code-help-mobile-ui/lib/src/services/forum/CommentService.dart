import 'package:coding_helper_cross_platform/src/services/forum/api.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';

class CommentService {
  static CommentService? _instance;

  final _commentApi = getCommentApi();

  static CommentService getInstance() {
    if (_instance == null) {
      throw Error();
    }

    return _instance!;
  }

  static CommentService createCommentService() {
    _instance = CommentService._construct();

    return getInstance();
  }

  CommentService._construct();

  Future<Comments?> getPostComments(String postUid) async {
    return _commentApi
        .getCommentsForPost(
          post: postUid,
        )
        .then((value) => value.data);
  }

  Future<Comments?> getCommentReplies(String parentCommentUid) async {
    return _commentApi
        .getCommentReplies(
          uid: parentCommentUid,
        )
        .then((value) => value.data);
  }

  Future<Comment?> createComment(String post, String commentContent) async {
    final comment = CommentRequestBuilder()..content = commentContent;

    return await _commentApi.commentOnPost(post: post, commentRequest: comment.build()).then((value) => value.data);
  }

  Future<Comment?> replyToComment(String commentUid, String commentContent) async {
    final comment = CommentRequestBuilder()..content = commentContent;

    return await _commentApi
        .replyToComment(
          uid: commentUid,
          commentRequest: comment.build(),
        )
        .then((value) => value.data);
  }

  deleteComment(String commentUid) async {
    return _commentApi.deleteComment(uid: commentUid);
  }
}
