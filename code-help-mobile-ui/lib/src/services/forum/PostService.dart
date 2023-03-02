import 'package:coding_helper_cross_platform/src/services/forum/api.dart';
import 'package:coding_helper_cross_platform/src/services/forum/forumAuthService.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';

class PostService {
  static PostService? _instance;

  final _postApi = getPostApi();

  final ForumAuthService _forumAuthService;

  static PostService getInstance() {
    if (_instance == null) {
      throw Error();
    }

    return _instance!;
  }

  static PostService createPostService(ForumAuthService forumAuthService) {
    _instance = PostService._construct(forumAuthService);

    return getInstance();
  }

  PostService._construct(this._forumAuthService);

  Future<ShortPosts?> getAllPosts({String? community}) async {
    return _forumAuthService
        .requestWithAuth((header) => _postApi.getPosts(community: community, headers: header))
        .then((value) => value.data);
  }

  Future<Post?> getPostByUid(String postUid) async {
    return _forumAuthService
        .requestWithAuth((header) => _postApi.getPost(uid: postUid, headers: header))
        .then((value) => value.data);
  }

  createPost(String communityUid, String postTitle, String postText) {
    final postRequest = PostRequestBuilder()
      ..title = postTitle
      ..content = postText;

    _forumAuthService.requestWithAuth((header) =>
        _postApi.createCommunityPost(community: communityUid, postRequest: postRequest.build(), headers: header));
  }
}
