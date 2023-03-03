import 'package:coding_helper_cross_platform/src/services/forum/api.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';

class PostService {
  static PostService? _instance;

  final _postApi = getPostApi();

  static PostService getInstance() {
    if (_instance == null) {
      throw Error();
    }

    return _instance!;
  }

  static PostService createPostService() {
    _instance = PostService._construct();

    return getInstance();
  }

  PostService._construct();

  Future<ShortPosts?> getAllPosts({String? community}) async {
    return _postApi.getPosts(community: community).then((value) => value.data);
  }

  Future<Post?> getPostByUid(String postUid) async {
    return _postApi.getPost(uid: postUid).then((value) => value.data);
  }

  createPost(String communityUid, String postTitle, String postText) {
    final postRequest = PostRequestBuilder()
      ..title = postTitle
      ..content = postText;

    _postApi.createCommunityPost(
      community: communityUid,
      postRequest: postRequest.build(),
    );
  }
}
