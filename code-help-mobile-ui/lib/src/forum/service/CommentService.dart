import 'package:coding_helper_cross_platform/src/forum/api.dart';
import 'package:coding_helper_cross_platform/src/forum/service/forumAuthService.dart';
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
}
