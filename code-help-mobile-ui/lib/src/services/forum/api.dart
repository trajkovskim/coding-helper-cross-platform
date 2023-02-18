import 'package:coding_helper_cross_platform/src/services/interceptors.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';
import 'package:dio/dio.dart';

const _forumUrl = String.fromEnvironment('CODING_HELPER_FORUM_API_URL');

final dioAuth = Dio(
  BaseOptions(
    baseUrl: "$_forumUrl/api",
  ),
);

final dio = Dio(
  BaseOptions(
    baseUrl: "$_forumUrl/api/v1",
  ),
);

final _forumAuth = CodingHelperForumApi(dio: dioAuth);
final _forumApi = CodingHelperForumApi(dio: dio);

final _forumAuthApi = _forumAuth.getAuthApi();
final _communityApi = _forumApi.getCommunityApi();
final _postApi = _forumApi.getPostApi();
final _commentApi = _forumApi.getCommentApi();
final _categoryApi = _forumApi.getCategoryApi();


AuthApi getForumAuthApi() {
  return _forumAuthApi;
}

CommunityApi getCommunityApi() {
  return _communityApi;
}

PostApi getPostApi() {
  return _postApi;
}

CommentApi getCommentApi() {
  return _commentApi;
}

CategoryApi getCategoryApi() {
  return _categoryApi;
}