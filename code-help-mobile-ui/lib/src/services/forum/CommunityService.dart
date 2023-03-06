import 'package:coding_helper_cross_platform/src/services/forum/api.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';

class CommunityService {
  static CommunityService? _instance;

  final _communityApi = getCommunityApi();

  static CommunityService getInstance() {
    if (_instance == null) {
      throw Error();
    }

    return _instance!;
  }

  static CommunityService createCommunityService() {
    _instance = CommunityService._construct();

    return getInstance();
  }

  CommunityService._construct();

  Future<ShortCommunities?> getAllCommunities() async {
    return _communityApi.getAllCommunities().then((value) => value.data);
  }

  Future<Community?> getCommunityByName(String name) {
    return _communityApi
        .getCommunityByUid(name: name)
        .then((value) => value.data);
  }

  createCommunity(String name, String description) {
    final communityRequest = CommunityRequestBuilder()
      ..name = name
      ..description = description;

    _communityApi.createCommunity(communityRequest: communityRequest.build());
  }

  updateCommunity(String name, String newName, String newDescription) {
    final communityRequest = CommunityRequestBuilder()
      ..name = "Hello"
      ..description = "Community desc";

    _communityApi.updateCommunity(name: name, communityRequest: communityRequest.build());
  }

  Future<void> joinCommunity(String community) {
    return _communityApi.joinCommunity(community: community);
  }

  Future<void> leaveCommunity(String community) {
    return _communityApi.leaveCommunity(community: community);
  }
}
