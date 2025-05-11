import 'package:built_collection/src/list.dart';
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
    return await _communityApi.getAllCommunities().then((value) => value.data);
  }

  Future<Community?> getCommunityByName(String name) async {
    return await _communityApi.getCommunityByUid(name: name).then((value) => value.data);
  }

  Future<Community?> createCommunity(String name, String description) async {
    final ss = CommunityRequestCategoriesBuilder()..uids = ListBuilder<String>();
    final communityRequest = CommunityRequestBuilder()
      ..name = name
      ..description = description
      ..categories = ss;

    return await _communityApi.createCommunity(communityRequest: communityRequest.build()).then((value) => value.data);
  }

  updateCommunity(String name, String newName, String newDescription) async {
    final communityRequest = CommunityRequestBuilder()
      ..name = "Hello"
      ..description = "Community desc";

    return _communityApi.updateCommunity(name: name, communityRequest: communityRequest.build());
  }

  deleteCommunity(String name) async {
    return await _communityApi.deleteCommunity(name: name);
  }

  joinCommunity(String community) async {
    return await _communityApi.joinCommunity(name: community);
  }

  leaveCommunity(String community) async {
    return await _communityApi.leaveCommunity(name: community);
  }
}
