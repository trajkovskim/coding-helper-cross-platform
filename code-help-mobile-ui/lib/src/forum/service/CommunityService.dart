import 'package:coding_helper_cross_platform/src/forum/api.dart';
import 'package:coding_helper_cross_platform/src/forum/service/forumAuthService.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';

class CommunityService {
  static CommunityService? _instance;

  final _communityApi = getCommunityApi();

  final ForumAuthService _forumAuthService;

  static CommunityService getInstance() {
    if (_instance == null) {
      throw Error();
    }

    return _instance!;
  }

  static CommunityService createCommunityService(ForumAuthService forumAuthService) {
    _instance = CommunityService._construct(forumAuthService);

    return getInstance();
  }

  CommunityService._construct(this._forumAuthService);

  Future<ShortCommunities?> getAllCommunities() async {
    return _forumAuthService
        .requestWithAuth((header) => _communityApi.getAllCommunities(headers: header))
        .then((value) => value.data);
  }

  getCommunityByName(String name) {
    _forumAuthService.requestWithAuth((headers) => _communityApi.getCommunityByUid(name: name, headers: headers));
  }

  createCommunity(String name, String description) {
    final communityRequest = CommunityRequestBuilder()
      ..name = name
      ..description = description;

    _forumAuthService.requestWithAuth(
        (headers) => _communityApi.createCommunity(communityRequest: communityRequest.build(), headers: headers));
  }

  updateCommunity(String name, String newName, String newDescription) {
    final communityRequest = CommunityRequestBuilder()
      ..name = "Hello"
      ..description = "Community desc";

    _forumAuthService.requestWithAuth(
        (headers) => _communityApi.updateCommunity(name: name, body: communityRequest.build(), headers: headers));
  }
}
