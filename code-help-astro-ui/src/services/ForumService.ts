import type { ConfigurationParameters } from '../generated/forum-api';
import { CategoryApi, CommunityApi, Configuration, PostApi } from '../generated/forum-api';

type Pagination = {
  page: number;
  size: number;
  sortBy: string[];
};

export default class ForumService {
  private categoryApi;
  private communityApi;
  private postsApi;

  constructor(configurationParameters: ConfigurationParameters) {
    const configuration = new Configuration(configurationParameters);

    this.categoryApi = new CategoryApi(configuration);
    this.communityApi = new CommunityApi(configuration);
    this.postsApi = new PostApi(configuration);
  }

  getCategories() {
    return this.categoryApi.getAllCategories();
  }

  getCommunities(pagination?: Pagination) {
    return this.communityApi.getAllCommunities({ ...pagination });
  }

  getPosts(pagination?: Pagination) {
    return this.postsApi.getPosts({ ...pagination });
  }
}
