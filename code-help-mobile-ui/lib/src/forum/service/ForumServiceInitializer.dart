import 'package:coding_helper_cross_platform/src/forum/service/CommentService.dart';
import 'package:coding_helper_cross_platform/src/forum/service/CommunityService.dart';
import 'package:coding_helper_cross_platform/src/forum/service/PostService.dart';
import 'package:coding_helper_cross_platform/src/forum/service/forumAuthService.dart';

initializeForumServices() {
  ForumAuthService.createForumAuthService();

  CommunityService.createCommunityService(ForumAuthService.getInstance());
  PostService.createPostService(ForumAuthService.getInstance());
  CommentService.createCommentService(ForumAuthService.getInstance());
}
