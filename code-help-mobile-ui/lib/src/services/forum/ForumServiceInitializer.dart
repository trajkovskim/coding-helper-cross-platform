import 'package:coding_helper_cross_platform/src/services/forum/CommentService.dart';
import 'package:coding_helper_cross_platform/src/services/forum/CommunityService.dart';
import 'package:coding_helper_cross_platform/src/services/forum/PostService.dart';

initializeForumServices() {
  CommunityService.createCommunityService();
  PostService.createPostService();
  CommentService.createCommentService();
}
