import 'package:coding_helper_cross_platform/src/services/forum/api.dart';
import 'package:coding_helper_cross_platform/src/services/forum/forumAuthService.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';

class CommentService {
  static CommentService? _instance;

  final _commentApi = getCommentApi();

  final ForumAuthService _forumAuthService;

  static CommentService getInstance() {
    if (_instance == null) {
      throw Error();
    }

    return _instance!;
  }

  static CommentService createCommentService(ForumAuthService forumAuthService) {
    _instance = CommentService._construct(forumAuthService);

    return getInstance();
  }

  CommentService._construct(this._forumAuthService);

  Future<Comments?> getPostComments(String postUid) async {
    return _forumAuthService
        .requestWithAuth((header) => _commentApi.getCommentsForPost(post: postUid, headers: header))
        .then((value) => value.data);
  }

  Future<Comments?> getCommentReplies(String parentCommentUid) async {
    return _forumAuthService
        .requestWithAuth((header) => _commentApi.getCommentReplies(uid: parentCommentUid, headers: header))
        .then((value) => value.data);
  }

  createComment(String post, String commentContent) {
    final comment = CommentRequestBuilder()..content = commentContent;

    _forumAuthService
        .requestWithAuth(
          (header) => _commentApi.commentOnPost(post: post, commentRequest: comment.build(), headers: header),
        )
        .then((value) => value.data);
  }

  replyToComment(String commentUid, String commentContent) {
    final comment = CommentRequestBuilder()..content = commentContent;

    _forumAuthService.requestWithAuth(
        (header) => _commentApi.replyToComment(uid: commentUid, commentRequest: comment.build(), headers: header));
  }

  deleteComment(String commentUid) {
    _forumAuthService.requestWithAuth((header) => _commentApi.deleteComment(uid: commentUid, headers: header));
  }
}
