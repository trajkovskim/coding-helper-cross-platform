import 'package:coding_helper_cross_platform/src/services/forum/CommentService.dart';
import 'package:coding_helper_cross_platform/src/services/forum/CommunityService.dart';
import 'package:coding_helper_cross_platform/src/services/forum/PostService.dart';
import 'package:coding_helper_cross_platform/src/services/forum/forumAuthService.dart';

initializeForumServices() {
  ForumAuthService.createForumAuthService();

  CommunityService.createCommunityService(ForumAuthService.getInstance());
  PostService.createPostService(ForumAuthService.getInstance());
  CommentService.createCommentService(ForumAuthService.getInstance());
}
